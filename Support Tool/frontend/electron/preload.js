// Security: Expose only necessary APIs through contextBridge
const { contextBridge, ipcRenderer } = require('electron');

// Expose Electron APIs safely to the renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // App information
  getAppVersion: () => ipcRenderer.invoke('app-version'),
  
  // User operations (if you need IPC-based communication)
  checkUser: (uid) => ipcRenderer.invoke('check-user', uid),
  sendNotification: (uid) => ipcRenderer.invoke('send-notification', uid),
  
  // Window controls
  minimize: () => ipcRenderer.send('window-minimize'),
  maximize: () => ipcRenderer.send('window-maximize'),
  close: () => ipcRenderer.send('window-close'),
});

// Log that preload script is loaded
console.log('Electron preload script loaded successfully');

