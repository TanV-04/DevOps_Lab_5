package com.retail.app.controller;
import com.retail.app.model.Product;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/products")
public class ProductController {
    private List<Product> productList = new ArrayList<>(
            Arrays.asList(
                    new Product("1", "Shirt", 499.99),
                    new Product("2", "Shoes", 999.50),
                    new Product("3", "Watch", 1999.00)
            )
    );

    @GetMapping
    public List<Product> getAllProducts() {
        return productList;
    }

    @GetMapping("/{id}")
    public Product getProductById(@PathVariable String id) {
        return productList.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @PostMapping
    public Product addProduct(@RequestBody Product product) {
        productList.add(product);
        return product;
    }
}
