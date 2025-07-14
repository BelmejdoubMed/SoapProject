import java.io.*;
import java.net.*;
import java.util.Scanner;

public class CurrencyClient {
    private static final String SERVICE_URL = "http://localhost:8000/CurrencyConversionService/services/CurrencyConverter";
    private static Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {
        System.out.println("=== Currency Conversion Client ===");
        System.out.println("Connecting to: " + SERVICE_URL);
        
        while (true) {
            showMenu();
            int choice = getIntInput("Choose an option (1-6): ");
            
            switch (choice) {
                case 1:
                    convertCurrency();
                    break;
                case 2:
                    checkHealth();
                    break;
                case 3:
                    getSummary();
                    break;
                case 4:
                    // Admin functions
                    adminMenu();
                    break;
                case 5:
                    getSupportedCurrencies();
                    break;
                case 6:
                    System.out.println("Goodbye!");
                    return;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
            System.out.println();
        }
    }
    
    private static void showMenu() {
        System.out.println("\n=== Main Menu ===");
        System.out.println("1. Convert Currency");
        System.out.println("2. Check Service Health");
        System.out.println("3. Get Service Summary");
        System.out.println("4. Admin Functions");
        System.out.println("5. Get Supported Currencies");
        System.out.println("6. Exit");
    }
    
    private static void adminMenu() {
        while (true) {
            System.out.println("\n=== Admin Menu ===");
            System.out.println("1. View All Exchange Rates");
            System.out.println("2. Update Exchange Rate");
            System.out.println("3. Add New Currency");
            System.out.println("4. Remove Currency");
            System.out.println("5. Back to Main Menu");
            
            int choice = getIntInput("Choose admin option (1-5): ");
            
            switch (choice) {
                case 1:
                    getAllRates();
                    break;
                case 2:
                    updateRate();
                    break;
                case 3:
                    addCurrency();
                    break;
                case 4:
                    removeCurrency();
                    break;
                case 5:
                    return;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
    }
    
    private static void convertCurrency() {
        System.out.println("\n--- Currency Conversion ---");
        
        double amount = getDoubleInput("Enter amount: ");
        System.out.print("Enter from currency (e.g., USD): ");
        String fromCurrency = scanner.nextLine().trim().toUpperCase();
        System.out.print("Enter to currency (e.g., EUR): ");
        String toCurrency = scanner.nextLine().trim().toUpperCase();
        
        String params = String.format(
            "<cur:amount>%f</cur:amount><cur:fromCurrency>%s</cur:fromCurrency><cur:toCurrency>%s</cur:toCurrency>",
            amount, fromCurrency, toCurrency
        );
        
        String result = callWebService("convertCurrency", params);
        System.out.println("Result: " + result);
    }
    
    private static void checkHealth() {
        System.out.println("\n--- Service Health Check ---");
        String result = callWebService("isServiceHealthy", "");
        boolean healthy = result != null && result.contains("true");
        System.out.println("Service is " + (healthy ? "healthy" : "not healthy"));
    }
    
    private static void getSummary() {
        System.out.println("\n--- Service Summary ---");
        String result = callWebService("getConversionSummary", "");
        System.out.println(result);
    }
    
    private static void getAllRates() {
        System.out.println("\n--- All Exchange Rates ---");
        String result = callWebService("getAllRates", "");
        System.out.println(result);
    }
    
    private static void updateRate() {
        System.out.println("\n--- Update Exchange Rate ---");
        
        System.out.print("Enter currency code (e.g., EUR): ");
        String currency = scanner.nextLine().trim().toUpperCase();
        double rate = getDoubleInput("Enter new rate (to USD): ");
        
        String params = String.format(
            "<cur:currency>%s</cur:currency><cur:rate>%f</cur:rate>",
            currency, rate
        );
        
        String result = callWebService("updateExchangeRate", params);
        System.out.println("Result: " + result);
    }
    
    private static void addCurrency() {
        System.out.println("\n--- Add New Currency ---");
        
        System.out.print("Enter currency code (e.g., AUD): ");
        String currency = scanner.nextLine().trim().toUpperCase();
        double rate = getDoubleInput("Enter exchange rate (to USD): ");
        
        String params = String.format(
            "<cur:currency>%s</cur:currency><cur:rate>%f</cur:rate>",
            currency, rate
        );
        
        String result = callWebService("addCurrency", params);
        System.out.println("Result: " + result);
    }
    
    private static void removeCurrency() {
        System.out.println("\n--- Remove Currency ---");
        
        System.out.print("Enter currency code to remove (e.g., JPY): ");
        String currency = scanner.nextLine().trim().toUpperCase();
        
        String params = String.format("<cur:currency>%s</cur:currency>", currency);
        
        String result = callWebService("removeCurrency", params);
        System.out.println("Result: " + result);
    }
    
    private static void getSupportedCurrencies() {
        System.out.println("\n--- Supported Currencies ---");
        String result = callWebService("getSupportedCurrencies", "");
        System.out.println("Supported currencies: " + result);
    }
    
    private static String callWebService(String method, String params) {
        try {
            String soapBody = createSOAPEnvelope(method, params);
            
            URL url = new URL(SERVICE_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "text/xml; charset=utf-8");
            connection.setRequestProperty("SOAPAction", "");
            connection.setDoOutput(true);
            
            // Send request
            try (OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream())) {
                writer.write(soapBody);
                writer.flush();
            }
            
            // Read response
            StringBuilder response = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
            }
            
            // Parse SOAP response
            String responseText = response.toString();
            int startIndex = responseText.indexOf("<ns:return>");
            if (startIndex == -1) {
                startIndex = responseText.indexOf("<return>");
            }
            
            if (startIndex != -1) {
                int endIndex = responseText.indexOf("</ns:return>");
                if (endIndex == -1) {
                    endIndex = responseText.indexOf("</return>");
                }
                
                if (endIndex != -1) {
                    String tag = responseText.substring(startIndex).startsWith("<ns:return>") ? "ns:return" : "return";
                    startIndex += tag.length() + 2; // +2 for < and >
                    return responseText.substring(startIndex, endIndex);
                }
            }
            
            return "Could not parse response";
            
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
    
    private static String createSOAPEnvelope(String method, String params) {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
               "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" " +
               "xmlns:cur=\"http://service.currency.com\">" +
               "<soap:Header/>" +
               "<soap:Body>" +
               "<cur:" + method + ">" +
               params +
               "</cur:" + method + ">" +
               "</soap:Body>" +
               "</soap:Envelope>";
    }
    
    private static int getIntInput(String prompt) {
        while (true) {
            System.out.print(prompt);
            try {
                String input = scanner.nextLine().trim();
                return Integer.parseInt(input);
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number.");
            }
        }
    }
    
    private static double getDoubleInput(String prompt) {
        while (true) {
            System.out.print(prompt);
            try {
                String input = scanner.nextLine().trim();
                return Double.parseDouble(input);
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number.");
            }
        }
    }
} 