import { Component, signal, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { ApiService, User, ApiResponse } from './api.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule, HttpClientModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit {
  protected readonly title = signal('Angular Docker Demo');
  protected users = signal<User[]>([]);
  protected healthStatus = signal<ApiResponse | null>(null);
  protected loading = signal(false);

  constructor(private apiService: ApiService) {}

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.loading.set(true);
    
    // Load users
    this.apiService.getUsers().subscribe(users => {
      this.users.set(users);
    });

    // Load health status
    this.apiService.getHealthCheck().subscribe(health => {
      this.healthStatus.set(health);
      this.loading.set(false);
    });
  }

  createSampleUser() {
    const newUser = {
      name: 'Sample User',
      email: 'sample@example.com',
      city: 'Sample City'
    };

    this.apiService.createUser(newUser).subscribe(user => {
      const currentUsers = this.users();
      this.users.set([...currentUsers, user]);
    });
  }
}
