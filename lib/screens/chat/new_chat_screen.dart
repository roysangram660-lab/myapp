import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/chat_service.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final currentUser = authService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userDocs = snapshot.data!.docs
              .where((doc) => doc.id != currentUser.uid)
              .toList();

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final user = userDocs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['photoURL'] ?? ''),
                  child: user['photoURL'] == null
                      ? Text(user['displayName']?[0] ?? 'U')
                      : null,
                ),
                title: Text(user['displayName'] ?? 'User'),
                onTap: () async {
                  final chatRoomId = await chatService.createChatRoom([currentUser.uid, user.id]);
                  if (!mounted) return;
                  context.go('/chats/$chatRoomId');
                },
              );
            },
          );
        },
      ),
    );
  }
}
