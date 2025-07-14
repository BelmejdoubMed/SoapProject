<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
    xmlns:cur="http://service.currency.com">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<!-- Root template -->
<xsl:template match="/">
<html>
<head>
    <title>Currency Conversion Client - XSLT Interface</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        /* Modern CSS for XSLT Currency Client */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            color: #333;
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .header .subtitle {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 20px;
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            background: rgba(76, 175, 80, 0.1);
            border: 2px solid rgba(76, 175, 80, 0.3);
            border-radius: 25px;
            color: #2e7d32;
            font-weight: 600;
        }

        .status-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #4CAF50;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        .main-content {
            display: grid;
            gap: 25px;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .card h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
            width: 100%;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #f8f9fa;
            color: #333;
            border: 2px solid #e1e5e9;
        }

        .btn-secondary:hover {
            background: #e9ecef;
            border-color: #667eea;
        }

        .result-display {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            background: rgba(33, 150, 243, 0.1);
            border: 1px solid rgba(33, 150, 243, 0.3);
            color: #1565c0;
            display: none;
        }

        .result-display.show {
            display: block;
        }

        .service-info {
            background: rgba(0, 0, 0, 0.02);
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .service-operation {
            background: rgba(76, 175, 80, 0.05);
            padding: 15px;
            margin: 10px 0;
            border-radius: 6px;
            border-left: 4px solid #4CAF50;
        }

        .operation-title {
            font-weight: 600;
            color: #2e7d32;
            margin-bottom: 5px;
        }

        .operation-desc {
            color: #666;
            font-size: 0.9rem;
        }

        .currency-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .currency-tag {
            background: #667eea;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .footer {
            margin-top: 40px;
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        .instructions {
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.3);
            color: #f57c00;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .instructions h3 {
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 2rem;
                flex-direction: column;
            }
        }
    </style>
    <script>
        // JavaScript functions for SOAP service calls
        const SERVICE_CONFIG = {
            baseUrl: 'http://localhost:8000/CurrencyConversionService/services/CurrencyConverter',
            namespace: 'http://service.currency.com'
        };

        function createSoapEnvelope(operation, parameters = {}) {
            let soapBody = `&lt;cur:${operation}&gt;`;
            
            for (const [key, value] of Object.entries(parameters)) {
                soapBody += `&lt;cur:${key}&gt;${value}&lt;/cur:${key}&gt;`;
            }
            
            soapBody += `&lt;/cur:${operation}&gt;`;
            
            return `&lt;?xml version="1.0" encoding="UTF-8"?&gt;
                &lt;soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" 
                               xmlns:cur="${SERVICE_CONFIG.namespace}"&gt;
                    &lt;soap:Header/&gt;
                    &lt;soap:Body&gt;
                        ${soapBody}
                    &lt;/soap:Body&gt;
                &lt;/soap:Envelope&gt;`;
        }

        async function callSoapService(operation, parameters = {}) {
            const soapEnvelope = createSoapEnvelope(operation, parameters);
            
            try {
                const response = await fetch(SERVICE_CONFIG.baseUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/soap+xml; charset=utf-8',
                        'SOAPAction': operation
                    },
                    body: soapEnvelope.replace(/&lt;/g, '<').replace(/&gt;/g, '>')
                });

                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }

                const responseText = await response.text();
                return extractValueFromSoapResponse(responseText);
                
            } catch (error) {
                console.error(`SOAP call failed for ${operation}:`, error);
                throw new Error(`Service call failed: ${error.message}`);
            }
        }

        function extractValueFromSoapResponse(soapResponse) {
            try {
                const parser = new DOMParser();
                const xmlDoc = parser.parseFromString(soapResponse, 'text/xml');
                
                const returnElements = [
                    xmlDoc.querySelector('return'),
                    xmlDoc.querySelector('[localName="return"]'),
                    xmlDoc.getElementsByTagName('return')[0]
                ].filter(Boolean);
                
                if (returnElements.length > 0) {
                    return returnElements[0].textContent.trim();
                }
                
                const body = xmlDoc.querySelector('Body') || xmlDoc.querySelector('[localName="Body"]');
                if (body) {
                    const firstChild = body.firstElementChild;
                    if (firstChild && firstChild.firstElementChild) {
                        return firstChild.firstElementChild.textContent.trim();
                    }
                }
                
                throw new Error('Could not extract value from SOAP response');
                
            } catch (error) {
                console.error('Error parsing SOAP response:', error);
                throw new Error('Invalid SOAP response format');
            }
        }

        function displayResult(containerId, message, type = 'info') {
            const container = document.getElementById(containerId);
            if (container) {
                container.className = `result-display show result-${type}`;
                container.innerHTML = message;
            }
        }

        async function checkHealth() {
            try {
                const result = await callSoapService('isServiceHealthy');
                const isHealthy = result === 'true' || result === true;
                
                if (isHealthy) {
                    displayResult('healthResult', '✅ Service is healthy and running!', 'success');
                } else {
                    displayResult('healthResult', '❌ Service is not healthy', 'error');
                }
                
            } catch (error) {
                displayResult('healthResult', `❌ Health check failed: ${error.message}`, 'error');
            }
        }

        async function convertCurrency() {
            try {
                const amount = parseFloat(document.getElementById('amount').value);
                const fromCurrency = document.getElementById('fromCurrency').value;
                const toCurrency = document.getElementById('toCurrency').value;
                
                if (isNaN(amount) || amount <= 0) {
                    displayResult('conversionResult', '❌ Please enter a valid amount greater than 0', 'error');
                    return;
                }
                
                if (fromCurrency === toCurrency) {
                    displayResult('conversionResult', '❌ Please select different currencies', 'error');
                    return;
                }
                
                const result = await callSoapService('convertCurrency', {
                    amount: amount,
                    fromCurrency: fromCurrency,
                    toCurrency: toCurrency
                });
                
                displayResult('conversionResult', `💱 ${result}`, 'success');
                
            } catch (error) {
                displayResult('conversionResult', `❌ Conversion failed: ${error.message}`, 'error');
            }
        }

        async function getSummary() {
            try {
                const result = await callSoapService('getConversionSummary');
                displayResult('summaryResult', result.replace(/\n/g, '<br>'), 'info');
                
            } catch (error) {
                displayResult('summaryResult', `❌ Failed to get summary: ${error.message}`, 'error');
            }
        }

        // Currency synchronization functions
        async function getSupportedCurrencies() {
            try {
                const result = await callSoapService('getSupportedCurrencies', {});
                return result.split(', ').sort();
            } catch (error) {
                console.error('Error getting supported currencies:', error);
                return ['USD', 'EUR', 'GBP', 'JPY', 'CAD']; // fallback
            }
        }

        async function updateCurrencyDropdowns() {
            try {
                const currencies = await getSupportedCurrencies();
                const fromSelect = document.getElementById('fromCurrency');
                const toSelect = document.getElementById('toCurrency');
                
                // Store current selections
                const fromSelected = fromSelect.value;
                const toSelected = toSelect.value;
                
                // Clear existing options
                fromSelect.innerHTML = '';
                toSelect.innerHTML = '';
                
                // Add currency options
                currencies.forEach(currency => {
                    const fromOption = document.createElement('option');
                    fromOption.value = currency;
                    fromOption.textContent = currency;
                    fromSelect.appendChild(fromOption);
                    
                    const toOption = document.createElement('option');
                    toOption.value = currency;
                    toOption.textContent = currency;
                    toSelect.appendChild(toOption);
                });
                
                // Restore selections if they still exist
                if (currencies.includes(fromSelected)) {
                    fromSelect.value = fromSelected;
                }
                if (currencies.includes(toSelected)) {
                    toSelect.value = toSelected;
                }
                
                // Update currency list display
                const currencyList = document.querySelector('.currency-list');
                if (currencyList) {
                    currencyList.innerHTML = '';
                    currencies.forEach(currency => {
                        const span = document.createElement('span');
                        span.className = 'currency-tag';
                        span.textContent = currency;
                        currencyList.appendChild(span);
                    });
                }
                
            } catch (error) {
                console.error('Error updating currency dropdowns:', error);
            }
        }

        // Initialize when page loads
        window.onload = function() {
            console.log('XSLT Currency Conversion Client loaded');
            checkHealth();
            setTimeout(updateCurrencyDropdowns, 1000); // Load currencies after health check
        };
        
        // Auto-refresh currencies every 15 seconds to sync with admin changes
        setInterval(updateCurrencyDropdowns, 15000);
    </script>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1>
                💱 Currency Conversion Client
            </h1>
            <p class="subtitle">XSLT-Powered Web Service Interface</p>
            <div class="status-indicator">
                <span class="status-dot"></span>
                <span>XSLT Interface Active</span>
            </div>
        </header>

        <!-- Instructions -->
        <div class="instructions">
            <h3>📋 How to Use This XSLT Interface</h3>
            <p><strong>This is a demonstration of XSLT transformation capabilities.</strong> The interface is generated using XSLT to transform XML data into HTML. To test the web service operations, use the interactive sections below.</p>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Service Information -->
            <section class="card">
                <h2>🔗 Service Information</h2>
                <div class="service-info">
                    <h4>Currency Conversion Web Service</h4>
                    <p><strong>Endpoint:</strong> http://localhost:8000/CurrencyConversionService/services/CurrencyConverter</p>
                    <p><strong>Namespace:</strong> http://service.currency.com</p>
                    <p><strong>WSDL:</strong> <a href="http://localhost:8000/CurrencyConversionService/services/CurrencyConverter?wsdl" target="_blank">View WSDL</a></p>
                </div>

                <h4 style="margin-top: 20px; margin-bottom: 15px;">Available Operations:</h4>
                
                <div class="service-operation">
                    <div class="operation-title">convertCurrency</div>
                    <div class="operation-desc">Convert currency amounts between different currencies</div>
                </div>
                
                <div class="service-operation">
                    <div class="operation-title">isServiceHealthy</div>
                    <div class="operation-desc">Check if the web service is healthy and operational</div>
                </div>
                
                <div class="service-operation">
                    <div class="operation-title">getConversionSummary</div>
                    <div class="operation-desc">Get service status and list of supported currencies</div>
                </div>
            </section>

            <!-- Service Health Check -->
            <section class="card">
                <h2>🏥 Service Health Check</h2>
                <p>Test the connectivity and health of the Currency Conversion Web Service.</p>
                
                <button onclick="checkHealth()" class="btn btn-secondary">
                    🔄 Check Service Health
                </button>
                
                <div id="healthResult" class="result-display"></div>
            </section>

            <!-- Currency Conversion -->
            <section class="card">
                <h2>💱 Currency Conversion</h2>
                <p>Convert amounts between different currencies using real-time rates.</p>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="amount">Amount:</label>
                        <input type="number" id="amount" step="0.01" min="0" placeholder="100.00" />
                    </div>
                    <div class="form-group">
                        <label for="fromCurrency">From Currency:</label>
                        <select id="fromCurrency">
                            <!-- Options will be populated dynamically -->
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toCurrency">To Currency:</label>
                        <select id="toCurrency">
                            <!-- Options will be populated dynamically -->
                        </select>
                    </div>
                </div>
                
                <button onclick="convertCurrency()" class="btn btn-primary">
                    💱 Convert Currency
                </button>
                
                <div id="conversionResult" class="result-display"></div>
            </section>

            <!-- Service Summary -->
            <section class="card">
                <h2>📊 Service Summary</h2>
                <p>Get detailed information about the service status and supported currencies.</p>
                
                <button onclick="getSummary()" class="btn btn-secondary">
                    📋 Get Service Summary
                </button>
                
                <div id="summaryResult" class="result-display"></div>
            </section>

            <!-- Supported Currencies -->
            <section class="card">
                <h2>💰 Supported Currencies</h2>
                <p>The following currencies are supported by the conversion service:</p>
                
                <div class="currency-list">
                    <span class="currency-tag">USD - US Dollar</span>
                    <span class="currency-tag">EUR - Euro</span>
                    <span class="currency-tag">GBP - British Pound</span>
                    <span class="currency-tag">JPY - Japanese Yen</span>
                    <span class="currency-tag">CAD - Canadian Dollar</span>
                </div>
            </section>

            <!-- XSLT Information -->
            <section class="card">
                <h2>🔧 XSLT Implementation Details</h2>
                <div class="service-info">
                    <h4>About This Interface</h4>
                    <p>This interface is generated using <strong>XSLT (Extensible Stylesheet Language Transformations)</strong>. XSLT transforms XML data into HTML, providing a powerful way to create dynamic web interfaces from XML sources.</p>
                    
                    <h4 style="margin-top: 15px;">Key Features:</h4>
                    <ul style="margin-left: 20px; margin-top: 10px;">
                        <li>✨ XSLT-generated HTML structure</li>
                        <li>🎨 Embedded CSS for styling</li>
                        <li>⚡ JavaScript for SOAP service interaction</li>
                        <li>📱 Responsive design for all devices</li>
                        <li>🔗 Direct integration with web services</li>
                    </ul>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>© 2024 Currency Conversion Client - XSLT Interface | Generated via XSL Transformation</p>
        </footer>
    </div>
</body>
</html>
</xsl:template>

</xsl:stylesheet> 