package com.currency.client;

/**
 * Currency Conversion Client Interface
 * Defines methods to interact with the Currency Conversion Web Service
 */
public interface ICurrencyClient {
    
    /**
     * Convert currency amount from one currency to another
     * @param amount The amount to convert
     * @param fromCurrency Source currency code
     * @param toCurrency Target currency code
     * @return Conversion result as string
     */
    String convertCurrency(double amount, String fromCurrency, String toCurrency);
    
    /**
     * Check if the service is healthy and available
     * @return true if service is healthy, false otherwise
     */
    boolean isServiceHealthy();
    
    /**
     * Get service status and conversion summary
     * @return Service status and supported currencies
     */
    String getConversionSummary();
} 