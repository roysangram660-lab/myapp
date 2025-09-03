import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/utils/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnityLink'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/chats'),
              child: const Text('Chat'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/community'),
              child: const Text('Community Rooms'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/video'),
              child: const Text('Video Call'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/discover'),
              child: const Text('Discover'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/issues'),
              child: const Text('Issue Rooms'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/gemini'),
              child: const Text('Gemini AI'),
            ),
          ],
        ),
      ),
    );
  }
}
