import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:myapp/services/auth_service.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- IMMEDIATE LOGIN TEST ---
  developer.log('Attempting anonymous login...', name: 'main');
  AuthService authService = AuthService();
  User? user = await authService.signInAnonymously();
  if (user != null && user.isAnonymous) {
    developer.log('✅ SUCCESS: Anonymous login complete. User UID: ${user.uid}', name: 'main');
  } else {
    developer.log('❌ FAILURE: Anonymous login failed.', name: 'main');
  }
  // --- END IMMEDIATE LOGIN TEST ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnityLink',
      home: Scaffold(
        appBar: AppBar(title: const Text('Login Test')),
        body: const Center(child: Text('Check console for login status.')),
      ),
    );
  }
}
