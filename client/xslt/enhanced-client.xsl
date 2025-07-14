<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cur="http://service.currency.com">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<!-- Root template -->
<xsl:template match="/">
<html>
<head>
    <title><xsl:value-of select="currencyService/serviceInfo/name"/> - XSLT Interface</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        /* Enhanced CSS for Data-Driven XSLT Interface */
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
            max-width: 1400px;
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
        }

        .service-badge {
            display: inline-block;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin: 10px 5px;
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

        .service-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            background: rgba(0, 0, 0, 0.02);
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            color: #333;
            font-size: 1.1rem;
            margin-top: 5px;
        }

        .operations-grid {
            display: grid;
            gap: 15px;
        }

        .operation-card {
            background: rgba(76, 175, 80, 0.05);
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
            transition: all 0.3s ease;
        }

        .operation-card:hover {
            background: rgba(76, 175, 80, 0.1);
            transform: translateX(5px);
        }

        .operation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .operation-name {
            font-weight: 600;
            color: #2e7d32;
            font-size: 1.1rem;
        }

        .operation-type {
            background: #4CAF50;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .operation-desc {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .parameters-list {
            background: rgba(255, 255, 255, 0.7);
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 10px;
        }

        .parameter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .parameter:last-child {
            border-bottom: none;
        }

        .param-name {
            font-weight: 600;
            color: #333;
        }

        .param-type {
            background: #e3f2fd;
            color: #1976d2;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 0.75rem;
        }

        .currencies-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .currency-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .currency-card:hover {
            transform: scale(1.05);
        }

        .currency-symbol {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }

        .currency-code {
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 5px;
        }

        .currency-name {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .features-list {
            list-style: none;
            padding: 0;
        }

        .features-list li {
            padding: 8px 0;
            padding-left: 25px;
            position: relative;
            color: #555;
        }

        .features-list li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #4CAF50;
            font-weight: bold;
        }

        .browser-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .browser-tag {
            background: #ff9800;
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .config-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .config-item {
            background: rgba(0, 0, 0, 0.02);
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #ff9800;
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
            margin-top: 15px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
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

        .footer {
            margin-top: 40px;
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
            
            .service-info-grid,
            .config-grid {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .currencies-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
    </style>
    <script>
        // Enhanced JavaScript for XSLT Interface
        const SERVICE_CONFIG = {
            baseUrl: '<xsl:value-of select="currencyService/serviceInfo/endpoint"/>',
            namespace: '<xsl:value-of select="currencyService/serviceInfo/namespace"/>',
            timeout: <xsl:value-of select="currencyService/configuration/timeout"/>
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
                        'Content-Type': '<xsl:value-of select="currencyService/configuration/soap/contentType"/>; charset=utf-8',
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

        async function testOperation(operationName) {
            try {
                let result;
                if (operationName === 'convertCurrency') {
                    result = await callSoapService(operationName, {
                        amount: 100,
                        fromCurrency: 'USD',
                        toCurrency: 'EUR'
                    });
                } else {
                    result = await callSoapService(operationName);
                }
                
                displayResult(`${operationName}Result`, `✅ ${result}`, 'success');
                
            } catch (error) {
                displayResult(`${operationName}Result`, `❌ ${error.message}`, 'error');
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

        window.onload = function() {
            console.log('Enhanced XSLT Currency Conversion Client loaded');
            console.log('Service Configuration:', SERVICE_CONFIG);
        };
    </script>
</head>
<body>
    <div class="container">
        <!-- Dynamic Header from XML -->
        <header class="header">
            <h1>💱 <xsl:value-of select="currencyService/serviceInfo/name"/></h1>
            <p><xsl:value-of select="currencyService/serviceInfo/description"/></p>
            <div>
                <span class="service-badge">Version <xsl:value-of select="currencyService/serviceInfo/version"/></span>
                <span class="service-badge"><xsl:value-of select="currencyService/serviceInfo/status"/></span>
                <span class="service-badge"><xsl:value-of select="currencyService/clientInfo/type"/></span>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Service Information (Data-Driven) -->
            <section class="card">
                <h2>🔗 Service Information</h2>
                <div class="service-info-grid">
                    <div class="info-item">
                        <div class="info-label">Endpoint</div>
                        <div class="info-value"><xsl:value-of select="currencyService/serviceInfo/endpoint"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Namespace</div>
                        <div class="info-value"><xsl:value-of select="currencyService/serviceInfo/namespace"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">WSDL</div>
                        <div class="info-value">
                            <a href="{currencyService/serviceInfo/wsdlUrl}" target="_blank">View WSDL</a>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Technology</div>
                        <div class="info-value"><xsl:value-of select="currencyService/clientInfo/technology"/></div>
                    </div>
                </div>
            </section>

            <!-- Dynamic Operations (Generated from XML) -->
            <section class="card">
                <h2>⚡ Available Operations</h2>
                <div class="operations-grid">
                    <xsl:for-each select="currencyService/operations/operation">
                        <div class="operation-card">
                            <div class="operation-header">
                                <span class="operation-name"><xsl:value-of select="name"/></span>
                                <span class="operation-type"><xsl:value-of select="returnType"/></span>
                            </div>
                            <div class="operation-desc"><xsl:value-of select="description"/></div>
                            
                            <xsl:if test="parameters/parameter">
                                <div class="parameters-list">
                                    <strong>Parameters:</strong>
                                    <xsl:for-each select="parameters/parameter">
                                        <div class="parameter">
                                            <span class="param-name"><xsl:value-of select="@name"/></span>
                                            <span class="param-type"><xsl:value-of select="@type"/></span>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </xsl:if>
                            
                            <button onclick="testOperation('{name}')" class="btn btn-primary">
                                🧪 Test <xsl:value-of select="name"/>
                            </button>
                            <div id="{name}Result" class="result-display"></div>
                        </div>
                    </xsl:for-each>
                </div>
            </section>

            <!-- Currency Conversion Form -->
            <section class="card">
                <h2>💱 Currency Conversion</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label for="amount">Amount:</label>
                        <input type="number" id="amount" step="0.01" min="0" placeholder="100.00" />
                    </div>
                    <div class="form-group">
                        <label for="fromCurrency">From Currency:</label>
                        <select id="fromCurrency">
                            <xsl:for-each select="currencyService/supportedCurrencies/currency">
                                <option value="{code}"><xsl:value-of select="code"/> - <xsl:value-of select="name"/></option>
                            </xsl:for-each>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toCurrency">To Currency:</label>
                        <select id="toCurrency">
                            <xsl:for-each select="currencyService/supportedCurrencies/currency">
                                <option value="{code}"><xsl:value-of select="code"/> - <xsl:value-of select="name"/></option>
                            </xsl:for-each>
                        </select>
                    </div>
                </div>
                
                <button onclick="convertCurrency()" class="btn btn-primary">
                    💱 Convert Currency
                </button>
                
                <div id="conversionResult" class="result-display"></div>
            </section>

            <!-- Dynamic Supported Currencies -->
            <section class="card">
                <h2>💰 Supported Currencies</h2>
                <p>The following <xsl:value-of select="count(currencyService/supportedCurrencies/currency)"/> currencies are supported:</p>
                <div class="currencies-grid">
                    <xsl:for-each select="currencyService/supportedCurrencies/currency">
                        <div class="currency-card">
                            <span class="currency-symbol"><xsl:value-of select="symbol"/></span>
                            <div class="currency-code"><xsl:value-of select="code"/></div>
                            <div class="currency-name"><xsl:value-of select="name"/></div>
                            <div style="font-size: 0.8rem; opacity: 0.8; margin-top: 5px;">
                                <xsl:value-of select="country"/>
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
            </section>

            <!-- Client Features (Data-Driven) -->
            <section class="card">
                <h2>🔧 Client Features</h2>
                <div class="service-info-grid">
                    <div>
                        <h4>Key Features:</h4>
                        <ul class="features-list">
                            <xsl:for-each select="currencyService/clientInfo/features/feature">
                                <li><xsl:value-of select="."/></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <div>
                        <h4>Browser Compatibility:</h4>
                        <div class="browser-tags">
                            <xsl:for-each select="currencyService/clientInfo/compatibility/browser">
                                <span class="browser-tag"><xsl:value-of select="."/></span>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Configuration (Data-Driven) -->
            <section class="card">
                <h2>⚙️ Configuration</h2>
                <div class="config-grid">
                    <div class="config-item">
                        <div class="info-label">SOAP Version</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/version"/></div>
                    </div>
                    <div class="config-item">
                        <div class="info-label">Encoding</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/encoding"/></div>
                    </div>
                    <div class="config-item">
                        <div class="info-label">Content Type</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/contentType"/></div>
                    </div>
                    <div class="config-item">
                        <div class="info-label">Timeout</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/timeout"/>ms</div>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>© 2024 <xsl:value-of select="currencyService/serviceInfo/name"/> - <xsl:value-of select="currencyService/clientInfo/type"/> | Generated via XSL Transformation</p>
        </footer>
    </div>
</body>
</html>
</xsl:template>

</xsl:stylesheet> 