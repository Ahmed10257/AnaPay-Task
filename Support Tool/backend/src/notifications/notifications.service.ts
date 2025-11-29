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
    const tokens = await this.firestoreService.getUserTokens(uid);
    if (!tokens || tokens.length === 0) {
      return { success: false, reason: 'no_tokens' };
    }

    const message: admin.messaging.MulticastMessage = {
      notification: { title, body },
      tokens,
      data: data || {},
    };

    const response = await messaging.sendEachForMulticast(message);
    // response.successCount, response.failureCount, response.responses array
    console.log(
      `Notification sent to UID ${uid}: ${response.successCount} successful, ${response.failureCount} failed.`,
    );
    return {
      success: response.successCount > 0,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses.map((r) =>
        r.success
          ? { success: true }
          : { success: false, error: r.error?.message },
      ),
    };
  }
}
