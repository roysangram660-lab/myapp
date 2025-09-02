import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  String? _otherUserName;
  String? _otherUserPhotoUrl;

  @override
  void initState() {
    super.initState();
    _getOtherUserDetails();
  }

  Future<void> _getOtherUserDetails() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatRoomId)
        .get();
    final List<dynamic> users = chatDoc['users'];
    final currentUser = context.read<AuthService>().getCurrentUser();
    final otherUserId = users.firstWhere((id) => id != currentUser!.uid);

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();

    setState(() {
      _otherUserName = userDoc['displayName'];
      _otherUserPhotoUrl = userDoc['photoURL'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_otherUserPhotoUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(_otherUserPhotoUrl!),
              ),
            if (_otherUserPhotoUrl == null)
              CircleAvatar(
                child: Text(_otherUserName?[0] ?? 'U'),
              ),
            const SizedBox(width: 8),
            Text(_otherUserName ?? 'Chat'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messageDocs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messageDocs.length,
                  itemBuilder: (context, index) {
                    final message = messageDocs[index];
                    final isMe = message['senderId'] == currentUser!.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) => _sendMessage(chatService, currentUser!.uid),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(chatService, currentUser!.uid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatService chatService, String senderId) {
    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.chatRoomId, _messageController.text, senderId);
      _messageController.clear();
    }
  }
}
