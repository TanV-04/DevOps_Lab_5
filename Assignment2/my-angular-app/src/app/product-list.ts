import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

interface Product {
  id: number;
  name: string;
  price: number;
  category: string;
}

@Component({
  selector: 'app-product-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './product-list.html',
  styleUrl: './product-list.css'
})
export class ProductList {
  products = signal<Product[]>([
    { id: 1, name: 'Laptop', price: 1200, category: 'Electronics' },
    { id: 2, name: 'Mouse', price: 25, category: 'Electronics' },
    { id: 3, name: 'Keyboard', price: 75, category: 'Electronics' },
    { id: 4, name: 'Book', price: 15, category: 'Education' },
    { id: 5, name: 'Headphones', price: 100, category: 'Electronics' }
  ]);

  totalProducts = signal(this.products().length);
  totalValue = signal(this.products().reduce((sum, p) => sum + p.price, 0));

  addProduct() {
    const newProduct: Product = {
      id: this.products().length + 1,
      name: 'New Product',
      price: 50,
      category: 'General'
    };
    this.products.update(products => [...products, newProduct]);
    this.totalProducts.update(count => count + 1);
    this.totalValue.update(value => value + newProduct.price);
  }

  removeProduct(id: number) {
    const productToRemove = this.products().find(p => p.id === id);
    if (productToRemove) {
      this.products.update(products => products.filter(p => p.id !== id));
      this.totalProducts.update(count => count - 1);
      this.totalValue.update(value => value - productToRemove.price);
    }
  }
}
