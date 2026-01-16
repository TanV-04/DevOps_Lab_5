package com.devops.jenkins;

import java.util.List;
import java.util.Scanner;

public class Application {
    
    private final Calculator calculator;
    private final MathUtility mathUtility;
    
    public Application() {
        this.calculator = new Calculator();
        this.mathUtility = new MathUtility();
    }
    
    public static void main(String[] args) {
        System.out.println("=== Jenkins Distributed Pipeline Demo ===");
        System.out.println("Simple Calculator Application");
        System.out.println("Build timestamp: " + System.currentTimeMillis());
        
        Application app = new Application();
        
        if (args.length >= 3) {
            app.runCommandLine(args);
        } else {
            app.runInteractive();
        }
    }
    
    private void runCommandLine(String[] args) {
        try {
            String operation = args[0];
            double a = Double.parseDouble(args[1]);
            double b = Double.parseDouble(args[2]);
            
            double result = performOperation(operation, a, b);
            System.out.printf("Result: %.2f %s %.2f = %.2f%n", a, operation, b, result);
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            printUsage();
            System.exit(1);
        }
    }
    
    private void runInteractive() {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("\nAvailable operations: +, -, *, /, pow, sqrt, factorial");
        System.out.println("Type 'exit' to quit\n");
        
        while (true) {
            try {
                System.out.print("Enter operation (e.g., '+ 5 3' or 'sqrt 16'): ");
                String input = scanner.nextLine().trim();
                
                if ("exit".equalsIgnoreCase(input)) {
                    break;
                }
                
                String[] parts = input.split("\\s+");
                if (parts.length < 2) {
                    System.out.println("Invalid input. Please try again.");
                    continue;
                }
                
                String operation = parts[0];
                
                if ("sqrt".equals(operation) || "factorial".equals(operation)) {
                    double a = Double.parseDouble(parts[1]);
                    double result = performUnaryOperation(operation, a);
                    System.out.printf("Result: %s(%.2f) = %.2f%n", operation, a, result);
                } else if (parts.length >= 3) {
                    double a = Double.parseDouble(parts[1]);
                    double b = Double.parseDouble(parts[2]);
                    double result = performOperation(operation, a, b);
                    System.out.printf("Result: %.2f %s %.2f = %.2f%n", a, operation, b, result);
                } else {
                    System.out.println("Invalid input format. Please try again.");
                }
                
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
        
        scanner.close();
        System.out.println("Goodbye!");
    }
    
    private double performOperation(String operation, double a, double b) {
        switch (operation) {
            case "+":
                return calculator.add(a, b);
            case "-":
                return calculator.subtract(a, b);
            case "*":
                return calculator.multiply(a, b);
            case "/":
                return calculator.divide(a, b);
            case "pow":
                return mathUtility.power(a, b);
            default:
                throw new IllegalArgumentException("Unknown operation: " + operation);
        }
    }
    
    private double performUnaryOperation(String operation, double a) {
        switch (operation) {
            case "sqrt":
                return mathUtility.squareRoot(a);
            case "factorial":
                return mathUtility.factorial((int) a);
            default:
                throw new IllegalArgumentException("Unknown unary operation: " + operation);
        }
    }
    
    private void printUsage() {
        System.out.println("Usage: java -jar app.jar <operation> <number1> [number2]");
        System.out.println("Operations: +, -, *, /, pow, sqrt, factorial");
        System.out.println("Examples:");
        System.out.println("  java -jar app.jar + 5 3");
        System.out.println("  java -jar app.jar sqrt 16");
        System.out.println("  java -jar app.jar factorial 5");
    }
    
    public Calculator getCalculator() {
        return calculator;
    }
    
    public MathUtility getMathUtility() {
        return mathUtility;
    }
}
