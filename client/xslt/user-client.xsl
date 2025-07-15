<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<!-- Root template -->
<xsl:template match="/">
<html>
<head>
    <title>Currency Service - User Interface</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        /* User-specific styling */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #00897b 0%, #004d40 100%);
            min-height: 100vh;
            color: #333;
            padding: 20px;
        }

        .user-header {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .user-title {
            color: #00897b;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .user-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .user-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .converter-section {
            text-align: center;
        }

        .converter-title {
            color: #00897b;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .converter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            color: #00897b;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .form-group select,
        .form-group input {
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            font-size: 16px;
        }

        .convert-button {
            background: #00897b;
            color: #fff;
            border: none;
            padding: 15px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease;
        }

        .convert-button:hover {
            background: #004d40;
        }

        .result-display {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            color: #00897b;
        }

        .rates-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .rates-table th,
        .rates-table td {
            padding: 12px;
            border: 1px solid #e0e0e0;
            text-align: left;
        }

        .rates-table th {
            background: #00897b;
            color: #fff;
            font-weight: bold;
        }

        .rates-table tr:nth-child(even) {
            background: #f8f9fa;
        }

        .section-title {
            color: #00897b;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .debug-info {
            background: #f1f1f1;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            font-family: monospace;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="user-header">
        <h1 class="user-title">Currency Exchange Service</h1>
        <p>Convert currencies with real-time exchange rates</p>
    </div>

    <div class="user-container">
        <xsl:apply-templates select="currencyService"/>
    </div>

    <script>
        <xsl:text disable-output-escaping="yes"><![CDATA[
        // SOAP service configuration
        var SOAP_ENDPOINT = 'http://localhost:8000/CurrencyConversionService/services/CurrencyConverter';
        var SOAP_NAMESPACE = 'http://service.currency.com';

        // Live rates cache
        var liveRates = {};

        // Debug function
        function debugLog(message, data) {
            console.log('[Currency Debug] ' + message, data || '');
            var debugDiv = document.getElementById('debug-info');
            if (debugDiv) {
                debugDiv.innerHTML += new Date().toLocaleTimeString() + ': ' + message + '\n';
            }
        }

        // Create SOAP envelope for requests
        function createSOAPEnvelope(methodName, parameters) {
            var soapBody = '';
            if (parameters) {
                for (var key in parameters) {
                    if (parameters.hasOwnProperty(key)) {
                        var value = String(parameters[key])
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;');
                        soapBody += String.fromCharCode(60) + 'cur:' + key + String.fromCharCode(62) + value + String.fromCharCode(60) + '/cur:' + key + String.fromCharCode(62);
                    }
                }
            }

            var envelope = String.fromCharCode(60) + '?xml version="1.0" encoding="UTF-8"?' + String.fromCharCode(62) +
                          String.fromCharCode(60) + 'soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cur="' + SOAP_NAMESPACE + '"' + String.fromCharCode(62) +
                          String.fromCharCode(60) + 'soap:Header/' + String.fromCharCode(62) +
                          String.fromCharCode(60) + 'soap:Body' + String.fromCharCode(62) +
                          String.fromCharCode(60) + 'cur:' + methodName + String.fromCharCode(62) +
                          soapBody +
                          String.fromCharCode(60) + '/cur:' + methodName + String.fromCharCode(62) +
                          String.fromCharCode(60) + '/soap:Body' + String.fromCharCode(62) +
                          String.fromCharCode(60) + '/soap:Envelope' + String.fromCharCode(62);
            
            debugLog('SOAP envelope created', envelope);
            return envelope;
        }

        // Send SOAP request
        function sendSOAPRequest(methodName, parameters) {
            var soapEnvelope = createSOAPEnvelope(methodName, parameters);
            
            debugLog('Sending SOAP request to: ' + SOAP_ENDPOINT);
            debugLog('Method: ' + methodName);
            
            return fetch(SOAP_ENDPOINT, {
                method: 'POST',
                headers: {
                    'Content-Type': 'text/xml; charset=utf-8',
                    'SOAPAction': methodName
                },
                body: soapEnvelope
            })
            .then(function(response) { 
                debugLog('SOAP response status: ' + response.status);
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }
                return response.text(); 
            })
            .then(function(responseText) {
                debugLog('SOAP response received', responseText.substring(0, 200) + '...');
                var parser = new DOMParser();
                var xmlDoc = parser.parseFromString(responseText, 'text/xml');
                
                var parseError = xmlDoc.getElementsByTagName('parsererror')[0];
                if (parseError) {
                    throw new Error('XML parsing error: ' + parseError.textContent);
                }
                
                var fault = xmlDoc.getElementsByTagName('soap:Fault')[0] || 
                           xmlDoc.getElementsByTagName('soapenv:Fault')[0] ||
                           xmlDoc.getElementsByTagName('Fault')[0];
                if (fault) {
                    var faultString = fault.getElementsByTagName('faultstring')[0] || 
                                     fault.getElementsByTagName('soap:faultstring')[0];
                    var errorMsg = faultString ? faultString.textContent : fault.textContent;
                    throw new Error('SOAP Fault: ' + errorMsg);
                }
                
                var returnElement = xmlDoc.getElementsByTagName('ns:return')[0] ||
                                   xmlDoc.getElementsByTagName('return')[0] ||
                                   xmlDoc.getElementsByTagName('ns2:return')[0];
                if (returnElement) {
                    return returnElement.textContent;
                }
                
                return 'Operation completed successfully';
            });
        }

        // Load live rates from SOAP service
        function loadLiveRates() {
            debugLog('Loading live rates...');
            return sendSOAPRequest('getAllRates', {})
            .then(function(result) {
                debugLog('Live rates received', result);
                liveRates = {};
                
                var lines = result.split('\n');
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (line && line.includes('=')) {
                        var parts = line.split('=');
                        if (parts.length >= 2) {
                            var code = parts[0].trim();
                            var rate = parts[1].trim();
                            
                            if (code.length === 3 && !isNaN(parseFloat(rate))) {
                                liveRates[code] = parseFloat(rate);
                            }
                        }
                    }
                }
                
                debugLog('Parsed live rates', liveRates);
                updateRatesTable();
                updateDropdowns();
                return liveRates;
            })
            .catch(function(error) {
                debugLog('Failed to load live rates: ' + error.message);
                // Fall back to static rates if live data fails
                loadStaticRates();
                throw error;
            });
        }

        // Load static rates as fallback
        function loadStaticRates() {
            debugLog('Loading fallback static rates...');
            liveRates = {
                'USD': 1.0,
                'EUR': 0.85,
                'GBP': 0.73,
                'JPY': 110.0,
                'CAD': 1.25,
                'CHF': 0.92
            };
            debugLog('Static rates loaded', liveRates);
            updateRatesTable();
            updateDropdowns();
        }

        // Update rates table with live data
        function updateRatesTable() {
            debugLog('updateRatesTable called with rates', liveRates);
            var tbody = document.querySelector('.rates-table tbody');
            debugLog('Found tbody element: ' + (tbody ? 'yes' : 'no'));
            if (!tbody) {
                debugLog('ERROR: Table tbody not found!');
                return;
            }
            
            tbody.innerHTML = '';
            debugLog('Cleared tbody, now adding rows...');
            
            var rowCount = 0;
            for (var code in liveRates) {
                if (liveRates.hasOwnProperty(code)) {
                    var row = document.createElement('tr');
                    row.innerHTML = 
                        '<td>' + code + '</td>' +
                        '<td>' + getCurrencyName(code) + '</td>' +
                        '<td>' + liveRates[code].toFixed(6) + '</td>' +
                        '<td>' + new Date().toISOString().substring(0, 19) + '</td>';
                    tbody.appendChild(row);
                    rowCount++;
                    debugLog('Added row for currency: ' + code + ', Rate: ' + liveRates[code]);
                }
            }
            debugLog('Total rows added: ' + rowCount);
        }

        // Update dropdown options with live currencies
        function updateDropdowns() {
            var fromSelect = document.getElementById('fromCurrency');
            var toSelect = document.getElementById('toCurrency');
            
            if (!fromSelect || !toSelect) {
                debugLog('Dropdowns not found');
                return;
            }
            
            var fromValue = fromSelect.value;
            var toValue = toSelect.value;
            
            fromSelect.innerHTML = '';
            toSelect.innerHTML = '';
            
            for (var code in liveRates) {
                if (liveRates.hasOwnProperty(code)) {
                    var option1 = document.createElement('option');
                    option1.value = code;
                    option1.textContent = code + ' - ' + getCurrencyName(code);
                    fromSelect.appendChild(option1);
                    
                    var option2 = document.createElement('option');
                    option2.value = code;
                    option2.textContent = code + ' - ' + getCurrencyName(code);
                    toSelect.appendChild(option2);
                }
            }
            
            // Restore previous selections if they still exist
            if (liveRates[fromValue]) fromSelect.value = fromValue;
            if (liveRates[toValue]) toSelect.value = toValue;
            
            debugLog('Dropdowns updated with ' + Object.keys(liveRates).length + ' currencies');
        }

        // Get currency name
        function getCurrencyName(code) {
            var names = {
                'USD': 'US Dollar',
                'EUR': 'Euro',
                'GBP': 'British Pound',
                'JPY': 'Japanese Yen',
                'CAD': 'Canadian Dollar',
                'CHF': 'Swiss Franc',
                'AUD': 'Australian Dollar',
                'XYZ': 'Test Currency XYZ',
                'ZZZ': 'Test Currency ZZZ',
                'TEST': 'Test Currency',
                'SSS': 'Sample Currency SSS',
                'WEE': 'Wee Currency',
                'QWE': 'QWE Currency'
            };
            return names[code] || code + ' Currency';
        }

        function convertCurrency() {
            debugLog('convertCurrency called');
            const fromCurrency = document.getElementById('fromCurrency').value;
            const toCurrency = document.getElementById('toCurrency').value;
            const amount = parseFloat(document.getElementById('amount').value);
            
            if (!fromCurrency || !toCurrency || !amount) {
                alert('Please fill in all fields');
                return;
            }
            
            if (amount <= 0) {
                alert('Please enter a positive amount');
                return;
            }
            
            // Use live rates for conversion
            const fromRate = liveRates[fromCurrency];
            const toRate = liveRates[toCurrency];
            
            if (!fromRate || !toRate) {
                alert('Currency rates not available. Please try refreshing the page.');
                return;
            }
            
            // Convert to USD first, then to target currency
            const usdAmount = amount / fromRate;
            const result = usdAmount * toRate;
            
            const resultDiv = document.getElementById('result');
            resultDiv.innerHTML = 
                amount + ' ' + fromCurrency + ' = ' + result.toFixed(2) + ' ' + toCurrency;
            resultDiv.style.display = 'block';
            
            debugLog('Conversion: ' + amount + ' ' + fromCurrency + ' = ' + result.toFixed(2) + ' ' + toCurrency);
        }

        // Auto-refresh rates every 30 seconds
        function startAutoRefresh() {
            setInterval(function() {
                debugLog('Auto-refreshing rates...');
                loadLiveRates();
            }, 30000);
        }

        // Manual refresh function
        function refreshRates() {
            debugLog('Manual refresh triggered');
            loadLiveRates();
        }

        // Initialize when page loads
        function initializePage() {
            debugLog('Page initialization started');
            
            // Add debug info div
            var debugDiv = document.createElement('div');
            debugDiv.id = 'debug-info';
            debugDiv.className = 'debug-info';
            debugDiv.innerHTML = 'Debug Log:\n';
            debugDiv.style.maxHeight = '200px';
            debugDiv.style.overflow = 'auto';
            document.body.appendChild(debugDiv);
            
            loadLiveRates().then(function() {
                debugLog('Initial load complete');
                startAutoRefresh();
            }).catch(function(error) {
                debugLog('Initial load failed, using static rates');
                startAutoRefresh();
            });
        }

        // Multiple initialization attempts
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializePage);
        } else {
            initializePage();
        }

        window.addEventListener('load', function() {
            setTimeout(function() {
                if (Object.keys(liveRates).length === 0) {
                    debugLog('Backup initialization triggered');
                    loadLiveRates();
                }
            }, 1000);
        });
        ]]></xsl:text>
    </script>
</body>
</html>
</xsl:template>

<!-- Currency Service Template -->
<xsl:template match="currencyService">
    <div class="user-card">
        <div class="converter-section">
            <h2 class="converter-title">Currency Converter</h2>
            <div class="converter-form">
                <div class="form-group">
                    <label>From Currency:</label>
                    <select id="fromCurrency" name="fromCurrency">
                        <xsl:for-each select="currencies/currency">
                            <option value="{code}">
                                <xsl:value-of select="code"/> - <xsl:value-of select="n"/>
                            </option>
                        </xsl:for-each>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>To Currency:</label>
                    <select id="toCurrency" name="toCurrency">
                        <xsl:for-each select="currencies/currency">
                            <option value="{code}">
                                <xsl:value-of select="code"/> - <xsl:value-of select="n"/>
                            </option>
                        </xsl:for-each>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Amount:</label>
                    <input type="number" id="amount" name="amount" step="0.01" min="0" required="required"/>
                </div>
            </div>
            
            <div style="text-align: center; margin-bottom: 20px;">
                <button class="convert-button" onclick="convertCurrency()">Convert</button>
                <button class="convert-button" onclick="refreshRates()" style="margin-left: 10px; background: #26a69a;">Refresh Rates</button>
            </div>
            
            <div id="result" class="result-display" style="display: none;">
                <!-- Conversion result will appear here -->
            </div>
        </div>
    </div>

    <div class="user-card">
        <h2 class="section-title">Current Exchange Rates (Auto-refreshes every 30 seconds)</h2>
        <table class="rates-table">
            <thead>
                <tr>
                    <th>Currency</th>
                    <th>Name</th>
                    <th>Rate (USD)</th>
                    <th>Last Updated</th>
                </tr>
            </thead>
            <tbody>
                <!-- Table will be populated with live data via JavaScript -->
            </tbody>
        </table>
    </div>
</xsl:template>

</xsl:stylesheet> 