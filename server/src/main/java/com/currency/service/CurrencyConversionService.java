package com.currency.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class CurrencyConversionService {
    
    private static Map<String, Double> exchangeRates = new HashMap<>();
    
    static {
        exchangeRates.put("USD", 1.0);
        exchangeRates.put("EUR", 0.85);
        exchangeRates.put("GBP", 0.73);
        exchangeRates.put("JPY", 110.0);
        exchangeRates.put("CAD", 1.25);
        exchangeRates.put("CHF", 0.92);
    }
    
    public CurrencyConversionService() {
    }
    
    public String convertCurrency(double amount, String fromCurrency, String toCurrency) {
        try {
            fromCurrency = fromCurrency.toUpperCase();
            toCurrency = toCurrency.toUpperCase();
            
            if (!exchangeRates.containsKey(fromCurrency)) {
                return "Error: Currency " + fromCurrency + " not supported";
            }
            if (!exchangeRates.containsKey(toCurrency)) {
                return "Error: Currency " + toCurrency + " not supported";
            }
            
            double fromRate = exchangeRates.get(fromCurrency);
            double toRate = exchangeRates.get(toCurrency);
            
            double usdAmount = amount / fromRate;
            double convertedAmount = usdAmount * toRate;
            
            return String.format("%.2f %s = %.2f %s", 
                               amount, fromCurrency, 
                               convertedAmount, toCurrency);
            
        } catch (Exception e) {
            return "Conversion error: " + e.getMessage();
        }
    }
    
    public String getConversionSummary() {
        StringBuilder summary = new StringBuilder();
        summary.append("Currency Conversion Service Status: Ready\n");
        summary.append("Supported currencies and rates (base: USD):\n");
        
        for (Map.Entry<String, Double> entry : exchangeRates.entrySet()) {
            summary.append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
        }
        
        return summary.toString();
    }
    
    public boolean isServiceHealthy() {
        return true;
    }
    
    public String updateExchangeRate(String currency, double rate) {
        try {
            currency = currency.toUpperCase();
            
            if (rate <= 0) {
                return "Error: Exchange rate must be positive";
            }
            
            if ("USD".equals(currency) && rate != 1.0) {
                return "Error: USD is the base currency and must have rate 1.0";
            }
            
            exchangeRates.put(currency, rate);
            return "Success: Exchange rate for " + currency + " updated to " + rate;
            
        } catch (Exception e) {
            return "Error updating rate: " + e.getMessage();
        }
    }
    
    public String addCurrency(String currency, double rate) {
        try {
            currency = currency.toUpperCase();
            
            if (rate <= 0) {
                return "Error: Exchange rate must be positive";
            }
            
            if (exchangeRates.containsKey(currency)) {
                return "Error: Currency " + currency + " already exists. Use updateExchangeRate to modify it.";
            }
            
            exchangeRates.put(currency, rate);
            return "Success: Currency " + currency + " added with rate " + rate;
            
        } catch (Exception e) {
            return "Error adding currency: " + e.getMessage();
        }
    }
    
    public String removeCurrency(String currency) {
        try {
            currency = currency.toUpperCase();
            
            if ("USD".equals(currency)) {
                return "Error: Cannot remove base currency USD";
            }
            
            if (!exchangeRates.containsKey(currency)) {
                return "Error: Currency " + currency + " not found";
            }
            
            exchangeRates.remove(currency);
            return "Success: Currency " + currency + " removed";
            
        } catch (Exception e) {
            return "Error removing currency: " + e.getMessage();
        }
    }
    
    public String getAllRates() {
        StringBuilder rates = new StringBuilder();
        rates.append("All Exchange Rates (base: USD):\n");
        
        for (Map.Entry<String, Double> entry : exchangeRates.entrySet()) {
            rates.append(entry.getKey()).append(" = ").append(entry.getValue()).append("\n");
        }
        
        return rates.toString();
    }
    
    public String getSupportedCurrencies() {
        return String.join(", ", exchangeRates.keySet());
    }
}
