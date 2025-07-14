package com.currency.client;

import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.client.Options;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMNamespace;

/**
 * SOAP Client implementation for Currency Conversion Web Service
 * Uses Apache Axis2 to communicate with the server
 */
public class SOAPCurrencyClient implements ICurrencyClient {
    
    private static final String SERVICE_URL = "http://localhost:8000/CurrencyConversionService/services/CurrencyConverter";
    private static final String NAMESPACE = "http://service.currency.com";
    
    private ServiceClient serviceClient;
    private OMFactory factory;
    private OMNamespace namespace;
    
    public SOAPCurrencyClient() {
        try {
            // Initialize Axis2 ServiceClient
            serviceClient = new ServiceClient();
            Options options = new Options();
            options.setTo(new EndpointReference(SERVICE_URL));
            serviceClient.setOptions(options);
            
            // Initialize OM (Object Model) for XML creation
            factory = OMAbstractFactory.getOMFactory();
            namespace = factory.createOMNamespace(NAMESPACE, "cur");
            
        } catch (Exception e) {
            System.err.println("Error initializing SOAP client: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public String convertCurrency(double amount, String fromCurrency, String toCurrency) {
        try {
            // Create SOAP request
            OMElement request = factory.createOMElement("convertCurrency", namespace);
            
            OMElement amountElement = factory.createOMElement("amount", namespace);
            amountElement.setText(String.valueOf(amount));
            request.addChild(amountElement);
            
            OMElement fromElement = factory.createOMElement("fromCurrency", namespace);
            fromElement.setText(fromCurrency);
            request.addChild(fromElement);
            
            OMElement toElement = factory.createOMElement("toCurrency", namespace);
            toElement.setText(toCurrency);
            request.addChild(toElement);
            
            // Send request and get response
            OMElement response = serviceClient.sendReceive(request);
            return extractTextFromResponse(response);
            
        } catch (Exception e) {
            return "Error converting currency: " + e.getMessage();
        }
    }
    
    @Override
    public boolean isServiceHealthy() {
        try {
            // Create SOAP request
            OMElement request = factory.createOMElement("isServiceHealthy", namespace);
            
            // Send request and get response
            OMElement response = serviceClient.sendReceive(request);
            String result = extractTextFromResponse(response);
            return Boolean.parseBoolean(result);
            
        } catch (Exception e) {
            System.err.println("Error checking service health: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public String getConversionSummary() {
        try {
            // Create SOAP request
            OMElement request = factory.createOMElement("getConversionSummary", namespace);
            
            // Send request and get response
            OMElement response = serviceClient.sendReceive(request);
            return extractTextFromResponse(response);
            
        } catch (Exception e) {
            return "Error getting conversion summary: " + e.getMessage();
        }
    }
    
    /**
     * Extract text content from SOAP response
     */
    private String extractTextFromResponse(OMElement response) {
        if (response != null) {
            // Get the first child element (return value)
            OMElement returnElement = response.getFirstElement();
            if (returnElement != null) {
                return returnElement.getText();
            }
            return response.getText();
        }
        return "";
    }
    
    /**
     * Close the service client connection
     */
    public void close() {
        try {
            if (serviceClient != null) {
                serviceClient.cleanup();
            }
        } catch (Exception e) {
            System.err.println("Error closing client: " + e.getMessage());
        }
    }
} 