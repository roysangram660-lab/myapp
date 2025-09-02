import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/chat/chat_list_screen.dart';
import 'package:myapp/screens/chat/chat_screen.dart';
import 'package:myapp/screens/chat/new_chat_screen.dart';
import 'package:myapp/screens/video_call_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/screens/discovery_screen.dart';
import 'package:myapp/screens/issue_room_screen.dart';
import 'package:myapp/screens/auth/auth_screen.dart';
import 'package:myapp/screens/landing_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LandingScreen();
      },
    ),
    GoRoute(
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'chats',
              builder: (BuildContext context, GoRouterState state) {
                return const ChatListScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'new',
                  builder: (BuildContext context, GoRouterState state) {
                    return const NewChatScreen();
                  },
                ),
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    final String chatRoomId = state.pathParameters['id']!;
                    return ChatScreen(chatRoomId: chatRoomId);
                  },
                ),
              ]),
          GoRoute(
            path: 'video',
            builder: (BuildContext context, GoRouterState state) {
              return const VideoCallScreen();
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: 'discover',
            builder: (BuildContext context, GoRouterState state) {
              return const DiscoveryScreen();
            },
          ),
          GoRoute(
            path: 'issues',
            builder: (BuildContext context, GoRouterState state) {
              return const IssueRoomScreen();
            },
          ),
        ]),
  ],
);
