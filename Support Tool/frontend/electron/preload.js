// This is required later if you want NestJS communication through IPC
const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  checkUser: (uid) => ipcRenderer.invoke('check-user', uid),
  sendNotification: (uid) => ipcRenderer.invoke('send-notification', uid),
});
