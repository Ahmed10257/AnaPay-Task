import { Injectable, NotFoundException } from '@nestjs/common';
import { FieldValue } from 'firebase-admin/firestore';
import { firestore } from '../firebase.provider';
import { FirestoreUser } from '../interfaces/firestoreuser';

@Injectable()
export class FirestoreService {
  private usersCollection = firestore.collection('users');
  private notificationsLogsCollection =
    firestore.collection('notifications_logs');

  async getUserByUid(uid: string): Promise<FirestoreUser> {
    const docRef = this.usersCollection.doc(uid);
    const snap = await docRef.get();
    if (!snap.exists) throw new NotFoundException(`No user with uid ${uid}`);
    const data = snap.data() as Omit<FirestoreUser, 'id'> | undefined;
    if (!data) throw new NotFoundException(`No user data for uid ${uid}`);
    return { id: snap.id, ...data };
  }

  // helper to get FCM token(s) if you save them under a known field
  async getUserTokens(uid: string): Promise<string[]> {
    const user = await this.getUserByUid(uid);
    // adjust this depending on how you store tokens (single token or array)
    const tokens = user.fcmTokens ?? (user.fcmToken ? [user.fcmToken] : []);
    return tokens;
  }

  /**
   * Log notification delivery attempt to notifications_logs collection
   */
  async logNotification(
    uid: string,
    title: string,
    body: string,
    status: 'delivered' | 'failed',
    reason?: string,
    userEmail?: string,
  ): Promise<void> {
    try {
      await this.notificationsLogsCollection.add({
        receiver: uid,
        receiverEmail: userEmail || null,
        title,
        body,
        status,
        reason: reason || null,
        createdAt: FieldValue.serverTimestamp(),
      });
    } catch (error) {
      console.error('Error logging notification:', error);
      // Don't throw - logging failure shouldn't break notification sending
    }
  }
}
