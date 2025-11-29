import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { FirestoreModule } from './firestore/firestore.module';
import { NotificationsModule } from './notifications/notifications.module';

@Module({
  imports: [FirestoreModule, NotificationsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
