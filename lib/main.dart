import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/utils/theme_provider.dart';
import 'package:myapp/router.dart';
import 'package:myapp/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/services/chat_service.dart';
import 'package:myapp/services/storage_service.dart';
import 'package:myapp/services/gemini_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<ChatService>(create: (_) => ChatService()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<GeminiService>(create: (_) => GeminiService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'UnityLink',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
