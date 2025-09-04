package com.retail_app.config;

import com.retail_app.entity.Product;
import com.retail_app.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataLoader implements CommandLineRunner {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Override
    public void run(String... args) throws Exception {
        if (productRepository.count() == 0) {
            productRepository.save(new Product("Laptop", "Electronics", 999.99, "High-performance laptop"));
            productRepository.save(new Product("Smartphone", "Electronics", 699.99, "Latest smartphone"));
            productRepository.save(new Product("T-Shirt", "Clothing", 29.99, "Cotton t-shirt"));
            productRepository.save(new Product("Jeans", "Clothing", 79.99, "Denim jeans"));
            productRepository.save(new Product("Coffee Maker", "Home", 149.99, "Automatic coffee maker"));
        }
    }
}