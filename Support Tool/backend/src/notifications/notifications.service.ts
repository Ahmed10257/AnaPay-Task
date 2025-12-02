import { Injectable } from '@nestjs/common';
import { messaging } from '../firebase.provider';
import { FirestoreService } from '../firestore/firestore.service';
import * as admin from 'firebase-admin';

@Injectable()
export class NotificationsService {
  constructor(private readonly firestoreService: FirestoreService) {}

  async sendNotificationToUid(
    uid: string,
    title: string,
    body: string,
    data?: Record<string, string>,
  ) {
    try {
      // Check if user exists and get their data
      const userData = await this.firestoreService.getUserByUid(uid);

      // Check login status
      if (!userData.isLoggedIn) {
        return {
          success: false,
          delivered: false,
          reason: 'user_not_logged_in',
          message: 'User is not currently logged in',
          userEmail: userData.email as string,
        };
      }

      const tokens = await this.firestoreService.getUserTokens(uid);
      if (!tokens || tokens.length === 0) {
        return {
          success: false,
          delivered: false,
          reason: 'no_tokens',
          message: 'No FCM tokens found for user',
        };
      }

      const message: admin.messaging.MulticastMessage = {
        notification: { title, body },
        tokens,
        data: data || {},
      };

      const response = await messaging.sendEachForMulticast(message);
      console.log(
        `Notification sent to UID ${uid}: ${response.successCount} successful, ${response.failureCount} failed.`,
      );
      return {
        success: response.successCount > 0,
        delivered: response.successCount > 0,
        successCount: response.successCount,
        failureCount: response.failureCount,
        responses: response.responses.map((r) =>
          r.success
            ? { success: true }
            : { success: false, error: r.error?.message },
        ),
      };
    } catch (error) {
      console.error('Error sending notification:', error);
      return {
        success: false,
        delivered: false,
        reason: 'error',
        message:
          error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
