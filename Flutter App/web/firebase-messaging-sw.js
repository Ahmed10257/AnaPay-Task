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

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log("Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png",
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
