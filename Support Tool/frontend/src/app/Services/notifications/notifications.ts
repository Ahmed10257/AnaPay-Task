import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class NotificationsService {
  private readonly apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  sendNotification(uid: string, title: string, body: string, data?: Record<string, string>) {
    return this.http.post(`${this.apiUrl}/notifications/send`, {
      uid,
      title,
      body,
      data,
    });
  }
}
