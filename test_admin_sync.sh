#!/bin/bash

echo "Testing Admin Operations and Synchronization"
echo "============================================="

SERVICE_URL="http://localhost:8000/CurrencyConversionService/services/CurrencyConverter"

# Function to call SOAP service
call_soap() {
    local operation=$1
    local params=$2
    
    cat <<EOF | curl -s -X POST -H "Content-Type: text/xml; charset=utf-8" -H "SOAPAction: \"\"" -d @- "$SERVICE_URL"
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cur="http://service.currency.com">
    <soap:Header/>
    <soap:Body>
        <cur:$operation>
            $params
        </cur:$operation>
    </soap:Body>
</soap:Envelope>
EOF
}

echo "1. Testing Health Check..."
result=$(call_soap "isServiceHealthy" "")
if [[ $result == *"true"* ]]; then
    echo "✅ Service is healthy"
else
    echo "❌ Service health check failed"
    exit 1
fi

echo -e "\n2. Getting initial supported currencies..."
result=$(call_soap "getSupportedCurrencies" "")
echo "Initial currencies: $result"

echo -e "\n3. Getting initial exchange rates..."
result=$(call_soap "getAllRates" "")
echo "Initial rates:"
echo "$result"

echo -e "\n4. Testing Add Currency (AUD = 1.35)..."
result=$(call_soap "addCurrency" "<cur:currency>AUD</cur:currency><cur:rate>1.35</cur:rate>")
echo "Add currency result: $result"

echo -e "\n5. Verifying AUD was added..."
result=$(call_soap "getSupportedCurrencies" "")
echo "Updated currencies: $result"

if [[ $result == *"AUD"* ]]; then
    echo "✅ AUD successfully added"
else
    echo "❌ AUD was not added properly"
fi

echo -e "\n6. Testing Update Exchange Rate (EUR = 0.90)..."
result=$(call_soap "updateExchangeRate" "<cur:currency>EUR</cur:currency><cur:rate>0.90</cur:rate>")
echo "Update rate result: $result"

echo -e "\n7. Verifying EUR rate was updated..."
result=$(call_soap "getAllRates" "")
echo "Updated rates:"
echo "$result"

if [[ $result == *"EUR = 0.9"* ]]; then
    echo "✅ EUR rate successfully updated to 0.9"
else
    echo "❌ EUR rate was not updated properly"
fi

echo -e "\n8. Testing Currency Conversion with new AUD..."
result=$(call_soap "convertCurrency" "<cur:amount>100</cur:amount><cur:fromCurrency>USD</cur:fromCurrency><cur:toCurrency>AUD</cur:toCurrency>")
echo "100 USD to AUD: $result"

echo -e "\n9. Testing Remove Currency (AUD)..."
result=$(call_soap "removeCurrency" "<cur:currency>AUD</cur:currency>")
echo "Remove currency result: $result"

echo -e "\n10. Verifying AUD was removed..."
result=$(call_soap "getSupportedCurrencies" "")
echo "Final currencies: $result"

if [[ $result != *"AUD"* ]]; then
    echo "✅ AUD successfully removed"
else
    echo "❌ AUD was not removed properly"
fi

echo -e "\n============================================="
echo "🎉 Admin Operations Test Completed!"
echo "============================================="

echo -e "\nNow open the following URLs to test client synchronization:"
echo "👤 User Client: http://localhost:8090/client/user/user-client.html"
echo "⚙️  Admin Client: http://localhost:8090/client/admin/admin-client.html"
echo "🌐 Web Client: http://localhost:8090/client/web/index.html"
echo ""
echo "The clients should automatically refresh currencies every 10-15 seconds"
echo "Try adding/removing currencies in the admin client and watch them appear in the user client!" 