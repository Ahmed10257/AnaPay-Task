import { Controller } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { Post, Body } from '@nestjs/common';

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Post('send')
  async sendNotification(
    @Body()
    body: {
      uid: string;
      title: string;
      body: string;
      data?: Record<string, string>;
    },
  ) {
    return await this.notificationsService.sendNotificationToUid(
      body.uid,
      body.title,
      body.body,
      body.data,
    );
  }
}
