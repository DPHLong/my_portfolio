import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Defaulting to web config since this is primarily a web portfolio.
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5wzE__SeTwo7Fv-2uZLX1wt66mQkf6sw',
    appId: '1:281657177539:web:68a0df2c38d13e7a96f976',
    messagingSenderId: '281657177539',
    projectId: 'portfolio-backend-73dea',
    authDomain: 'portfolio-backend-73dea.firebaseapp.com',
    storageBucket: 'portfolio-backend-73dea.firebasestorage.app',
    measurementId: 'G-G1XPJC7Y9M',
  );
}
