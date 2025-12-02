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
        // Log failed notification - user not logged in
        await this.firestoreService.logNotification(
          uid,
          title,
          body,
          'failed',
          'user_not_logged_in',
          userData.email as string,
        );

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
        // Log failed notification - no tokens
        await this.firestoreService.logNotification(
          uid,
          title,
          body,
          'failed',
          'no_fcm_token',
          userData.email as string,
        );

        return {
          success: false,
          delivered: false,
          reason: 'no_fcm_token',
          message:
            'User has no FCM token - ensure the app is installed and notification permission is granted',
          userEmail: userData.email as string,
        };
      }

      const message: admin.messaging.MulticastMessage = {
        notification: { title, body },
        tokens,
        data: data || {},
      };

      const response = await messaging.sendEachForMulticast(message);
      const wasDelivered = response.successCount > 0;

      // Log notification attempt
      await this.firestoreService.logNotification(
        uid,
        title,
        body,
        wasDelivered ? 'delivered' : 'failed',
        wasDelivered ? undefined : `${response.failureCount} token(s) failed`,
        userData.email as string,
      );

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
    } catch (error: unknown) {
      // Log failed notification - error occurred
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error occurred';
      await this.firestoreService.logNotification(
        uid,
        title,
        body,
        'failed',
        errorMessage,
      );

      console.error('Error sending notification:', error);
      return {
        success: false,
        delivered: false,
        reason: 'error',
        message: errorMessage,
      };
    }
  }
}
