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
