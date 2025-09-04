import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';

export interface User {
  id: number;
  name: string;
  email: string;
  city: string;
}

export interface ApiResponse {
  message: string;
  timestamp: string;
  data?: any;
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = '/api';

  constructor(private http: HttpClient) {}

  // Mock API endpoints
  getUsers(): Observable<User[]> {
    const mockUsers: User[] = [
      { id: 1, name: 'John Doe', email: 'john@example.com', city: 'New York' },
      { id: 2, name: 'Jane Smith', email: 'jane@example.com', city: 'Los Angeles' },
      { id: 3, name: 'Bob Johnson', email: 'bob@example.com', city: 'Chicago' }
    ];
    return of(mockUsers);
  }

  getUser(id: number): Observable<User | null> {
    const mockUsers: User[] = [
      { id: 1, name: 'John Doe', email: 'john@example.com', city: 'New York' },
      { id: 2, name: 'Jane Smith', email: 'jane@example.com', city: 'Los Angeles' },
      { id: 3, name: 'Bob Johnson', email: 'bob@example.com', city: 'Chicago' }
    ];
    const user = mockUsers.find(u => u.id === id) || null;
    return of(user);
  }

  getHealthCheck(): Observable<ApiResponse> {
    const response: ApiResponse = {
      message: 'API is running successfully!',
      timestamp: new Date().toISOString(),
      data: {
        version: '1.0.0',
        status: 'healthy',
        uptime: Math.floor(Math.random() * 1000) + 'ms'
      }
    };
    return of(response);
  }

  createUser(user: Omit<User, 'id'>): Observable<User> {
    const newUser: User = {
      ...user,
      id: Math.floor(Math.random() * 1000) + 100
    };
    return of(newUser);
  }
}