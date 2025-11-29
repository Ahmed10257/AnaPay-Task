import { Component } from '@angular/core';
import { UsersService } from '../../Services/users/users';
import { NotificationsService } from '../../Services/notifications/notifications';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { LucideAngularModule } from 'lucide-angular';

@Component({
  selector: 'app-uid-check',
  imports: [CommonModule, ReactiveFormsModule, FormsModule, LucideAngularModule],
  templateUrl: './uid-check.html',
  styleUrl: './uid-check.css',
})
export class UidCheck {

  // Tab management
  activeTab: 'check' | 'notify' = 'check';

  // Check User Tab
  uid = '';
  userJson: any = null;
  checkMessage = '';

  // Send Notification Tab
  notificationUid = '';
  notificationTitle = 'Hello';
  notificationBody = 'Test notification';
  notifyMessage = '';

  constructor(private usersService: UsersService, private notificationsService: NotificationsService) {}

  // Switch tabs
  switchTab(tab: 'check' | 'notify') {
    this.activeTab = tab;
  }

  checkUser() {
    if (!this.uid.trim()) {
      this.checkMessage = 'Please enter a UID';
      return;
    }

    this.checkMessage = 'Searching...';
    this.usersService.getUser(this.uid).subscribe(
      (user) => {
        this.userJson = this.parseFirestoreUser(user);
        this.checkMessage = 'User found ✅';
      },
      (error) => {
        this.userJson = null;
        this.checkMessage = 'User not found ❌';
      }
    );
  }

  sendNotification() {
    if (!this.notificationUid.trim()) {
      this.notifyMessage = 'Please enter a UID first';
      return;
    }
    if (!this.notificationTitle.trim()) {
      this.notifyMessage = 'Please enter a notification title';
      return;
    }
    if (!this.notificationBody.trim()) {
      this.notifyMessage = 'Please enter a notification message';
      return;
    }

    this.notifyMessage = 'Sending...';
    this.notificationsService.sendNotification(
      this.notificationUid,
      this.notificationTitle,
      this.notificationBody
    ).subscribe({
      next: res => {
        this.notifyMessage = 'Notification sent successfully ✅';
        console.log(res);
      },
      error: err => {
        this.notifyMessage = `Failed: ${err?.message || err.status}`;
      }
    });
  }

  private parseFirestoreUser(user: any): any {
    // Convert Firestore Timestamp to Date
    if (user.createdAt && user.createdAt._seconds) {
      user.createdAt = new Date(user.createdAt._seconds * 1000);
    }
    if (user.updatedAt && user.updatedAt._seconds) {
      user.updatedAt = new Date(user.updatedAt._seconds * 1000);
    }
    return user;
  }
}