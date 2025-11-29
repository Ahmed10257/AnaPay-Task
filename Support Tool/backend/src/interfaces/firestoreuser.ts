export interface FirestoreUser {
  id: string;
  fcmTokens?: string[];
  fcmToken?: string;
  [key: string]: any;
}
