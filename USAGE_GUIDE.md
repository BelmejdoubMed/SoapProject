# Currency Conversion Web Service - Usage Guide

## Overview

This is a simple currency conversion web service application built with:
- **Server**: Apache Tomcat + Axis2 Web Service
- **Client Types**: User Client (HTML) and Admin Client (HTML + Java Console)

## ⚡ Quick Start (Automated Deployment)

**🚀 ONE-COMMAND DEPLOYMENT:**

```bash
./build.sh
```

This script automatically:
- Builds and deploys the web service
- Starts Tomcat (if not running)
- Compiles the Java client
- Starts HTTP server for HTML clients
- Provides all access URLs

**🛑 STOP ALL SERVICES:**

```bash
./stop.sh
```

## Features

### Server-Side Web Service
- Currency conversion between supported currencies
- Admin functionality for managing exchange rates
- Health check and service summary

### User Client Features
- Convert currencies
- Check service health
- View service summary with supported currencies

### Admin Client Features
- View all exchange rates
- Update existing exchange rates
- Add new currencies
- Remove currencies
- Manage the currency table

## Access URLs (After Running build.sh)

After running `./build.sh`, you'll get these URLs:

### 📊 Web Service WSDL:
```
http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl
```

### 👤 USER CLIENT (Currency Conversion):
```
http://localhost:8000/client/user/user-client.html
```

### ⚙️ ADMIN CLIENT (Exchange Rate Management):
```
http://localhost:8000/client/admin/admin-client.html
```

### 💻 JAVA CONSOLE CLIENT:
```bash
cd client/java && java CurrencyClient
```

## Manual Setup (Alternative)

### 1. Start the Server

If you want to start manually instead of using `build.sh`:

```bash
# Build and deploy
ant clean compile war deploy

# Start Tomcat
cd ../apache-tomcat-9.0.100/bin
./startup.sh

# Start client HTTP server
python3 -m http.server 8000
```

### 2. Verify Service is Running

Open your browser and check:
- Service WSDL: http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl

## Using the Clients

### HTML User Client (Basic - No Styling)

Open `http://localhost:8000/client/user/user-client.html` in your web browser.

**Features:**
- Service Status Check
- Currency Conversion (USD, EUR, GBP, JPY, CAD, CHF)
- Service Summary

**Usage:**
1. Click "Check Service Health" to verify connection
2. Enter amount and select currencies to convert
3. Click "Convert" to get the exchange rate
4. Click "Get Service Summary" to view all supported currencies

### HTML Admin Client (Basic - No Styling)

Open `http://localhost:8000/client/admin/admin-client.html` in your web browser.

**Features:**
- View all exchange rates
- Update existing rates
- Add new currencies
- Remove currencies

**Usage:**
1. Click "Get All Rates" to see current exchange rates
2. Update rates by entering currency code and new rate
3. Add new currencies with their exchange rates
4. Remove currencies (cannot remove USD as it's the base)

### Java Console Client

Run the interactive console client:

```bash
cd client/java
java CurrencyClient
```

**Features:**
- All user functions (currency conversion, health check, summary)
- All admin functions (rate management)
- Interactive menu system

**Menu Options:**
1. Convert Currency - Interactive currency conversion
2. Check Service Health - Verify service status
3. Get Service Summary - View supported currencies
4. Admin Functions - Access admin menu
5. Get Supported Currencies - List all currencies
6. Exit - Close the application

## Default Exchange Rates (Base: USD)

- USD: 1.0 (base currency)
- EUR: 0.85
- GBP: 0.73
- JPY: 110.0
- CAD: 1.25
- CHF: 0.92

## Admin Operations

### Update Exchange Rate
- Enter currency code (e.g., "EUR")
- Enter new rate (e.g., "0.90")
- System updates the rate immediately

### Add New Currency
- Enter currency code (e.g., "AUD")
- Enter exchange rate to USD (e.g., "1.35")
- Currency becomes available for conversion

### Remove Currency
- Enter currency code to remove
- Currency is removed from the system
- Cannot remove USD (base currency)

## Examples

### Currency Conversion Examples

**Convert 100 USD to EUR:**
- Input: Amount=100, From=USD, To=EUR
- Output: "100.00 USD = 85.00 EUR"

**Convert 50 EUR to GBP:**
- Input: Amount=50, From=EUR, To=GBP
- Calculation: 50 EUR → 58.82 USD → 42.94 GBP
- Output: "50.00 EUR = 42.94 GBP"

### Admin Examples

**Update EUR rate:**
- Currency: EUR
- New Rate: 0.90
- Result: "Success: Exchange rate for EUR updated to 0.9"

**Add Australian Dollar:**
- Currency: AUD
- Rate: 1.35
- Result: "Success: Currency AUD added with rate 1.35"

## Build Script Features

The `build.sh` script provides:

### ✅ Automated Features:
- **Prerequisite checking**: Verifies all required tools
- **Service building**: Compiles and creates WAR file
- **Auto-deployment**: Deploys to Tomcat automatically
- **Service startup**: Starts Tomcat if not running
- **Client setup**: Compiles Java client and starts HTTP server
- **Health checking**: Verifies web service is responding
- **URL logging**: Displays all access URLs
- **Stop script creation**: Creates `stop.sh` for cleanup

### 🔧 Management Commands:

**Restart everything:**
```bash
./build.sh
```

**Stop all services:**
```bash
./stop.sh
```

**Stop client HTTP server only:**
```bash
kill $(cat .client_server.pid 2>/dev/null) 2>/dev/null || true
```

**Stop Tomcat only:**
```bash
../apache-tomcat-9.0.100/bin/shutdown.sh
```

## Troubleshooting

### Service Not Responding
1. Run `./build.sh` to restart everything
2. Check Tomcat logs: `tail -f ../apache-tomcat-9.0.100/logs/catalina.out`
3. Verify processes: `ps aux | grep tomcat`

### CORS Issues with HTML Clients
The build script automatically starts an HTTP server to avoid CORS issues. If you see CORS errors:
1. Make sure you're accessing via `http://localhost:8000/...` not `file://...`
2. Re-run `./build.sh` if the HTTP server stopped

### Port Conflicts
If ports 8080 or 8000 are in use:
1. Run `./stop.sh` to stop services
2. Check what's using the ports: `lsof -i :8080` and `lsof -i :8000`
3. Stop conflicting services or modify port numbers in the build script

### Build Script Permissions
If you get permission denied:
```bash
chmod +x build.sh
chmod +x stop.sh
```

## Architecture Notes

- **Base Currency**: USD (rate = 1.0)
- **Conversion Logic**: All conversions go through USD
- **Data Storage**: In-memory HashMap (resets on service restart)
- **No Authentication**: Admin functions are openly accessible
- **No Styling**: Clients are basic HTML without CSS or icons
- **Auto-deployment**: Build script handles all setup automatically

## Service Endpoints

- **WSDL**: http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl
- **Service**: http://localhost:8000/CurrencyConversionService/services/CurrencyConverter

## Available Operations

### User Operations
- `convertCurrency(amount, fromCurrency, toCurrency)` - Convert between currencies
- `isServiceHealthy()` - Check service health
- `getConversionSummary()` - Get service status and currencies
- `getSupportedCurrencies()` - List supported currencies

### Admin Operations  
- `getAllRates()` - View all exchange rates
- `updateExchangeRate(currency, rate)` - Update existing rate
- `addCurrency(currency, rate)` - Add new currency
- `removeCurrency(currency)` - Remove currency

## 🎉 Summary

**This is now a complete, ready-to-use currency conversion web service!**

1. **Run once**: `./build.sh`
2. **Use immediately**: Open the provided URLs in your browser
3. **Stop when done**: `./stop.sh`

The implementation is basic (no styling/icons) as requested, but fully functional with proper client-server architecture using Apache Tomcat and Axis2. 