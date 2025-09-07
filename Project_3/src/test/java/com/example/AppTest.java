package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void greetReturnsExpectedMessage() {
        assertEquals("Hello, World!", App.greet("World"));
    }
}

