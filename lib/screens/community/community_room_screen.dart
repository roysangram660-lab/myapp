import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/chat_service.dart';
import 'package:myapp/widgets/message_bubble.dart';
import 'package:myapp/widgets/message_composer.dart';

class CommunityRoomScreen extends StatelessWidget {
  final String roomId;
  const CommunityRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('community_rooms').doc(roomId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('Room');
            }
            final roomName = snapshot.data!['name'] ?? 'Room';
            return Text(roomName);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getCommunityRoomMessages(roomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUser.uid;
                    final timestamp = message['timestamp'] as Timestamp?;

                    return MessageBubble(
                      isMe: isMe,
                      text: message['text'],
                      sender: message['senderName'],
                      timestamp: timestamp?.toDate(),
                    );
                  },
                );
              },
            ),
          ),
          MessageComposer(
            onSendMessage: (text) {
              chatService.sendCommunityRoomMessage(
                roomId,
                text,
              );
            },
          ),
        ],
      ),
    );
  }
}
