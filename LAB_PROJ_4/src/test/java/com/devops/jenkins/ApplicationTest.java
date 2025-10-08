package com.devops.jenkins;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Integration tests for the Application class
 * These tests verify the interaction between Calculator and MathUtility
 */
@DisplayName("Application Integration Tests")
class ApplicationTest {
    
    private Application application;
    
    @BeforeEach
    void setUp() {
        application = new Application();
        System.out.println("Setting up Application integration test - Running on Jenkins test-node");
    }
    
    @Test
    @DisplayName("Application should initialize with Calculator and MathUtility")
    void testApplicationInitialization() {
        assertNotNull(application.getCalculator());
        assertNotNull(application.getMathUtility());
    }
    
    @Test
    @DisplayName("Calculator integration should work correctly")
    void testCalculatorIntegration() {
        Calculator calc = application.getCalculator();
        
        assertEquals(10.0, calc.add(7.0, 3.0), 0.001);
        assertEquals(21.0, calc.multiply(7.0, 3.0), 0.001);
        assertTrue(calc.isPrime(7));
        assertFalse(calc.isEven(7));
    }
    
    @Test
    @DisplayName("MathUtility integration should work correctly")
    void testMathUtilityIntegration() {
        MathUtility mathUtil = application.getMathUtility();
        
        assertEquals(49.0, mathUtil.power(7.0, 2.0), 0.001);
        assertEquals(5040, mathUtil.factorial(7));
        assertEquals(1, mathUtil.gcd(7, 3));
        assertEquals(21, mathUtil.lcm(7, 3));
    }
    
    @Test
    @DisplayName("Application components should work together")
    void testComponentIntegration() {
        Calculator calc = application.getCalculator();
        MathUtility mathUtil = application.getMathUtility();
        
        double base = calc.add(5.0, 2.0);
        double result = mathUtil.power(base, 2.0);
        double finalResult = calc.subtract(result, 1.0);
        
        assertEquals(48.0, finalResult, 0.001);
    }
    
    @Test
    @DisplayName("Application should handle edge cases properly")
    void testEdgeCases() {
        Calculator calc = application.getCalculator();
        MathUtility mathUtil = application.getMathUtility();
        
        assertThrows(ArithmeticException.class, () -> calc.divide(10.0, 0.0));
        
        assertThrows(IllegalArgumentException.class, () -> mathUtil.squareRoot(-1.0));
        
        assertThrows(IllegalArgumentException.class, () -> mathUtil.factorial(-1));
    }
    
    @Test
    @DisplayName("Application should work with large numbers")
    void testLargeNumberHandling() {
        Calculator calc = application.getCalculator();
        MathUtility mathUtil = application.getMathUtility();
        
        double large1 = 1_000_000.0;
        double large2 = 2_000_000.0;
        
        assertEquals(3_000_000.0, calc.add(large1, large2), 0.001);
        assertEquals(2_000_000_000_000.0, calc.multiply(large1, large2), 0.001);
        assertEquals(1_000_000_000_000.0, mathUtil.power(large1, 2.0), 0.001);
    }
}
