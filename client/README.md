# Currency Conversion Client Applications

This directory contains **two complete client implementations** for the Currency Conversion Web Service:

1. **Java Console Client** - Command-line application using Apache Axis2
2. **Web Browser Client** - Modern HTML/CSS/JavaScript interface

---

## 🎯 **Client Overview**

Both clients provide access to all three web service operations:
- **convertCurrency(amount, fromCurrency, toCurrency)** - Convert currency amounts
- **isServiceHealthy()** - Check service health status  
- **getConversionSummary()** - Get service status and supported currencies

---

## 🔧 **Prerequisites**

### For Java Client:
- ✅ Java 11 or higher
- ✅ Apache Ant 
- ✅ Apache Axis2 installed at `/opt/axis2`
- ✅ Currency Conversion Service running on Tomcat

### For Web Client:
- ✅ Modern web browser (Chrome, Firefox, Safari, Edge)
- ✅ Currency Conversion Service running on Tomcat
- ✅ *(Optional)* Local web server for best experience

---

## 💻 **Java Console Client**

### **Quick Start:**
```bash
# Navigate to Java client directory
cd client/java

# Run the interactive client application
ant run

# Or view available commands
ant help
```

### **Available Ant Targets:**
- `ant run` - Start the interactive client application
- `ant compile` - Compile the Java source files  
- `ant test-connection` - Test connection to web service
- `ant jar` - Create executable JAR file
- `ant clean` - Clean build directories

### **Features:**
- 🖥️ **Interactive Console Menu** - Easy-to-use command-line interface
- 🔗 **Auto-Connection Testing** - Automatically tests service connectivity
- 📝 **Input Validation** - Validates user input before sending requests
- 🧪 **Comprehensive Testing** - Built-in test suite for all operations
- 🛡️ **Error Handling** - Graceful error handling and user feedback

### **Usage Example:**
```bash
=== Currency Conversion Client Application ===
Connecting to Currency Conversion Web Service...

Testing service connection... ✅ Connected successfully!

╔══════════════════════════════════════╗
║       Currency Conversion Menu      ║
╠══════════════════════════════════════╣
║ 1. Convert Currency                 ║
║ 2. Check Service Health             ║
║ 3. Get Service Summary              ║
║ 4. Run All Tests                    ║
║ 5. Exit                             ║
╚══════════════════════════════════════╝
Choose an option (1-5): 
```

---

## 🌐 **Web Browser Client**

### **Quick Start:**
```bash
# Navigate to web client directory
cd client/web

# Option 1: Open directly in browser
open index.html

# Option 2: Use a simple HTTP server (recommended)
python3 -m http.server 8000
# Then visit: http://localhost:8000
```

### **Features:**
- 🎨 **Modern UI Design** - Beautiful, responsive interface with animations
- 📱 **Mobile Responsive** - Works perfectly on all device sizes
- 🔄 **Real-time Status** - Live connection status indicator
- ⚡ **Instant Feedback** - Loading animations and visual feedback
- 🧪 **Built-in Testing** - One-click testing of all operations
- 🎯 **Form Validation** - Client-side validation before sending requests

### **Interface Sections:**

#### 🏥 **Service Health**
- Real-time connection status indicator
- One-click health check button
- Visual status feedback (green/red dots)

#### 💱 **Currency Conversion**
- Dropdown menus for currency selection
- Amount input with validation
- Instant conversion results
- Support for multiple currencies (USD, EUR, GBP, JPY, CAD)

#### 📊 **Service Summary**  
- Get service status and supported currencies
- Formatted display of service information

#### 🧪 **Test All Operations**
- Comprehensive testing suite
- Sequential test execution with progress indication
- Color-coded results (success/error)

---

## 🔌 **Service Connection**

Both clients connect to:
```
http://localhost:8000/CurrencyConversionService/services/CurrencyConverter
```

### **Before Running Clients:**
1. ✅ Ensure Tomcat is running
2. ✅ Deploy the Currency Conversion Service  
3. ✅ Verify WSDL is accessible at:
   ```
   http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl
   ```

---

## 🛠️ **Development & Customization**

### **Java Client Structure:**
```
client/java/
├── com/currency/client/
│   ├── ICurrencyClient.java         # Interface definition
│   ├── SOAPCurrencyClient.java      # SOAP implementation
│   └── CurrencyClientApp.java       # Console application
└── build.xml                       # Ant build configuration
```

### **Web Client Structure:**
```
client/web/
├── index.html                       # Main HTML interface
├── styles.css                       # Modern CSS styling  
└── script.js                        # JavaScript SOAP client
```

### **Customization Options:**

#### **Change Service URL:**
- **Java**: Edit `SERVICE_URL` in `SOAPCurrencyClient.java`
- **Web**: Edit `SERVICE_CONFIG.baseUrl` in `script.js`

#### **Add New Currencies:**
- **Web**: Add options to the currency dropdowns in `index.html`
- **Java**: The client accepts any currency codes the service supports

#### **Modify UI Theme:**
- **Web**: Edit colors and styles in `styles.css`
- **Java**: Customize console output in `CurrencyClientApp.java`

---

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **Java Client - Compilation Errors:**
```bash
# Check Axis2 path
ls /opt/axis2/lib/*.jar

# Update path in build.xml if different
<property name="axis2.home" value="/your/axis2/path"/>
```

#### **Web Client - CORS Issues:**
If you see CORS errors in the browser console:

1. **Use HTTP Server** (recommended):
   ```bash
   python3 -m http.server 8000
   cd client/web && python3 -m http.server 8000
   ```

2. **Disable CORS** (development only):
   - Chrome: `--disable-web-security --user-data-dir=/tmp/chrome`
   - Use browser extension to disable CORS

3. **Configure Tomcat** (production):
   Add CORS headers to your Tomcat configuration

#### **Connection Refused:**
- ✅ Check Tomcat is running: `http://localhost:8080`
- ✅ Verify service deployment
- ✅ Check firewall settings

#### **Service Not Found:**
- ✅ Verify WSDL accessibility
- ✅ Check service name in deployment
- ✅ Review Tomcat logs for errors

---

## 📋 **Testing Checklist**

Use this checklist to verify everything works:

### **Java Client Testing:**
- [ ] `ant compile` - Compiles without errors
- [ ] `ant run` - Starts interactive application  
- [ ] Connection test passes on startup
- [ ] Health check returns "Service is healthy"
- [ ] Currency conversion works (e.g., 100 USD → EUR)
- [ ] Service summary shows "Ready" status
- [ ] All tests in test suite pass

### **Web Client Testing:**
- [ ] Page loads without errors
- [ ] Status indicator shows green (connected)
- [ ] Health check button works
- [ ] Currency conversion form submits successfully
- [ ] Service summary loads
- [ ] "Run All Tests" completes successfully
- [ ] No CORS errors in browser console

---

## 🎉 **Success Indicators**

When everything is working correctly, you should see:

### **Java Client:**
```
=== Currency Conversion Client Application ===
Connecting to Currency Conversion Web Service...

Testing service connection... ✅ Connected successfully!
```

### **Web Client:**
- 🟢 Green status dot in header
- ✅ "Connected to service" status text
- 💱 Successful currency conversions
- 🧪 All tests passing in test suite

---

## 📚 **API Reference**

### **convertCurrency**
```java
// Java
String result = client.convertCurrency(100.0, "USD", "EUR");

// JavaScript  
const result = await callSoapService('convertCurrency', {
    amount: 100.0,
    fromCurrency: 'USD', 
    toCurrency: 'EUR'
});
```

### **isServiceHealthy**
```java
// Java
boolean healthy = client.isServiceHealthy();

// JavaScript
const healthy = await callSoapService('isServiceHealthy', {});
```

### **getConversionSummary**  
```java
// Java
String summary = client.getConversionSummary();

// JavaScript
const summary = await callSoapService('getConversionSummary', {});
```

---

**🎯 Both clients are now ready to use with your Currency Conversion Web Service!**

Choose the Java client for integration into other Java applications, or use the web client for browser-based testing and demonstration. 