package com.company.simple_app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SimpleAppApplication {

    @GetMapping("/")
    public String hello() {
        return "Hello from Dockerized Spring Boot App! - Version 1.0";
    }

    @GetMapping("/health")
    public String health() {
        return "Application is running healthy!";
    }

    public static void main(String[] args) {
        SpringApplication.run(SimpleAppApplication.class, args);
    }
}
