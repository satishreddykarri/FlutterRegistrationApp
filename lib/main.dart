import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registrationpage/Screens/homescreen.dart';
import 'package:registrationpage/Screens/upload_status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDfAeKxfaF4ULmiYGzXqIghrY4cle0Hr9g",
            authDomain: "loginpage-389c4.firebaseapp.com",
            projectId: "loginpage-389c4",
            storageBucket: "loginpage-389c4.appspot.com",
            messagingSenderId: "576818925290",
            appId: "1:576818925290:web:f1840a317e1e7b68905193",
            measurementId: "G-ZW3TJCLV4S"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homescreen(),
    );
  }
}
