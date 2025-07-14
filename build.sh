#!/bin/bash

# Currency Conversion Web Service - Complete Build & Deploy Script
# This script builds and deploys everything needed for the application

echo "============================================="
echo "Currency Conversion Web Service Deployment"
echo "============================================="

# Configuration
TOMCAT_HOME="../apache-tomcat-9.0.100"
SERVER_PORT=8000
CLIENT_SERVER_PORT=8090
PROJECT_DIR=$(pwd)

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_url() {
    echo -e "${BLUE}[URL]${NC} $1"
}

# Function to check if a port is in use
check_port() {
    local port=$1
    # Try multiple methods to check if port is in use
    if command -v lsof >/dev/null 2>&1; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            return 0  # Port is in use
        fi
    fi
    
    # Alternative: try netstat
    if command -v netstat >/dev/null 2>&1; then
        if netstat -ln 2>/dev/null | grep ":$port " >/dev/null; then
            return 0  # Port is in use
        fi
    fi
    
    # Alternative: try ss
    if command -v ss >/dev/null 2>&1; then
        if ss -ln 2>/dev/null | grep ":$port " >/dev/null; then
            return 0  # Port is in use
        fi
    fi
    
    return 1  # Port appears to be free
}

# Function to kill processes on a specific port
kill_port_processes() {
    local port=$1
    print_status "Checking for processes on port $port..."
    
    # Try to find and kill processes using the port
    if command -v lsof >/dev/null 2>&1; then
        local pids=$(lsof -ti :$port 2>/dev/null)
        if [ -n "$pids" ]; then
            print_warning "Found processes on port $port. Killing them..."
            echo "$pids" | xargs kill -9 2>/dev/null || true
            sleep 2
        fi
    fi
    
    # Additional cleanup for known process patterns
    if [ "$port" == "8000" ]; then
        # Kill Tomcat processes
        pkill -f "tomcat.*$port" 2>/dev/null || true
        pkill -f "catalina" 2>/dev/null || true
    elif [ "$port" == "8090" ]; then
        # Kill HTTP server processes
        pkill -f "python.*http.server.*$port" 2>/dev/null || true
        pkill -f "SimpleHTTPServer.*$port" 2>/dev/null || true
    fi
    
    sleep 1
}

# Function to check if Tomcat is responding
check_tomcat_response() {
    if command -v curl >/dev/null 2>&1; then
        if curl -s "http://localhost:$SERVER_PORT" >/dev/null 2>&1; then
            return 0  # Tomcat is responding
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q --spider "http://localhost:$SERVER_PORT" 2>/dev/null; then
            return 0  # Tomcat is responding
        fi
    fi
    return 1  # Tomcat is not responding
}

# Function to start Tomcat if not running
start_tomcat() {
    # First kill any processes on the server port
    kill_port_processes $SERVER_PORT
    
    # Check if Tomcat is responding
    if check_tomcat_response; then
        print_status "Tomcat is already running and responding on port $SERVER_PORT"
        return 0
    fi
    
    print_status "Starting Tomcat server on port $SERVER_PORT..."
    if [ -f "$TOMCAT_HOME/bin/startup.sh" ]; then
        # Create backup of server.xml if it doesn't exist
        if [ ! -f "$TOMCAT_HOME/conf/server.xml.backup" ]; then
            cp "$TOMCAT_HOME/conf/server.xml" "$TOMCAT_HOME/conf/server.xml.backup"
        fi
        
        # Modify server.xml to use the desired port
        sed -i.tmp "s/port=\"8080\"/port=\"$SERVER_PORT\"/g" "$TOMCAT_HOME/conf/server.xml"
        
        cd "$TOMCAT_HOME/bin"
        ./startup.sh
        cd "$PROJECT_DIR"
        
        # Wait for Tomcat to start (up to 15 seconds)
        local max_wait=15
        local waited=0
        while [ $waited -lt $max_wait ]; do
            sleep 1
            waited=$((waited + 1))
            if check_tomcat_response; then
                print_status "Tomcat started successfully on port $SERVER_PORT"
                return 0
            fi
        done
        
        print_warning "Tomcat may still be starting up..."
        return 0
    else
        print_error "Tomcat startup script not found at $TOMCAT_HOME/bin/startup.sh"
        exit 1
    fi
}

# Function to start HTTP server for clients
start_client_server() {
    # Kill any processes on the client port
    kill_port_processes $CLIENT_SERVER_PORT
    
    # Check if port is still in use after cleanup
    if check_port $CLIENT_SERVER_PORT; then
        print_warning "Port $CLIENT_SERVER_PORT is still in use after cleanup. Trying force kill..."
        sleep 2
        kill_port_processes $CLIENT_SERVER_PORT
    fi
    
    print_status "Starting HTTP server for client applications on port $CLIENT_SERVER_PORT..."
    cd "$PROJECT_DIR"
    
    # Start HTTP server in background
    python3 -m http.server $CLIENT_SERVER_PORT >/dev/null 2>&1 &
    SERVER_PID=$!
    
    # Wait a moment and check if server started
    sleep 3
    if ps -p $SERVER_PID > /dev/null 2>&1; then
        print_status "Client HTTP server started successfully on port $CLIENT_SERVER_PORT (PID: $SERVER_PID)"
        echo $SERVER_PID > .client_server.pid
        return 0
    else
        print_error "Failed to start client HTTP server on port $CLIENT_SERVER_PORT"
        exit 1
    fi
}

# Function to compile Java client
compile_java_client() {
    print_status "Compiling Java console client..."
    cd "$PROJECT_DIR/client/java"
    
    if javac CurrencyClient.java; then
        print_status "Java client compiled successfully"
    else
        print_error "Failed to compile Java client"
        exit 1
    fi
    
    cd "$PROJECT_DIR"
}

# Function to check service health
check_service_health() {
    print_status "Checking web service health..."
    sleep 5  # Give service more time to deploy
    
    local max_attempts=15
    local attempt=1
    local service_url="http://localhost:$SERVER_PORT/CurrencyConversionService/services/CurrencyConverter?wsdl"
    
    while [ $attempt -le $max_attempts ]; do
        if command -v curl >/dev/null 2>&1; then
            if curl -s "$service_url" >/dev/null 2>&1; then
                print_status "Web service is healthy and responding"
                return 0
            fi
        elif command -v wget >/dev/null 2>&1; then
            if wget -q --spider "$service_url" 2>/dev/null; then
                print_status "Web service is healthy and responding"
                return 0
            fi
        else
            print_warning "Neither curl nor wget available, skipping detailed health check"
            return 0
        fi
        
        print_warning "Attempt $attempt/$max_attempts: Service not ready yet, waiting..."
        sleep 3
        ((attempt++))
    done
    
    print_warning "Web service health check timed out, but it may still be starting up"
    return 0  # Don't fail the deployment, just warn
}

# Main deployment process
main() {
    echo ""
    print_status "Starting deployment process..."
    echo ""
    
    # Step 1: Build and deploy server-side web service
    print_status "Step 1: Building and deploying web service..."
    if ant clean compile war deploy; then
        print_status "Web service deployed successfully"
    else
        print_error "Failed to deploy web service"
        exit 1
    fi
    
    # Step 2: Start Tomcat
    print_status "Step 2: Ensuring Tomcat is running..."
    start_tomcat
    
    # Step 3: Compile Java client
    print_status "Step 3: Compiling Java console client..."
    compile_java_client
    
    # Step 4: Start HTTP server for HTML clients
    print_status "Step 4: Starting HTTP server for client applications..."
    start_client_server
    
    # Step 5: Check service health
    print_status "Step 5: Verifying web service health..."
    check_service_health
    
    echo ""
    print_status "✅ DEPLOYMENT COMPLETED!"
    
    # Display all URLs and access information
    echo ""
    echo "============================================="
    echo "🚀 APPLICATION READY - ACCESS INFORMATION"
    echo "============================================="
    echo ""
    
    print_url "📊 Web Service WSDL:"
    echo "   http://localhost:$SERVER_PORT/CurrencyConversionService/services/CurrencyConverter?wsdl"
    echo ""
    
    print_url "👤 USER CLIENT (Currency Conversion):"
    echo "   http://localhost:$CLIENT_SERVER_PORT/client/user/user-client.html"
    echo ""
    
    print_url "⚙️  ADMIN CLIENT (Exchange Rate Management):"
    echo "   http://localhost:$CLIENT_SERVER_PORT/client/admin/admin-client.html"
    echo ""
    
    print_url "💻 JAVA CONSOLE CLIENT:"
    echo "   cd client/java && java CurrencyClient"
    echo ""
    
    echo "============================================="
    echo "📋 QUICK USAGE GUIDE"
    echo "============================================="
    echo ""
    echo "USER CLIENT FEATURES:"
    echo "  • Convert between currencies (USD, EUR, GBP, JPY, CAD, CHF)"
    echo "  • Check service health status"
    echo "  • View supported currencies"
    echo ""
    echo "ADMIN CLIENT FEATURES:"
    echo "  • View all exchange rates"
    echo "  • Update existing exchange rates"
    echo "  • Add new currencies"
    echo "  • Remove currencies"
    echo ""
    echo "CONSOLE CLIENT:"
    echo "  • Interactive menu with both user and admin functions"
    echo "  • Full SOAP client implementation"
    echo ""
    
    echo "============================================="
    echo "🛠️  MANAGEMENT COMMANDS"
    echo "============================================="
    echo ""
    echo "Stop client HTTP server:"
    echo "  kill \$(cat .client_server.pid 2>/dev/null) 2>/dev/null || true"
    echo ""
    echo "Stop Tomcat:"
    echo "  $TOMCAT_HOME/bin/shutdown.sh"
    echo ""
    echo "Restart everything:"
    echo "  ./build.sh"
    echo ""
    
    # Create a simple stop script
    cat > stop.sh << 'EOF'
#!/bin/bash
echo "Stopping Currency Conversion Services..."

# Stop client HTTP server
if [ -f .client_server.pid ]; then
    PID=$(cat .client_server.pid)
    if kill $PID 2>/dev/null; then
        echo "✅ Client HTTP server stopped (PID: $PID)"
    fi
    rm -f .client_server.pid
fi

# Stop Tomcat
if [ -f "../apache-tomcat-9.0.100/bin/shutdown.sh" ]; then
    ../apache-tomcat-9.0.100/bin/shutdown.sh
    echo "✅ Tomcat shutdown initiated"
else
    echo "⚠️  Could not find Tomcat shutdown script"
fi

echo "🛑 All services stopped"
EOF
    
    chmod +x stop.sh
    
    echo "💡 Created 'stop.sh' script to stop all services"
    echo ""
    print_status "🎉 Deployment completed successfully!"
    print_status "📖 See USAGE_GUIDE.md for detailed instructions"
    echo ""
    print_status "💡 TIP: You can now open the URLs above in your browser to start using the application!"
}

# Cleanup function for script interruption
cleanup() {
    echo ""
    print_warning "Script interrupted. Cleaning up..."
    if [ -f .client_server.pid ]; then
        PID=$(cat .client_server.pid)
        kill $PID 2>/dev/null || true
        rm -f .client_server.pid
    fi
    exit 1
}

# Trap cleanup function for Ctrl+C
trap cleanup INT

# Check prerequisites
print_status "Checking prerequisites..."

# Check if ant is available
if ! command -v ant &> /dev/null; then
    print_error "Apache Ant is not installed or not in PATH"
    exit 1
fi

# Check if java is available
if ! command -v java &> /dev/null; then
    print_error "Java is not installed or not in PATH"
    exit 1
fi

# Check if javac is available
if ! command -v javac &> /dev/null; then
    print_error "Java compiler (javac) is not installed or not in PATH"
    exit 1
fi

# Check if python3 is available
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed or not in PATH"
    exit 1
fi

# Check if Tomcat directory exists
if [ ! -d "$TOMCAT_HOME" ]; then
    print_error "Tomcat directory not found at $TOMCAT_HOME"
    print_error "Please adjust TOMCAT_HOME variable in this script"
    exit 1
fi

print_status "All prerequisites met ✅"

# Run main deployment
main 