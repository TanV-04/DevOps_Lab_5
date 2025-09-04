package com.devops.jenkins;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Calculator Tests")
class CalculatorTest {
    
    private Calculator calculator;
    
    @BeforeEach
    void setUp() {
        calculator = new Calculator();
        System.out.println("Setting up Calculator test - Running on Jenkins test-node");
    }
    
    @Nested
    @DisplayName("Basic Arithmetic Operations")
    class BasicArithmeticTests {
        
        @Test
        @DisplayName("Addition should work correctly")
        void testAddition() {
            assertEquals(8.0, calculator.add(5.0, 3.0), 0.001);
            assertEquals(-2.0, calculator.add(-5.0, 3.0), 0.001);
            assertEquals(5.0, calculator.add(5.0, 0.0), 0.001);
            assertEquals(5.7, calculator.add(2.3, 3.4), 0.001);
        }
        
        @Test
        @DisplayName("Subtraction should work correctly")
        void testSubtraction() {
            assertEquals(2.0, calculator.subtract(5.0, 3.0), 0.001);
            assertEquals(-2.0, calculator.subtract(3.0, 5.0), 0.001);
            assertEquals(5.0, calculator.subtract(5.0, 0.0), 0.001);
            assertEquals(-1.1, calculator.subtract(2.3, 3.4), 0.001);
        }
        
        @Test
        @DisplayName("Multiplication should work correctly")
        void testMultiplication() {
            assertEquals(15.0, calculator.multiply(5.0, 3.0), 0.001);
            assertEquals(-15.0, calculator.multiply(-5.0, 3.0), 0.001);
            assertEquals(15.0, calculator.multiply(-5.0, -3.0), 0.001);
            assertEquals(0.0, calculator.multiply(5.0, 0.0), 0.001);
            assertEquals(7.82, calculator.multiply(2.3, 3.4), 0.001);
        }
        
        @Test
        @DisplayName("Division should work correctly")
        void testDivision() {
            assertEquals(2.5, calculator.divide(5.0, 2.0), 0.001);
            assertEquals(-2.5, calculator.divide(-5.0, 2.0), 0.001);
            assertEquals(2.5, calculator.divide(-5.0, -2.0), 0.001);
            assertEquals(0.676, calculator.divide(2.3, 3.4), 0.001);
        }
        
        @Test
        @DisplayName("Division by zero should throw exception")
        void testDivisionByZero() {
            ArithmeticException exception = assertThrows(
                ArithmeticException.class,
                () -> calculator.divide(5.0, 0.0)
            );
            assertEquals("Division by zero is not allowed", exception.getMessage());
        }
    }
    
    @Nested
    @DisplayName("Utility Functions")
    class UtilityFunctionTests {
        
        @Test
        @DisplayName("Percentage calculation should work correctly")
        void testPercentage() {
            assertEquals(20.0, calculator.percentage(100.0, 20.0), 0.001);
            assertEquals(37.5, calculator.percentage(150.0, 25.0), 0.001);
            assertEquals(0.0, calculator.percentage(100.0, 0.0), 0.001);
        }
        
        @Test
        @DisplayName("Absolute value should work correctly")
        void testAbsolute() {
            assertEquals(5.0, calculator.absolute(5.0), 0.001);
            assertEquals(5.0, calculator.absolute(-5.0), 0.001);
            assertEquals(0.0, calculator.absolute(0.0), 0.001);
            assertEquals(3.14, calculator.absolute(-3.14), 0.001);
        }
        
        @Test
        @DisplayName("Rounding should work correctly")
        void testRound() {
            assertEquals(3.14, calculator.round(3.14159, 2), 0.001);
            assertEquals(3.1, calculator.round(3.14159, 1), 0.001);
            assertEquals(3.0, calculator.round(3.14159, 0), 0.001);
            assertEquals(123.46, calculator.round(123.456789, 2), 0.001);
        }
        
        @Test
        @DisplayName("Even number check should work correctly")
        void testIsEven() {
            assertTrue(calculator.isEven(2));
            assertTrue(calculator.isEven(0));
            assertTrue(calculator.isEven(-4));
            assertTrue(calculator.isEven(100));
            
            assertFalse(calculator.isEven(1));
            assertFalse(calculator.isEven(-3));
            assertFalse(calculator.isEven(99));
        }
        
        @Test
        @DisplayName("Prime number check should work correctly")
        void testIsPrime() {
            assertTrue(calculator.isPrime(2));
            assertTrue(calculator.isPrime(3));
            assertTrue(calculator.isPrime(5));
            assertTrue(calculator.isPrime(7));
            assertTrue(calculator.isPrime(11));
            assertTrue(calculator.isPrime(13));
            assertTrue(calculator.isPrime(17));
            assertTrue(calculator.isPrime(19));
            assertTrue(calculator.isPrime(23));
            
            assertFalse(calculator.isPrime(1));
            assertFalse(calculator.isPrime(4));
            assertFalse(calculator.isPrime(6));
            assertFalse(calculator.isPrime(8));
            assertFalse(calculator.isPrime(9));
            assertFalse(calculator.isPrime(10));
            assertFalse(calculator.isPrime(12));
            assertFalse(calculator.isPrime(15));
            assertFalse(calculator.isPrime(20));
            
            assertFalse(calculator.isPrime(0));
            assertFalse(calculator.isPrime(-5));
        }
    }
    
    @Nested
    @DisplayName("Edge Cases and Error Handling")
    class EdgeCaseTests {
        
        @Test
        @DisplayName("Large numbers should be handled correctly")
        void testLargeNumbers() {
            double large1 = 1_000_000.0;
            double large2 = 2_000_000.0;
            
            assertEquals(3_000_000.0, calculator.add(large1, large2), 0.001);
            assertEquals(2_000_000_000_000.0, calculator.multiply(large1, large2), 0.001);
        }
        
        @Test
        @DisplayName("Very small numbers should be handled correctly")
        void testSmallNumbers() {
            double small1 = 0.000001;
            double small2 = 0.000002;
            
            assertEquals(0.000003, calculator.add(small1, small2), 0.0000001);
            assertEquals(2.0E-12, calculator.multiply(small1, small2), 1.0E-13);
        }
        
        @Test
        @DisplayName("Infinity and NaN handling")
        void testSpecialValues() {
            double result = calculator.divide(Double.MAX_VALUE, 0.5);
            assertEquals(Double.POSITIVE_INFINITY, result);
            
            assertTrue(Double.isInfinite(calculator.multiply(Double.MAX_VALUE, 2.0)));
        }
    }
}
