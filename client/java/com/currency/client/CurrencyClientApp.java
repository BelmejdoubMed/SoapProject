package com.currency.client;

import java.util.Scanner;

/**
 * Console Application for Currency Conversion Client
 * Demonstrates usage of the Currency Conversion Web Service
 */
public class CurrencyClientApp {
    
    private static ICurrencyClient client;
    private static Scanner scanner;
    
    public static void main(String[] args) {
        System.out.println("=== Currency Conversion Client Application ===");
        System.out.println("Connecting to Currency Conversion Web Service...\n");
        
        // Initialize client and scanner
        client = new SOAPCurrencyClient();
        scanner = new Scanner(System.in);
        
        // Test service connectivity
        if (testConnection()) {
            // Run interactive menu
            runInteractiveMenu();
        } else {
            System.out.println("❌ Could not connect to the service. Please check:");
            System.out.println("   - Tomcat server is running");
            System.out.println("   - Service is deployed");
            System.out.println("   - URL: http://localhost:8000/CurrencyConversionService/services/CurrencyConverter");
        }
        
        // Cleanup
        if (client instanceof SOAPCurrencyClient) {
            ((SOAPCurrencyClient) client).close();
        }
        scanner.close();
    }
    
    /**
     * Test connection to the web service
     */
    private static boolean testConnection() {
        try {
            System.out.print("Testing service connection... ");
            boolean healthy = client.isServiceHealthy();
            if (healthy) {
                System.out.println("✅ Connected successfully!");
                return true;
            } else {
                System.out.println("❌ Service is not healthy");
                return false;
            }
        } catch (Exception e) {
            System.out.println("❌ Connection failed: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Run interactive menu for user operations
     */
    private static void runInteractiveMenu() {
        while (true) {
            displayMenu();
            
            int choice = getMenuChoice();
            System.out.println();
            
            switch (choice) {
                case 1:
                    performCurrencyConversion();
                    break;
                case 2:
                    checkServiceHealth();
                    break;
                case 3:
                    getServiceSummary();
                    break;
                case 4:
                    runAllTests();
                    break;
                case 5:
                    System.out.println("👋 Goodbye!");
                    return;
                default:
                    System.out.println("❌ Invalid choice. Please try again.");
            }
            
            System.out.println("\nPress Enter to continue...");
            scanner.nextLine();
            System.out.println();
        }
    }
    
    /**
     * Display the main menu
     */
    private static void displayMenu() {
        System.out.println("╔══════════════════════════════════════╗");
        System.out.println("║       Currency Conversion Menu      ║");
        System.out.println("╠══════════════════════════════════════╣");
        System.out.println("║ 1. Convert Currency                 ║");
        System.out.println("║ 2. Check Service Health             ║");
        System.out.println("║ 3. Get Service Summary              ║");
        System.out.println("║ 4. Run All Tests                    ║");
        System.out.println("║ 5. Exit                             ║");
        System.out.println("╚══════════════════════════════════════╝");
        System.out.print("Choose an option (1-5): ");
    }
    
    /**
     * Get menu choice from user input
     */
    private static int getMenuChoice() {
        try {
            String input = scanner.nextLine().trim();
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
    
    /**
     * Perform currency conversion operation
     */
    private static void performCurrencyConversion() {
        System.out.println("💱 Currency Conversion");
        System.out.println("─────────────────────");
        
        try {
            System.out.print("Enter amount: ");
            double amount = Double.parseDouble(scanner.nextLine().trim());
            
            System.out.print("From currency (e.g., USD): ");
            String fromCurrency = scanner.nextLine().trim().toUpperCase();
            
            System.out.print("To currency (e.g., EUR): ");
            String toCurrency = scanner.nextLine().trim().toUpperCase();
            
            System.out.println("\n🔄 Converting...");
            String result = client.convertCurrency(amount, fromCurrency, toCurrency);
            System.out.println("✅ Result: " + result);
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid amount. Please enter a valid number.");
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }
    
    /**
     * Check service health
     */
    private static void checkServiceHealth() {
        System.out.println("🏥 Service Health Check");
        System.out.println("──────────────────────");
        
        try {
            boolean healthy = client.isServiceHealthy();
            if (healthy) {
                System.out.println("✅ Service is healthy and running!");
            } else {
                System.out.println("❌ Service is not healthy");
            }
        } catch (Exception e) {
            System.out.println("❌ Error checking health: " + e.getMessage());
        }
    }
    
    /**
     * Get service summary
     */
    private static void getServiceSummary() {
        System.out.println("📊 Service Summary");
        System.out.println("─────────────────");
        
        try {
            String summary = client.getConversionSummary();
            System.out.println("ℹ️  " + summary);
        } catch (Exception e) {
            System.out.println("❌ Error getting summary: " + e.getMessage());
        }
    }
    
    /**
     * Run all tests to demonstrate functionality
     */
    private static void runAllTests() {
        System.out.println("🧪 Running All Tests");
        System.out.println("═══════════════════");
        
        // Test 1: Health Check
        System.out.println("\n1️⃣  Testing Health Check...");
        try {
            boolean healthy = client.isServiceHealthy();
            System.out.println("   Result: " + (healthy ? "✅ Healthy" : "❌ Not Healthy"));
        } catch (Exception e) {
            System.out.println("   Result: ❌ Error - " + e.getMessage());
        }
        
        // Test 2: Service Summary
        System.out.println("\n2️⃣  Testing Service Summary...");
        try {
            String summary = client.getConversionSummary();
            System.out.println("   Result: ✅ " + summary);
        } catch (Exception e) {
            System.out.println("   Result: ❌ Error - " + e.getMessage());
        }
        
        // Test 3: Currency Conversion
        System.out.println("\n3️⃣  Testing Currency Conversion...");
        try {
            String result = client.convertCurrency(100.0, "USD", "EUR");
            System.out.println("   Result: ✅ " + result);
        } catch (Exception e) {
            System.out.println("   Result: ❌ Error - " + e.getMessage());
        }
        
        // Test 4: Another Conversion
        System.out.println("\n4️⃣  Testing Another Conversion...");
        try {
            String result = client.convertCurrency(50.0, "EUR", "GBP");
            System.out.println("   Result: ✅ " + result);
        } catch (Exception e) {
            System.out.println("   Result: ❌ Error - " + e.getMessage());
        }
        
        System.out.println("\n🎉 All tests completed!");
    }
} 