<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cur="http://service.currency.com">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<!-- Root template -->
<xsl:template match="/">
<html>
<head>
    <title>Currency Conversion - <xsl:value-of select="currencyService/serviceInfo/name"/></title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        <![CDATA[
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
        }

        .info-grid {
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
        }

        .info-value {
            color: #333;
            font-size: 1.1rem;
            margin-top: 5px;
        }

        .operation-card {
            background: rgba(76, 175, 80, 0.05);
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
            margin-bottom: 15px;
        }

        .operation-name {
            font-weight: 600;
            color: #2e7d32;
            font-size: 1.1rem;
            margin-bottom: 10px;
        }

        .operation-desc {
            color: #666;
            margin-bottom: 10px;
        }

        .operation-type {
            background: #4CAF50;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
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

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            margin-top: 15px;
            width: 100%;
            transition: transform 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
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
            .info-grid {
                grid-template-columns: 1fr;
            }
            .currencies-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
        ]]>
    </style>
</head>
<body>
    <div class="container">
        <!-- Dynamic Header -->
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
            <!-- Service Information -->
            <section class="card">
                <h2>🔗 Service Information</h2>
                <div class="info-grid">
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

            <!-- Operations -->
            <section class="card">
                <h2>⚡ Available Operations (<xsl:value-of select="count(currencyService/operations/operation)"/>)</h2>
                <xsl:for-each select="currencyService/operations/operation">
                    <div class="operation-card">
                        <div class="operation-name"><xsl:value-of select="name"/></div>
                        <div class="operation-desc"><xsl:value-of select="description"/></div>
                        <span class="operation-type">Returns: <xsl:value-of select="returnType"/></span>
                        
                        <xsl:if test="parameters/parameter">
                            <div style="margin-top: 10px; font-size: 0.9rem;">
                                <strong>Parameters:</strong>
                                <xsl:for-each select="parameters/parameter">
                                    <span style="background: #e3f2fd; color: #1976d2; padding: 2px 6px; border-radius: 10px; font-size: 0.8rem; margin: 2px;">
                                        <xsl:value-of select="@name"/> (<xsl:value-of select="@type"/>)
                                    </span>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                    </div>
                </xsl:for-each>
            </section>

            <!-- Supported Currencies -->
            <section class="card">
                <h2>💰 Supported Currencies (<xsl:value-of select="count(currencyService/supportedCurrencies/currency)"/>)</h2>
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

            <!-- Client Features -->
            <section class="card">
                <h2>🔧 Client Features</h2>
                <div style="background: rgba(0, 0, 0, 0.02); padding: 20px; border-radius: 8px;">
                    <h4>Key Features:</h4>
                    <ul style="margin-left: 20px; margin-top: 10px;">
                        <xsl:for-each select="currencyService/clientInfo/features/feature">
                            <li style="margin: 5px 0;"><xsl:value-of select="."/></li>
                        </xsl:for-each>
                    </ul>
                    
                    <h4 style="margin-top: 15px;">Browser Compatibility:</h4>
                    <div style="margin-top: 10px;">
                        <xsl:for-each select="currencyService/clientInfo/compatibility/browser">
                            <span style="background: #ff9800; color: white; padding: 5px 10px; border-radius: 12px; font-size: 0.8rem; margin: 2px 5px; display: inline-block;">
                                <xsl:value-of select="."/>
                            </span>
                        </xsl:for-each>
                    </div>
                </div>
            </section>

            <!-- Configuration -->
            <section class="card">
                <h2>⚙️ Configuration</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">SOAP Version</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/version"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Encoding</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/encoding"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Content Type</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/soap/contentType"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Timeout</div>
                        <div class="info-value"><xsl:value-of select="currencyService/configuration/timeout"/>ms</div>
                    </div>
                </div>
            </section>

            <!-- Interactive Testing -->
            <section class="card">
                <h2>🧪 Interactive Testing</h2>
                <p>Use the web interface for interactive SOAP service testing:</p>
                <button class="btn" onclick="window.open('http://localhost:8090/client/web/index.html', '_blank')">
                    🌐 Open Interactive Web Interface
                </button>
                <p style="margin-top: 15px; color: #666; font-size: 0.9rem;">
                    <strong>Service Endpoint:</strong> <xsl:value-of select="currencyService/serviceInfo/endpoint"/>
                </p>
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