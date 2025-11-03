package com.example.shyam.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.shyam.entity.productEntity;
import com.example.shyam.repository.productRepository;

@Service
public class productService {
	
	@Autowired
	productRepository repo;
	
	public List<productEntity> getProducts(){
		return repo.findAll();
	}
	
	public String addProduct(productEntity product) {
		repo.save(product);
		return "Added successfully";
	}
	

	public String editProduct(int id, productEntity updatedProduct) {
		if(repo.findById(id).isEmpty()) {
			return "Product is not available";
		}else {
			productEntity p =repo.findById(id).get();
			p.setName(updatedProduct.getName());
			p.setPrice(updatedProduct.getPrice());
			p.setCatgory(updatedProduct.getCatgory());
			repo.save(p);
			return "Product Upadated Successfully";
		}
	}
	
	public String deleteProduct(int id) {
		if(repo.findById(id).isEmpty()) {
			return "Product is not available";
		}else {
			productEntity p = repo.findById(id).get();
			repo.delete(p);
			return "Product Deleted Successfully";
		}
	}

}
 