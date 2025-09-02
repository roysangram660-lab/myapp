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
              onPressed: () => context.go('/home/chat'),
              child: const Text('Chat'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/home/video'),
              child: const Text('Video Call'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/home/discover'),
              child: const Text('Discover'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/home/issues'),
              child: const Text('Issue Rooms'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/home/profile'),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
