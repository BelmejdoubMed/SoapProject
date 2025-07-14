const SERVICE_CONFIG = {
    baseUrl: 'http://localhost:8000/CurrencyConversionService/services/CurrencyConverter',
    namespace: 'http://service.currency.com',
    timeout: 10000
};

const statusDot = document.getElementById('statusDot');
const statusText = document.getElementById('statusText');
const loadingOverlay = document.getElementById('loadingOverlay');

document.addEventListener('DOMContentLoaded', function() {
    checkInitialConnection();
});

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
        updateStatus('disconnected', 'Connection failed');
    }
}

function updateStatus(status, message) {
    statusDot.className = `status-dot ${status}`;
    statusText.textContent = message;
}

function showLoading(show = true) {
    loadingOverlay.classList.toggle('show', show);
}

function createSoapEnvelope(operation, parameters = {}) {
    let soapBody = `<cur:${operation} xmlns:cur="${SERVICE_CONFIG.namespace}">`;
    
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

async function callSoapService(operation, parameters = {}) {
    const soapEnvelope = createSoapEnvelope(operation, parameters);
    
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
        return extractValueFromSoapResponse(responseText);
        
    } catch (error) {
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
        throw new Error('Invalid SOAP response format');
    }
}

function displayResult(containerId, message, type = 'info') {
    const container = document.getElementById(containerId);
    container.className = `${containerId} show result-${type}`;
    container.innerHTML = `
        <div style="display: flex; align-items: center; gap: 10px;">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle'}"></i>
            <div>${message}</div>
        </div>`;
}

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

async function convertCurrency(event) {
    event.preventDefault();
    
    const btn = document.getElementById('convertBtn');
    const originalText = btn.innerHTML;
    
    try {
        const amount = parseFloat(document.getElementById('amount').value);
        const fromCurrency = document.getElementById('fromCurrency').value;
        const toCurrency = document.getElementById('toCurrency').value;
        
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

async function getSupportedCurrencies() {
    try {
        const result = await callSoapService('getSupportedCurrencies');
        return result.split(',').map(c => c.trim());
    } catch (error) {
        return [];
    }
}

async function updateCurrencyDropdowns() {
    try {
        const currencies = await getSupportedCurrencies();
        const fromSelect = document.getElementById('fromCurrency');
        const toSelect = document.getElementById('toCurrency');
        
        fromSelect.innerHTML = '';
        toSelect.innerHTML = '';
        
        currencies.forEach(currency => {
            fromSelect.add(new Option(currency, currency));
            toSelect.add(new Option(currency, currency));
        });
        
    } catch (error) {
        displayResult('conversionResult', 'Failed to update currency list', 'error');
    }
}

async function getAllRates() {
    try {
        const result = await callSoapService('getAllRates');
        displayResult('ratesResult', result.replace(/\n/g, '<br>'), 'info');
    } catch (error) {
        displayResult('ratesResult', `Failed to get rates: ${error.message}`, 'error');
    }
}

async function updateExchangeRate(currency, rate) {
    try {
        const result = await callSoapService('updateExchangeRate', {
            currency: currency,
            rate: rate
        });
        
        displayResult('adminResult', result, 'success');
        await updateCurrencyDropdowns();
        await getAllRates();
        
    } catch (error) {
        displayResult('adminResult', `Failed to update rate: ${error.message}`, 'error');
    }
}

async function addCurrency(currency, rate) {
    try {
        const result = await callSoapService('addCurrency', {
            currency: currency,
            rate: rate
        });
        
        displayResult('adminResult', result, 'success');
        await updateCurrencyDropdowns();
        await getAllRates();
        
    } catch (error) {
        displayResult('adminResult', `Failed to add currency: ${error.message}`, 'error');
    }
}

async function removeCurrency(currency) {
    try {
        const result = await callSoapService('removeCurrency', {
            currency: currency
        });
        
        displayResult('adminResult', result, 'success');
        await updateCurrencyDropdowns();
        await getAllRates();
        
    } catch (error) {
        displayResult('adminResult', `Failed to remove currency: ${error.message}`, 'error');
    }
}

async function testAllOperations() {
    const testBtn = document.getElementById('testBtn');
    const originalText = testBtn.innerHTML;
    const testResults = document.getElementById('testResults');
    
    try {
        testBtn.disabled = true;
        testBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing...';
        testResults.innerHTML = '';
        
        const tests = [
            {
                name: 'Health Check',
                fn: async () => {
                    const result = await callSoapService('isServiceHealthy');
                    if (result !== 'true') throw new Error('Service not healthy');
                }
            },
            {
                name: 'Get Summary',
                fn: async () => {
                    const result = await callSoapService('getConversionSummary');
                    if (!result.includes('Ready')) throw new Error('Service not ready');
                }
            },
            {
                name: 'Get Currencies',
                fn: async () => {
                    const result = await callSoapService('getSupportedCurrencies');
                    if (!result.includes('USD')) throw new Error('Base currency not found');
                }
            },
            {
                name: 'Convert Currency',
                fn: async () => {
                    const result = await callSoapService('convertCurrency', {
                        amount: 100,
                        fromCurrency: 'USD',
                        toCurrency: 'EUR'
                    });
                    if (!result.includes('EUR')) throw new Error('Conversion failed');
                }
            }
        ];
        
        for (const test of tests) {
            try {
                await test.fn();
                testResults.innerHTML += `<div class="test-result success">✅ ${test.name} passed</div>`;
            } catch (error) {
                testResults.innerHTML += `<div class="test-result error">❌ ${test.name} failed: ${error.message}</div>`;
            }
        }
        
    } catch (error) {
        testResults.innerHTML += `<div class="test-result error">❌ Tests failed: ${error.message}</div>`;
    } finally {
        testBtn.disabled = false;
        testBtn.innerHTML = originalText;
    }
} 