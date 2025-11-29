importScripts(
  "https://www.gstatic.com/firebasejs/10.5.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.5.0/firebase-messaging-compat.js"
);

// Initialize Firebase in the service worker
firebase.initializeApp({
  apiKey: "AIzaSyD0FIWi9eJ_f1ebCUDI8zC-xt2nCRJvetk",
  appId: "1:543139785376:web:d3e912d4896bf0ebd9f7c5",
  messagingSenderId: "543139785376",
  projectId: "anapay-task",
  authDomain: "anapay-task.firebaseapp.com",
  storageBucket: "anapay-task.firebasestorage.app",
  measurementId: "G-HXKBNY2K0Z",
});

const messaging = firebase.messaging();

// 🔔 Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log("🔔 SERVICE WORKER: Background message received", payload);
  
  try {
    const notificationTitle = payload.notification?.title || "Notification";
    const notificationBody = payload.notification?.body || "You have a new message";
    
    console.log("🔔 SERVICE WORKER: Title:", notificationTitle);
    console.log("🔔 SERVICE WORKER: Body:", notificationBody);
    console.log("🔔 SERVICE WORKER: Showing notification...");
    
    const notificationOptions = {
      body: notificationBody,
      icon: "/icons/Icon-192.png",
      badge: "/icons/Icon-192.png",
      tag: "notification-tag",
      requireInteraction: false,
      data: payload.data || {},
    };

    return self.registration.showNotification(notificationTitle, notificationOptions)
      .then(() => {
        console.log("🔔 SERVICE WORKER: ✅ Notification shown successfully");
      })
      .catch((error) => {
        console.error("🔔 SERVICE WORKER: ❌ Error showing notification:", error);
      });
  } catch (error) {
    console.error("🔔 SERVICE WORKER: ❌ Error in onBackgroundMessage handler:", error);
  }
});

// 🔔 Log when service worker is activated
self.addEventListener("activate", function (event) {
  console.log("🔔 SERVICE WORKER: Activated - ready to receive messages");
  event.waitUntil(clients.claim());
});

// 🔔 Log when service worker is installed
self.addEventListener("install", function (event) {
  console.log("🔔 SERVICE WORKER: Installed");
  event.waitUntil(self.skipWaiting());
});

// 🔔 Handle notification clicks
self.addEventListener("notificationclick", function (event) {
  console.log("🔔 SERVICE WORKER: Notification clicked:", event.notification.title);
  event.notification.close();
  
  event.waitUntil(
    clients.matchAll({ type: "window" }).then(function (clientList) {
      // Focus existing window if open
      for (let i = 0; i < clientList.length; i++) {
        if (clientList[i].url === "/" && "focus" in clientList[i]) {
          return clientList[i].focus();
        }
      }
      // Open new window if not open
      if (clients.openWindow) {
        return clients.openWindow("/");
      }
    })
  );
});

