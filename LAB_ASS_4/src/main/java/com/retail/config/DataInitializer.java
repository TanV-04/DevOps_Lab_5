package com.retail.config;

import com.retail.model.Product;
import com.retail.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Override
    public void run(String... args) throws Exception {
        // Initialize with sample data
        if (productRepository.count() == 0) {
            productRepository.save(new Product("Laptop", "High-performance laptop for work and gaming", 999.99, 10, "Electronics"));
            productRepository.save(new Product("Smartphone", "Latest model smartphone with advanced features", 699.99, 25, "Electronics"));
            productRepository.save(new Product("T-Shirt", "Comfortable cotton t-shirt", 19.99, 50, "Clothing"));
            productRepository.save(new Product("Jeans", "Premium denim jeans", 79.99, 30, "Clothing"));
            productRepository.save(new Product("Coffee Maker", "Automatic coffee maker with timer", 129.99, 15, "Home & Kitchen"));
            productRepository.save(new Product("Running Shoes", "Professional running shoes", 89.99, 40, "Sports"));
            productRepository.save(new Product("Desk Chair", "Ergonomic office chair", 199.99, 8, "Furniture"));
            productRepository.save(new Product("Water Bottle", "Stainless steel water bottle", 24.99, 100, "Sports"));
            productRepository.save(new Product("Headphones", "Wireless noise-canceling headphones", 199.99, 20, "Electronics"));
            productRepository.save(new Product("Book", "Programming best practices guide", 39.99, 60, "Books"));
        }
    }
}