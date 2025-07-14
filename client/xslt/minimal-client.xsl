<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<xsl:template match="/">
<html>
<head>
    <title>Currency Service - <xsl:value-of select="currencyService/serviceInfo/name"/></title>
    <meta charset="UTF-8"/>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .header { background: #007bff; color: white; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
        .card { background: white; padding: 20px; margin: 15px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .currency { display: inline-block; margin: 5px; padding: 10px; background: #e9ecef; border-radius: 4px; }
        .operation { background: #f8f9fa; padding: 15px; margin: 10px 0; border-left: 4px solid #28a745; }
    </style>
</head>
<body>
    <div class="header">
        <h1><xsl:value-of select="currencyService/serviceInfo/name"/></h1>
        <p><xsl:value-of select="currencyService/serviceInfo/description"/></p>
        <p>Version: <xsl:value-of select="currencyService/serviceInfo/version"/> | Status: <xsl:value-of select="currencyService/serviceInfo/status"/></p>
    </div>
    
    <div class="card">
        <h2>Service Information</h2>
        <p><strong>Endpoint:</strong> <xsl:value-of select="currencyService/serviceInfo/endpoint"/></p>
        <p><strong>WSDL:</strong> <a href="{currencyService/serviceInfo/wsdlUrl}">View WSDL</a></p>
        <p><strong>Namespace:</strong> <xsl:value-of select="currencyService/serviceInfo/namespace"/></p>
    </div>
    
    <div class="card">
        <h2>Operations (<xsl:value-of select="count(currencyService/operations/operation)"/>)</h2>
        <xsl:for-each select="currencyService/operations/operation">
            <div class="operation">
                <h3><xsl:value-of select="name"/></h3>
                <p><xsl:value-of select="description"/></p>
                <p><strong>Returns:</strong> <xsl:value-of select="returnType"/></p>
            </div>
        </xsl:for-each>
    </div>
    
    <div class="card">
        <h2>Supported Currencies (<xsl:value-of select="count(currencyService/supportedCurrencies/currency)"/>)</h2>
        <div>
            <xsl:for-each select="currencyService/supportedCurrencies/currency">
                <div class="currency">
                    <strong><xsl:value-of select="code"/></strong> - <xsl:value-of select="name"/>
                    (<xsl:value-of select="country"/>)
                </div>
            </xsl:for-each>
        </div>
    </div>
    
    <div class="card">
        <h2>Client Information</h2>
        <p><strong>Type:</strong> <xsl:value-of select="currencyService/clientInfo/type"/></p>
        <p><strong>Technology:</strong> <xsl:value-of select="currencyService/clientInfo/technology"/></p>
        
        <h3>Features:</h3>
        <ul>
            <xsl:for-each select="currencyService/clientInfo/features/feature">
                <li><xsl:value-of select="."/></li>
            </xsl:for-each>
        </ul>
    </div>
    
    <div class="card">
        <h2>Testing</h2>
        <p>Use the interactive web interface for testing:</p>
        <p><a href="http://localhost:8090/client/web/index.html" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">Open Web Interface</a></p>
    </div>
    
    <div style="text-align: center; margin-top: 30px; color: #666; font-size: 0.9rem;">
        <p>Generated via XSLT Transformation | Service: <xsl:value-of select="currencyService/serviceInfo/name"/></p>
    </div>
</body>
</html>
</xsl:template>

</xsl:stylesheet> 