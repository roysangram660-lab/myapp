import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final isLoggedIn = user != null;

    // Use addPostFrameCallback to navigate after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/auth');
      }
    });

    // Return a placeholder widget, as the navigation will happen immediately.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
