package com.example.shyam.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.shyam.entity.productEntity;
import com.example.shyam.service.productService;

@RestController
public class productController {
	
	@Autowired
	productService service;

	@GetMapping("/product")
	public List<productEntity> getproducts(){
		return service.getProducts();
	}
	
	@PostMapping("/product")
	public String addProduct(@RequestBody productEntity product) {
		return service.addProduct(product);
	}
	
	@PutMapping("/product/{id}")
	public String editProduct(@PathVariable int id,@RequestBody productEntity product) {
		return service.editProduct(id,product);
	}
	
	@DeleteMapping("/product/{id}")
	public String deleteProduct(@PathVariable int id) {
		return service.deleteProduct(id);
	}
}
