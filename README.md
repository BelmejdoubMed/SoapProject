📋 Project Overview
ProjectWS1 is a comprehensive Currency Conversion Web Service application built using Java EE technologies and SOAP web services. It provides multiple client interfaces for currency conversion functionality and administrative management of exchange rates.
🏗️ Architecture & Technology Stack
Server-Side Technologies:
Java 11 - Core programming language
Apache Axis2 - SOAP web service framework
Apache Tomcat 9.0.100 - Application server
Apache Ant - Build automation tool
SOAP/WSDL - Web service protocol and description
Client-Side Technologies:
HTML5/CSS3/JavaScript - Web interfaces
XSLT (XSL Transformations) - XML-to-HTML transformation
Java Console Applications - Command-line interfaces
CORS enabled - Cross-origin resource sharing
🎯 Core Functionality
Main Features:
Currency Conversion - Convert amounts between different currencies (USD, EUR, GBP, JPY, CAD, CHF)
Exchange Rate Management - Add, update, and remove currencies and their rates
Service Health Monitoring - Check service status and availability
Multiple Client Interfaces - Various ways to interact with the service
🖥️ Client Interfaces
The project provides 5 different client interfaces:
1. User Web Interface (client/user/)
Purpose: End-user currency conversion
Features:
Convert between currencies
View current exchange rates
Auto-refreshing rate display
Mobile-responsive design
2. Admin Web Interface (client/admin/)
Purpose: Administrative management
Features:
Dashboard with service statistics
Add new currencies
Update exchange rates
Remove currencies
View all supported currencies
Real-time SOAP communication
3. XSLT Interface (client/xslt/)
Purpose: Demonstration of XML transformation capabilities
Features:
XML-to-HTML transformation using XSLT
Dynamic content generation
Multiple XSLT stylesheets for different presentations
Data-driven interface generation
4. Java Console Client (client/java/)
Purpose: Command-line interface
Features:
Interactive menu system
Full SOAP client implementation using Apache Axis2
Both user and admin functions
Comprehensive testing capabilities
5. XML Client (client/xml/)
Purpose: XML data processing and transformation
Features: XML configuration and data files
🔧 Web Service Operations
The SOAP service exposes these operations:
convertCurrency - Convert amount from one currency to another
isServiceHealthy - Check service health status
getConversionSummary - Get service status and supported currencies
getSupportedCurrencies - List all available currencies
updateExchangeRate - Update exchange rate for a currency
addCurrency - Add new currency support
removeCurrency - Remove currency from system
🚀 Deployment & Access
Service URLs:
Web Service WSDL: http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl
User Client: http://localhost:8090/client/user/user-client.html
Admin Client: http://localhost:8090/client/admin/admin-client.html
Deployment Process:
The project includes a comprehensive build.sh script that:
Builds and compiles the web service
Deploys to Tomcat server
Starts the HTTP server for client applications
Compiles Java clients
Performs health checks
Provides complete setup automation
💡 Key Features & Highlights
Multi-Technology Demonstration - Shows integration of SOAP, XSLT, Java, and web technologies
Complete Development Lifecycle - From service development to multiple client implementations
Real-time Communication - Live SOAP calls between clients and server
Responsive Design - Modern web interfaces that work on all devices
Comprehensive Testing - Multiple ways to test and interact with the service
Educational Value - Great example of enterprise Java web service development
🛠️ Build & Management
Build Command: ./build.sh - Complete deployment automation
Stop Command: ./stop.sh - Clean shutdown of all services
Prerequisites: Java 11, Apache Ant, Python 3, Apache Tomcat 9
This project is an excellent example of a complete enterprise web service solution that demonstrates modern Java EE development practices, SOAP web services, and multiple client interface patterns.
