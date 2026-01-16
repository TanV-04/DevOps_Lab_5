package com.devops.jenkins;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

/**
 * Comprehensive test suite for MathUtility class
 * These tests will be executed on the test-node in Jenkins pipeline
 */
@DisplayName("MathUtility Tests")
class MathUtilityTest {
    
    private MathUtility mathUtility;
    
    @BeforeEach
    void setUp() {
        mathUtility = new MathUtility();
        System.out.println("Setting up MathUtility test - Running on Jenkins test-node");
    }
    
    @Nested
    @DisplayName("Power and Root Operations")
    class PowerAndRootTests {
        
        @Test
        @DisplayName("Power calculation should work correctly")
        void testPower() {
            assertEquals(8.0, mathUtility.power(2.0, 3.0), 0.001);
            assertEquals(25.0, mathUtility.power(5.0, 2.0), 0.001);
            assertEquals(1.0, mathUtility.power(5.0, 0.0), 0.001);
            assertEquals(0.25, mathUtility.power(2.0, -2.0), 0.001);
            assertEquals(1.414, mathUtility.power(2.0, 0.5), 0.001);
        }
        
        @Test
        @DisplayName("Square root should work correctly")
        void testSquareRoot() {
            assertEquals(3.0, mathUtility.squareRoot(9.0), 0.001);
            assertEquals(5.0, mathUtility.squareRoot(25.0), 0.001);
            assertEquals(0.0, mathUtility.squareRoot(0.0), 0.001);
            assertEquals(1.414, mathUtility.squareRoot(2.0), 0.001);
            assertEquals(10.0, mathUtility.squareRoot(100.0), 0.001);
        }
        
        @Test
        @DisplayName("Square root of negative number should throw exception")
        void testSquareRootNegative() {
            IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> mathUtility.squareRoot(-1.0)
            );
            assertEquals("Cannot calculate square root of negative number", exception.getMessage());
        }
    }
    
    @Nested
    @DisplayName("Factorial and Fibonacci")
    class SequenceTests {
        
        @Test
        @DisplayName("Factorial should work correctly")
        void testFactorial() {
            assertEquals(1, mathUtility.factorial(0));
            assertEquals(1, mathUtility.factorial(1));
            assertEquals(2, mathUtility.factorial(2));
            assertEquals(6, mathUtility.factorial(3));
            assertEquals(24, mathUtility.factorial(4));
            assertEquals(120, mathUtility.factorial(5));
            assertEquals(720, mathUtility.factorial(6));
            assertEquals(5040, mathUtility.factorial(7));
        }
        
        @Test
        @DisplayName("Factorial of negative number should throw exception")
        void testFactorialNegative() {
            IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> mathUtility.factorial(-1)
            );
            assertEquals("Factorial is not defined for negative numbers", exception.getMessage());
        }
        
        @Test
        @DisplayName("Fibonacci should work correctly")
        void testFibonacci() {
            assertEquals(0, mathUtility.fibonacci(0));
            assertEquals(1, mathUtility.fibonacci(1));
            assertEquals(1, mathUtility.fibonacci(2));
            assertEquals(2, mathUtility.fibonacci(3));
            assertEquals(3, mathUtility.fibonacci(4));
            assertEquals(5, mathUtility.fibonacci(5));
            assertEquals(8, mathUtility.fibonacci(6));
            assertEquals(13, mathUtility.fibonacci(7));
            assertEquals(21, mathUtility.fibonacci(8));
            assertEquals(55, mathUtility.fibonacci(10));
        }
        
        @Test
        @DisplayName("Fibonacci of negative number should throw exception")
        void testFibonacciNegative() {
            IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> mathUtility.fibonacci(-1)
            );
            assertEquals("Fibonacci is not defined for negative numbers", exception.getMessage());
        }
    }
    
    @Nested
    @DisplayName("GCD and LCM Operations")
    class GcdLcmTests {
        
        @Test
        @DisplayName("GCD should work correctly")
        void testGcd() {
            assertEquals(5, mathUtility.gcd(15, 10));
            assertEquals(6, mathUtility.gcd(12, 18));
            assertEquals(1, mathUtility.gcd(17, 19));
            assertEquals(7, mathUtility.gcd(21, 14));
            assertEquals(12, mathUtility.gcd(48, 36));
            
            assertEquals(5, mathUtility.gcd(-15, 10));
            assertEquals(5, mathUtility.gcd(15, -10));
            assertEquals(5, mathUtility.gcd(-15, -10));
        }
        
        @Test
        @DisplayName("LCM should work correctly")
        void testLcm() {
            assertEquals(30, mathUtility.lcm(15, 10));
            assertEquals(36, mathUtility.lcm(12, 18));
            assertEquals(323, mathUtility.lcm(17, 19));
            assertEquals(42, mathUtility.lcm(21, 14));
            assertEquals(144, mathUtility.lcm(48, 36));
            
            assertEquals(0, mathUtility.lcm(0, 5));
            assertEquals(0, mathUtility.lcm(5, 0));
        }
    }
    
    @Nested
    @DisplayName("Prime Number Generation")
    class PrimeGenerationTests {
        
        @Test
        @DisplayName("Prime generation should work correctly")
        void testGeneratePrimes() {
            List<Integer> primes = mathUtility.generatePrimes(10);
            assertEquals(List.of(2, 3, 5, 7), primes);
            
            primes = mathUtility.generatePrimes(20);
            assertEquals(List.of(2, 3, 5, 7, 11, 13, 17, 19), primes);
            
            primes = mathUtility.generatePrimes(1);
            assertTrue(primes.isEmpty());
            
            primes = mathUtility.generatePrimes(2);
            assertEquals(List.of(2), primes);
        }
    }
    
    @Nested
    @DisplayName("Array Operations")
    class ArrayOperationTests {
        
        @Test
        @DisplayName("Average calculation should work correctly")
        void testAverage() {
            double[] numbers1 = {1.0, 2.0, 3.0, 4.0, 5.0};
            assertEquals(3.0, mathUtility.average(numbers1), 0.001);
            
            double[] numbers2 = {10.0, 20.0, 30.0};
            assertEquals(20.0, mathUtility.average(numbers2), 0.001);
            
            double[] numbers3 = {-1.0, 0.0, 1.0};
            assertEquals(0.0, mathUtility.average(numbers3), 0.001);
            
            double[] numbers4 = {2.5, 3.5, 4.5};
            assertEquals(3.5, mathUtility.average(numbers4), 0.001);
        }
        
        @Test
        @DisplayName("Average with null or empty array should throw exception")
        void testAverageEdgeCases() {
            assertThrows(IllegalArgumentException.class, () -> mathUtility.average(null));
            assertThrows(IllegalArgumentException.class, () -> mathUtility.average(new double[]{}));
        }
        
        @Test
        @DisplayName("Maximum value finding should work correctly")
        void testMax() {
            double[] numbers1 = {1.0, 5.0, 3.0, 9.0, 2.0};
            assertEquals(9.0, mathUtility.max(numbers1), 0.001);
            
            double[] numbers2 = {-10.0, -5.0, -15.0, -2.0};
            assertEquals(-2.0, mathUtility.max(numbers2), 0.001);
            
            double[] numbers3 = {7.5};
            assertEquals(7.5, mathUtility.max(numbers3), 0.001);
            
            double[] numbers4 = {-1.0, 0.0, 1.0};
            assertEquals(1.0, mathUtility.max(numbers4), 0.001);
        }
        
        @Test
        @DisplayName("Max with null or empty array should throw exception")
        void testMaxEdgeCases() {
            assertThrows(IllegalArgumentException.class, () -> mathUtility.max(null));
            assertThrows(IllegalArgumentException.class, () -> mathUtility.max(new double[]{}));
        }
        
        @Test
        @DisplayName("Minimum value finding should work correctly")
        void testMin() {
            double[] numbers1 = {1.0, 5.0, 3.0, 9.0, 2.0};
            assertEquals(1.0, mathUtility.min(numbers1), 0.001);
            
            double[] numbers2 = {-10.0, -5.0, -15.0, -2.0};
            assertEquals(-15.0, mathUtility.min(numbers2), 0.001);
            
            double[] numbers3 = {7.5};
            assertEquals(7.5, mathUtility.min(numbers3), 0.001);
            
            double[] numbers4 = {-1.0, 0.0, 1.0};
            assertEquals(-1.0, mathUtility.min(numbers4), 0.001);
        }
        
        @Test
        @DisplayName("Min with null or empty array should throw exception")
        void testMinEdgeCases() {
            assertThrows(IllegalArgumentException.class, () -> mathUtility.min(null));
            assertThrows(IllegalArgumentException.class, () -> mathUtility.min(new double[]{}));
        }
    }
    
    @Nested
    @DisplayName("Performance and Large Data Tests")
    class PerformanceTests {
        
        @Test
        @DisplayName("Large factorial should work within reasonable time")
        void testLargeFactorial() {
            long start = System.currentTimeMillis();
            long result = mathUtility.factorial(20);
            long end = System.currentTimeMillis();
            
            assertEquals(2432902008176640000L, result);
            assertTrue(end - start < 100, "Factorial calculation took too long");
        }
        
        @Test
        @DisplayName("Large Fibonacci should work efficiently")
        void testLargeFibonacci() {
            long start = System.currentTimeMillis();
            long result = mathUtility.fibonacci(30);
            long end = System.currentTimeMillis();
            
            assertEquals(832040, result);
            assertTrue(end - start < 50, "Fibonacci calculation took too long");
        }
        
        @Test
        @DisplayName("Prime generation for large numbers should work efficiently")
        void testLargePrimeGeneration() {
            long start = System.currentTimeMillis();
            List<Integer> primes = mathUtility.generatePrimes(1000);
            long end = System.currentTimeMillis();
            
            assertEquals(168, primes.size());
            assertTrue(primes.contains(997));
            assertTrue(end - start < 200, "Prime generation took too long");
        }
    }
}
