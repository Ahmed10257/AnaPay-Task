import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { LucideAngularModule } from 'lucide-angular';

interface CLIOutput {
  command: string;
  timestamp: Date;
  output: string;
  type: 'success' | 'error' | 'info';
}

@Component({
  selector: 'app-cli-interface',
  standalone: true,
  imports: [CommonModule, FormsModule, LucideAngularModule],
  templateUrl: './cli-interface.html',
  styleUrls: ['./cli-interface.css'],
})
export class CLIInterfaceComponent implements OnInit {
  commandInput: string = '';
  commandHistory: CLIOutput[] = [];
  isLoading: boolean = false;

  private apiBaseUrl = 'http://localhost:3000';

  ngOnInit() {
    this.printWelcome();
  }

  private printWelcome() {
    const welcome: CLIOutput = {
      command: '',
      timestamp: new Date(),
      output: `
╔════════════════════════════════════════════════════╗
║         AnaPay Support Tool - CLI Interface        ║
╚════════════════════════════════════════════════════╝

Available Commands:
  • check <user_id>              - Get user info & FCM token
  • push <user_id> --message "..." - Send test notification

Examples:
  check user123abc
  push user123abc --message "Notification Title|This is the body of the notification."

Type 'help' for more information.
      `,
      type: 'info',
    };
    this.commandHistory.push(welcome);
    this.scrollToBottom();
  }

  executeCommand() {
    if (!this.commandInput.trim()) {
      return;
    }

    const userCommand = this.commandInput.trim();
    this.printCommand(userCommand);
    this.commandInput = '';

    const parts = userCommand.split(/\s+/);
    const command = parts[0].toLowerCase();

    this.isLoading = true;

    switch (command) {
      case 'check':
        this.handleCheck(parts);
        break;
      case 'push':
        this.handlePush(userCommand, parts);
        break;
      case 'help':
        this.handleHelp();
        break;
      case 'clear':
        this.commandHistory = [];
        this.printWelcome();
        this.isLoading = false;
        break;
      default:
        this.printError(`Unknown command: '${command}'. Type 'help' for available commands.`);
        this.isLoading = false;
    }
  }

  private handleCheck(parts: string[]) {
    if (parts.length < 2) {
      this.printError('Usage: check <user_id>');
      this.isLoading = false;
      return;
    }

    const userId = parts[1];
    this.printInfo(`Fetching user data for: ${userId}...`);

    // Call backend to fetch user
    fetch(`${this.apiBaseUrl}/firestore/user/${userId}`)
      .then((res) => res.json())
      .then((data) => {
        if (data.error) {
          this.printError(`Error: ${data.error}`);
        } else {
          // Parse Firestore timestamps (they have _seconds property)
          const parseFirestoreDate = (timestamp: any) => {
            if (!timestamp) return 'N/A';
            if (timestamp._seconds) {
              return new Date(timestamp._seconds * 1000).toLocaleString();
            }
            return new Date(timestamp).toLocaleString();
          };

          const loginStatus = data.isLoggedIn
            ? '🟢 Logged In'
            : '🔴 Logged Out';
          const output = `
User Information:
─────────────────────────────────────────────────
UID:                  ${data.uid || 'N/A'}
Email:                ${data.email || 'N/A'}
Display Name:         ${data.displayName || 'N/A'}
Phone:                ${data.phoneNumber || 'N/A'}
─────────────────────────────────────────────────
Login Status:         ${loginStatus}
─────────────────────────────────────────────────
Created:              ${parseFirestoreDate(data.createdAt)}
Last Active:          ${parseFirestoreDate(data.updatedAt)}
─────────────────────────────────────────────────
FCM Token:            ${data.fcmToken ? '✓ Present' : '✗ Not found'}
Token Updated:        ${parseFirestoreDate(data.fcmTokenUpdatedAt)}
─────────────────────────────────────────────────
${
  data.fcmToken
    ? `Token (truncated): ${data.fcmToken.substring(0, 50)}...`
    : 'No FCM token available'
}`;
          this.printSuccess(output);
        }
        this.isLoading = false;
        this.scrollToBottom();
      })
      .catch((err) => {
        this.printError(`Connection error: ${err.message}`);
        this.isLoading = false;
        this.scrollToBottom();
      });
  }

  private handlePush(userCommand: string, parts: string[]) {
    if (parts.length < 2) {
      this.printError('Usage: push <user_id> --message "your message"');
      this.isLoading = false;
      return;
    }

    const userId = parts[1];

    // Parse message from command
    const messageMatch = userCommand.match(/--message\s+"([^"]+)"/);
    if (!messageMatch) {
      this.printError(
        'Missing --message parameter. Usage: push <user_id> --message "your message"'
      );
      this.isLoading = false;
      return;
    }

    const message = messageMatch[1];
    console.log(messageMatch);
    console.log(message);
    this.printInfo(`Sending notification to user: ${userId}...`);

    // Extract title and body from message (or use defaults)
    const messageParts = message.split('|');
    console.log(messageParts);
    const title = messageParts[0] || 'Test Notification';
    const body = messageParts[1] || message;

    // Call backend to send notification
    fetch(`${this.apiBaseUrl}/notifications/send`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        uid: userId,
        title: title,
        body: body,
      }),
    })
      .then((res) => res.json())
      .then((data) => {
        // Check if notification was actually delivered
        if (data.delivered) {
          const successOutput = `
FCM Notification Delivery Status:
─────────────────────────────────────────────────
Status:           ✅ DELIVERED
User ID:          ${userId}
Title:            ${title}
Body:             ${body}
Success Count:    ${data.successCount || 'N/A'}
Failure Count:    ${data.failureCount || 'N/A'}
Timestamp:        ${new Date().toLocaleString()}
─────────────────────────────────────────────────`;
          console.log(data);
          this.printSuccess(successOutput);
        } else {
          // Notification was not delivered
          const reason = data.reason || 'unknown';
          const message = data.message || 'Failed to deliver notification';
          const errorOutput = `
FCM Notification Delivery Status:
─────────────────────────────────────────────────
Status:           ❌ NOT DELIVERED
User ID:          ${userId}
Reason:           ${reason}
Message:          ${message}
Timestamp:        ${new Date().toLocaleString()}
─────────────────────────────────────────────────
User Email:       ${data.userEmail || 'N/A'}
─────────────────────────────────────────────────`;
          console.log(data);
          this.printError(errorOutput);
        }
        this.isLoading = false;
        this.scrollToBottom();
      })
      .catch((err) => {
        this.printError(`Connection error: ${err.message}`);
        this.isLoading = false;
        this.scrollToBottom();
      });
  }

  private handleHelp() {
    const helpText = `
Available Commands:
───────────────────────────────────────────────────

check <user_id>
  Description: Retrieve user information and FCM token from Firestore
  Output:      User profile, FCM token status, and metadata
  Example:     check user123abc

push <user_id> --message "title|body"
  Description: Send a test push notification using Firebase Admin SDK
  Output:      JSON response from FCM API (success/error)
  Example:     push user123abc --message "Payment Received|Your payment of $100 was received"
  Note:        Use pipe (|) to separate title and body. If only one value, it's used as body.

help
  Description: Show this help message

clear
  Description: Clear all terminal output

───────────────────────────────────────────────────`;
    this.printSuccess(helpText);
    this.isLoading = false;
  }

  private printCommand(command: string) {
    const output: CLIOutput = {
      command: command,
      timestamp: new Date(),
      output: `$ ${command}`,
      type: 'info',
    };
    this.commandHistory.push(output);
    this.scrollToBottom();
  }

  private printSuccess(message: string) {
    const output: CLIOutput = {
      command: '',
      timestamp: new Date(),
      output: message,
      type: 'success',
    };
    this.commandHistory.push(output);
    this.scrollToBottom();
  }

  private printError(message: string) {
    const output: CLIOutput = {
      command: '',
      timestamp: new Date(),
      output: message,
      type: 'error',
    };
    this.commandHistory.push(output);
    this.scrollToBottom();
  }

  private printInfo(message: string) {
    const output: CLIOutput = {
      command: '',
      timestamp: new Date(),
      output: message,
      type: 'info',
    };
    this.commandHistory.push(output);
    this.scrollToBottom();
  }

  private scrollToBottom() {
    setTimeout(() => {
      const terminal = document.querySelector('.cli-terminal');
      if (terminal) {
        terminal.scrollTop = terminal.scrollHeight;
      }
    }, 0);
  }

  // Allow Enter key to execute command
  onKeyDown(event: KeyboardEvent) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      this.executeCommand();
    }
  }
}
