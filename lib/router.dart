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
import 'package:myapp/screens/gemini_screen.dart';
import 'package:myapp/screens/community/community_rooms_screen.dart';
import 'package:myapp/screens/community/new_community_room_screen.dart';
import 'package:myapp/screens/community/community_room_screen.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/utils/go_router_refresh_stream.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  refreshListenable: GoRouterRefreshStream(AuthService().user),
  initialLocation: '/auth',
  routes: <RouteBase>[
    GoRoute(
        path: '/',
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
              path: 'community',
              builder: (BuildContext context, GoRouterState state) {
                return const CommunityRoomsScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'new',
                  builder: (BuildContext context, GoRouterState state) {
                    return const NewCommunityRoomScreen();
                  },
                ),
                GoRoute(
                  path: 'room/:id',
                  builder: (BuildContext context, GoRouterState state) {
                    final String roomId = state.pathParameters['id']!;
                    return CommunityRoomScreen(roomId: roomId);
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
          GoRoute(
            path: 'gemini',
            builder: (BuildContext context, GoRouterState state) {
              return const GeminiScreen();
            },
          ),
        ]),
    GoRoute(
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthScreen();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final bool loggedIn = authService.currentUser != null;
    final bool loggingIn = state.matchedLocation == '/auth';

    if (!loggedIn) {
      return '/auth';
    }

    if (loggingIn) {
      return '/';
    }

    return null;
  },
);
