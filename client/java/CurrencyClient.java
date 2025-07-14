import java.io.*;
import java.net.*;
import java.util.Scanner;

public class CurrencyClient {
    private static final String SERVICE_URL = "http://localhost:8000/CurrencyConversionService/services/CurrencyConverter";
    private static Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {
        printHeader("Currency Conversion Client");
        
        while (true) {
            showMenu();
            int choice = getIntInput("Choice (1-6): ");
            
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
                    adminMenu();
                    break;
                case 5:
                    getSupportedCurrencies();
                    break;
                case 6:
                    return;
                default:
                    System.out.println("Invalid option");
            }
        }
    }
    
    private static void showMenu() {
        printHeader("Main Menu");
        System.out.println("1. Convert Currency");
        System.out.println("2. Check Health");
        System.out.println("3. Summary");
        System.out.println("4. Admin");
        System.out.println("5. Currencies");
        System.out.println("6. Exit");
    }
    
    private static void adminMenu() {
        while (true) {
            printHeader("Admin Menu");
            System.out.println("1. View Rates");
            System.out.println("2. Update Rate");
            System.out.println("3. Add Currency");
            System.out.println("4. Remove Currency");
            System.out.println("5. Back");
            
            int choice = getIntInput("Choice (1-5): ");
            
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
                    System.out.println("Invalid option");
            }
        }
    }
    
    private static void convertCurrency() {
        printHeader("Currency Conversion");
        
        double amount = getDoubleInput("Amount: ");
        System.out.print("From currency: ");
        String fromCurrency = scanner.nextLine().trim().toUpperCase();
        System.out.print("To currency: ");
        String toCurrency = scanner.nextLine().trim().toUpperCase();
        
        String params = String.format(
            "<cur:amount>%f</cur:amount><cur:fromCurrency>%s</cur:fromCurrency><cur:toCurrency>%s</cur:toCurrency>",
            amount, fromCurrency, toCurrency
        );
        
        String result = callWebService("convertCurrency", params);
        System.out.println(result);
    }
    
    private static void checkHealth() {
        printHeader("Health Check");
        String result = callWebService("isServiceHealthy", "");
        boolean healthy = result != null && result.contains("true");
        System.out.println(healthy ? "Service is healthy" : "Service is not healthy");
    }
    
    private static void getSummary() {
        printHeader("Service Summary");
        String result = callWebService("getConversionSummary", "");
        System.out.println(result);
    }
    
    private static void getAllRates() {
        printHeader("Exchange Rates");
        String result = callWebService("getAllRates", "");
        System.out.println(result);
    }
    
    private static void updateRate() {
        printHeader("Update Rate");
        
        System.out.print("Currency code: ");
        String currency = scanner.nextLine().trim().toUpperCase();
        double rate = getDoubleInput("New rate: ");
        
        String params = String.format(
            "<cur:currency>%s</cur:currency><cur:rate>%f</cur:rate>",
            currency, rate
        );
        
        String result = callWebService("updateExchangeRate", params);
        System.out.println(result);
    }
    
    private static void addCurrency() {
        printHeader("Add Currency");
        
        System.out.print("Currency code: ");
        String currency = scanner.nextLine().trim().toUpperCase();
        double rate = getDoubleInput("Exchange rate: ");
        
        String params = String.format(
            "<cur:currency>%s</cur:currency><cur:rate>%f</cur:rate>",
            currency, rate
        );
        
        String result = callWebService("addCurrency", params);
        System.out.println(result);
    }
    
    private static void removeCurrency() {
        printHeader("Remove Currency");
        
        System.out.print("Currency code: ");
        String currency = scanner.nextLine().trim().toUpperCase();
        
        String params = String.format("<cur:currency>%s</cur:currency>", currency);
        
        String result = callWebService("removeCurrency", params);
        System.out.println(result);
    }
    
    private static void getSupportedCurrencies() {
        printHeader("Supported Currencies");
        String result = callWebService("getSupportedCurrencies", "");
        System.out.println(result);
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
            
            try (OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream())) {
                writer.write(soapBody);
                writer.flush();
            }
            
            StringBuilder response = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
            }
            
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
                    startIndex += tag.length() + 2;
                    return responseText.substring(startIndex, endIndex);
                }
            }
            
            return "Error: Could not parse response";
            
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
    
    private static void printHeader(String title) {
        System.out.println("\n=== " + title + " ===");
    }
    
    private static int getIntInput(String prompt) {
        while (true) {
            System.out.print(prompt);
            try {
                String input = scanner.nextLine().trim();
                return Integer.parseInt(input);
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number");
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
                System.out.println("Please enter a valid number");
            }
        }
    }
} 