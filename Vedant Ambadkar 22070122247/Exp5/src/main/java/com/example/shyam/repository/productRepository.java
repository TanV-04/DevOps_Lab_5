package com.example.shyam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.shyam.entity.productEntity;

public interface productRepository extends JpaRepository<productEntity,Integer> {

}
