package com.example.shyam.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.shyam.service.messageService;
import com.example.shyam.service.shyamService;

@RestController
@RequestMapping("/api")
public class restController {
	 
	@Autowired
	messageService msgService;
	
	@Autowired
	shyamService service;
	
	@GetMapping("/")
	public String hello() {
		return msgService.sendMessage();
	}
	
	@GetMapping("/products")
	public List<String> getProducts(){
		return service.getProducts();
	}
	
	@PostMapping("/products")
	public String addProduct(@RequestBody String product) {
		return service.addProducts(product);
	}
	
}
