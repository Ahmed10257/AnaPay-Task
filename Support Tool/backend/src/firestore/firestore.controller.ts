import { Controller, Get, Param } from '@nestjs/common';
import { FirestoreService } from './firestore.service';

@Controller('firestore')
export class FirestoreController {
  constructor(private readonly firestoreService: FirestoreService) {}

  @Get('user/:uid')
  async getUser(@Param('uid') uid: string) {
    return this.firestoreService.getUserByUid(uid);
  }
}
