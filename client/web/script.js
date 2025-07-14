// Currency Conversion Web Client JavaScript

// Service Configuration
const SERVICE_CONFIG = {
    baseUrl: 'http://localhost:8000/CurrencyConversionService/services/CurrencyConverter',
    namespace: 'http://service.currency.com',
    timeout: 10000
};

// DOM Elements
const statusDot = document.getElementById('statusDot');
const statusText = document.getElementById('statusText');
const loadingOverlay = document.getElementById('loadingOverlay');

// Initialize application
document.addEventListener('DOMContentLoaded', function() {
    console.log('Currency Conversion Client initialized');
    checkInitialConnection();
});

/**
 * Check initial connection to the service
 */
async function checkInitialConnection() {
    try {
        updateStatus('checking', 'Checking connection...');
        const isHealthy = await callSoapService('isServiceHealthy', {});
        
        if (isHealthy === 'true' || isHealthy === true) {
            updateStatus('connected', 'Connected to service');
        } else {
            updateStatus('disconnected', 'Service not healthy');
        }
    } catch (error) {
        console.error('Initial connection check failed:', error);
        updateStatus('disconnected', 'Connection failed');
    }
}

/**
 * Update connection status display
 */
function updateStatus(status, message) {
    statusDot.className = `status-dot ${status}`;
    statusText.textContent = message;
}

/**
 * Show/hide loading overlay
 */
function showLoading(show = true) {
    loadingOverlay.classList.toggle('show', show);
}

/**
 * Create SOAP envelope for service calls
 */
function createSoapEnvelope(operation, parameters = {}) {
    let soapBody = `<cur:${operation} xmlns:cur="${SERVICE_CONFIG.namespace}">`;
    
    // Add parameters to SOAP body
    for (const [key, value] of Object.entries(parameters)) {
        soapBody += `<cur:${key}>${value}</cur:${key}>`;
    }
    
    soapBody += `</cur:${operation}>`;
    
    return `<?xml version="1.0" encoding="UTF-8"?>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                          xmlns:cur="${SERVICE_CONFIG.namespace}">
            <soapenv:Header/>
            <soapenv:Body>
                ${soapBody}
            </soapenv:Body>
        </soapenv:Envelope>`;
}

/**
 * Call SOAP web service
 */
async function callSoapService(operation, parameters = {}) {
    const soapEnvelope = createSoapEnvelope(operation, parameters);
    
    console.log('SOAP Request:', soapEnvelope);
    
    try {
        const response = await fetch(SERVICE_CONFIG.baseUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'text/xml; charset=utf-8',
                'SOAPAction': `"${operation}"`
            },
            body: soapEnvelope
        });

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const responseText = await response.text();
        console.log('SOAP Response:', responseText);
        return extractValueFromSoapResponse(responseText);
        
    } catch (error) {
        console.error(`SOAP call failed for ${operation}:`, error);
        throw new Error(`Service call failed: ${error.message}`);
    }
}

/**
 * Extract value from SOAP response
 */
function extractValueFromSoapResponse(soapResponse) {
    try {
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(soapResponse, 'text/xml');
        
        // Look for return value in different possible locations
        const returnElements = [
            xmlDoc.querySelector('return'),
            xmlDoc.querySelector('[localName="return"]'),
            xmlDoc.getElementsByTagName('return')[0]
        ].filter(Boolean);
        
        if (returnElements.length > 0) {
            return returnElements[0].textContent.trim();
        }
        
        // If no return element, try to get the first text content from body
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

/**
 * Display result in a container
 */
function displayResult(containerId, message, type = 'info') {
    const container = document.getElementById(containerId);
    container.className = `${containerId} show result-${type}`;
    container.innerHTML = `
        <div style="display: flex; align-items: center; gap: 10px;">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle'}"></i>
            <div>${message}</div>
        </div>`;
}

/**
 * Check service health
 */
async function checkHealth() {
    const btn = document.getElementById('healthBtn');
    const originalText = btn.innerHTML;
    
    try {
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Checking...';
        
        const result = await callSoapService('isServiceHealthy');
        const isHealthy = result === 'true' || result === true;
        
        if (isHealthy) {
            displayResult('healthResult', 'Service is healthy and running! ✅', 'success');
            updateStatus('connected', 'Service is healthy');
        } else {
            displayResult('healthResult', 'Service is not healthy ❌', 'error');
            updateStatus('disconnected', 'Service not healthy');
        }
        
    } catch (error) {
        displayResult('healthResult', `Health check failed: ${error.message}`, 'error');
        updateStatus('disconnected', 'Connection failed');
    } finally {
        btn.disabled = false;
        btn.innerHTML = originalText;
    }
}

/**
 * Convert currency
 */
async function convertCurrency(event) {
    event.preventDefault();
    
    const btn = document.getElementById('convertBtn');
    const originalText = btn.innerHTML;
    
    try {
        // Get form values
        const amount = parseFloat(document.getElementById('amount').value);
        const fromCurrency = document.getElementById('fromCurrency').value;
        const toCurrency = document.getElementById('toCurrency').value;
        
        // Validation
        if (isNaN(amount) || amount <= 0) {
            displayResult('conversionResult', 'Please enter a valid amount greater than 0', 'error');
            return;
        }
        
        if (fromCurrency === toCurrency) {
            displayResult('conversionResult', 'Please select different currencies', 'error');
            return;
        }
        
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Converting...';
        showLoading(true);
        
        const result = await callSoapService('convertCurrency', {
            amount: amount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency
        });
        
        displayResult('conversionResult', `💱 ${result}`, 'success');
        
    } catch (error) {
        displayResult('conversionResult', `Conversion failed: ${error.message}`, 'error');
    } finally {
        btn.disabled = false;
        btn.innerHTML = originalText;
        showLoading(false);
    }
}

/**
 * Get service summary
 */
async function getSummary() {
    const btn = document.getElementById('summaryBtn');
    const originalText = btn.innerHTML;
    
    try {
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
        
        const result = await callSoapService('getConversionSummary');
        displayResult('summaryResult', result.replace(/\n/g, '<br>'), 'info');
        
    } catch (error) {
        displayResult('summaryResult', `Failed to get summary: ${error.message}`, 'error');
    } finally {
        btn.disabled = false;
        btn.innerHTML = originalText;
    }
}

/**
 * Get supported currencies and update dropdowns
 */
async function getSupportedCurrencies() {
    try {
        const result = await callSoapService('getSupportedCurrencies');
        return result.split(', ').sort();
    } catch (error) {
        console.error('Error getting supported currencies:', error);
        return ['USD', 'EUR', 'GBP', 'JPY', 'CAD']; // fallback
    }
}

/**
 * Update currency dropdowns dynamically
 */
async function updateCurrencyDropdowns() {
    try {
        const currencies = await getSupportedCurrencies();
        const dropdowns = document.querySelectorAll('select[id*="Currency"]');
        
        dropdowns.forEach(dropdown => {
            const currentValue = dropdown.value;
            dropdown.innerHTML = '';
            
            currencies.forEach(currency => {
                const option = document.createElement('option');
                option.value = currency;
                option.textContent = currency;
                dropdown.appendChild(option);
            });
            
            // Restore selection if it still exists
            if (currencies.includes(currentValue)) {
                dropdown.value = currentValue;
            }
        });
    } catch (error) {
        console.error('Error updating currency dropdowns:', error);
    }
}

/**
 * Admin function: Get all exchange rates
 */
async function getAllRates() {
    try {
        const result = await callSoapService('getAllRates');
        displayResult('adminResult', result.replace(/\n/g, '<br>'), 'info');
    } catch (error) {
        displayResult('adminResult', `Failed to get rates: ${error.message}`, 'error');
    }
}

/**
 * Admin function: Update exchange rate
 */
async function updateExchangeRate(currency, rate) {
    try {
        const result = await callSoapService('updateExchangeRate', {
            currency: currency.toUpperCase(),
            rate: parseFloat(rate)
        });
        
        if (result.includes('Success')) {
            await updateCurrencyDropdowns(); // Refresh dropdowns
            displayResult('adminResult', result, 'success');
        } else {
            displayResult('adminResult', result, 'error');
        }
        
        return result;
    } catch (error) {
        const errorMsg = `Failed to update rate: ${error.message}`;
        displayResult('adminResult', errorMsg, 'error');
        throw new Error(errorMsg);
    }
}

/**
 * Admin function: Add new currency
 */
async function addCurrency(currency, rate) {
    try {
        const result = await callSoapService('addCurrency', {
            currency: currency.toUpperCase(),
            rate: parseFloat(rate)
        });
        
        if (result.includes('Success')) {
            await updateCurrencyDropdowns(); // Refresh dropdowns
            displayResult('adminResult', result, 'success');
        } else {
            displayResult('adminResult', result, 'error');
        }
        
        return result;
    } catch (error) {
        const errorMsg = `Failed to add currency: ${error.message}`;
        displayResult('adminResult', errorMsg, 'error');
        throw new Error(errorMsg);
    }
}

/**
 * Admin function: Remove currency
 */
async function removeCurrency(currency) {
    try {
        const result = await callSoapService('removeCurrency', {
            currency: currency.toUpperCase()
        });
        
        if (result.includes('Success')) {
            await updateCurrencyDropdowns(); // Refresh dropdowns
            displayResult('adminResult', result, 'success');
        } else {
            displayResult('adminResult', result, 'error');
        }
        
        return result;
    } catch (error) {
        const errorMsg = `Failed to remove currency: ${error.message}`;
        displayResult('adminResult', errorMsg, 'error');
        throw new Error(errorMsg);
    }
}

/**
 * Test all operations including admin ones
 */
async function testAllOperations() {
    const btn = document.getElementById('testAllBtn');
    const originalText = btn.innerHTML;
    const container = document.getElementById('testResults');
    
    try {
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing...';
        showLoading(true);
        
        container.className = 'test-results show';
        container.innerHTML = '<h4>🧪 Running Tests...</h4>';
        
        const tests = [
            {
                name: 'Health Check',
                operation: 'isServiceHealthy',
                params: {},
                icon: '🏥'
            },
            {
                name: 'Service Summary',
                operation: 'getConversionSummary',
                params: {},
                icon: '📊'
            },
            {
                name: 'Supported Currencies',
                operation: 'getSupportedCurrencies',
                params: {},
                icon: '💰'
            },
            {
                name: 'Currency Conversion (USD to EUR)',
                operation: 'convertCurrency',
                params: { amount: 100, fromCurrency: 'USD', toCurrency: 'EUR' },
                icon: '💱'
            },
            {
                name: 'All Exchange Rates',
                operation: 'getAllRates',
                params: {},
                icon: '📈'
            }
        ];
        
        let results = '<h4>🧪 Test Results</h4>';
        
        for (let i = 0; i < tests.length; i++) {
            const test = tests[i];
            results += `<div class="test-item">
                <strong>${test.icon} ${test.name}</strong><br>
                <span style="color: #666;">Testing...</span>
            </div>`;
            container.innerHTML = results;
            
            try {
                const result = await callSoapService(test.operation, test.params);
                const lastTestDiv = container.lastElementChild;
                lastTestDiv.className = 'test-item success';
                lastTestDiv.innerHTML = `
                    <strong>✅ ${test.icon} ${test.name}</strong><br>
                    <span style="color: #2e7d32;">Result: ${result.substring(0, 100)}${result.length > 100 ? '...' : ''}</span>
                `;
            } catch (error) {
                const lastTestDiv = container.lastElementChild;
                lastTestDiv.className = 'test-item error';
                lastTestDiv.innerHTML = `
                    <strong>❌ ${test.icon} ${test.name}</strong><br>
                    <span style="color: #c62828;">Error: ${error.message}</span>
                `;
            }
            
            // Small delay between tests for better UX
            await new Promise(resolve => setTimeout(resolve, 500));
        }
        
        results += '<div style="margin-top: 15px; font-weight: bold; color: #667eea;">🎉 All tests completed!</div>';
        container.innerHTML = results;
        
    } catch (error) {
        container.innerHTML = `<div class="test-item error">
            <strong>❌ Test Suite Failed</strong><br>
            <span style="color: #c62828;">Error: ${error.message}</span>
        </div>`;
    } finally {
        btn.disabled = false;
        btn.innerHTML = originalText;
        showLoading(false);
    }
}

// Auto-refresh currency dropdowns every 10 seconds
setInterval(updateCurrencyDropdowns, 10000);

// Initialize currency dropdowns on load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(updateCurrencyDropdowns, 2000); // Wait for initial connection
});

// Utility function to handle CORS issues in development
function handleCorsError() {
    const corsMessage = `
        <div style="background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 8px; margin: 10px 0;">
            <strong>⚠️ CORS Issue Detected</strong><br>
            <p>If you're seeing CORS errors, try one of these solutions:</p>
            <ul style="margin: 10px 0; padding-left: 20px;">
                <li>Use a browser extension to disable CORS (for development only)</li>
                <li>Start Chrome with: <code>--disable-web-security --user-data-dir</code></li>
                <li>Deploy this client to the same server as your web service</li>
                <li>Configure CORS headers on your Tomcat server</li>
            </ul>
        </div>
    `;
    return corsMessage;
} 