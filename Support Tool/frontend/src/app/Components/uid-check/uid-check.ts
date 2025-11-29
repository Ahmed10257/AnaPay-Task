import { Component } from '@angular/core';
import { UsersService } from '../../Services/users/users';
import { NotificationsService } from '../../Services/notifications/notifications';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-uid-check',
  imports: [CommonModule,ReactiveFormsModule, FormsModule],
  templateUrl: './uid-check.html',
  styleUrl: './uid-check.css',
})
export class UidCheck {

  uid = '';
  userJson: any = null;
  message = '';

  constructor(private usersService: UsersService, private notificationsService: NotificationsService) {}

  checkUser() {
    this.usersService.getUser(this.uid).subscribe(
      (user) => {
        this.userJson = user;
        this.message = 'User found';
      },
      (error) => {
        this.userJson = null;
        this.message = 'User not found';
      }
    );
  }

  sendNotification() {
    this.message = 'Sending...';
    this.notificationsService.sendNotification(this.uid, 'Hello', 'Test notification').subscribe({
      next: res => { this.message = 'Notification attempt finished'; console.log(res); },
      error: err => { this.message = `Failed: ${err?.message || err.status}`; }
    });
  }
}