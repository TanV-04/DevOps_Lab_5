package main.java.com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello I am tijil and this is Java Spring Boot Application!";
    }

    @GetMapping("/api/health")
    public String health() {
        return "Application is running successfully!";
    }
}
