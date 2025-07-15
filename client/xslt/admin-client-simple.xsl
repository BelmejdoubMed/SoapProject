<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8"/>

<xsl:template match="/">
<html>
<head>
    <title>Simple Admin Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #007bff; color: white; padding: 20px; border-radius: 5px; }
        .currencies { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Currency Management - Simple Test</h1>
        <p>Service: <xsl:value-of select="currencyService/serviceInfo/n"/></p>
        <p>Version: <xsl:value-of select="currencyService/serviceInfo/version"/></p>
    </div>
    
    <div class="currencies">
        <h2>Available Currencies</h2>
        <table>
            <thead>
                <tr>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Rate</th>
                    <th>Last Update</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="currencyService/currencies/currency">
                    <tr>
                        <td><xsl:value-of select="code"/></td>
                        <td><xsl:value-of select="n"/></td>
                        <td><xsl:value-of select="rate"/></td>
                        <td><xsl:value-of select="lastUpdate"/></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </div>
    
    <script>
        console.log('Simple admin interface loaded successfully!');
        
        function testSOAP() {
            console.log('SOAP test function available');
            alert('SOAP functionality can be added here');
        }
    </script>
</body>
</html>
</xsl:template>

</xsl:stylesheet> 