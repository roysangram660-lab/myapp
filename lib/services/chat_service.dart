import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'chats';

  // Get a stream of messages for a chat room
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _db
        .collection(_collectionPath)
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Send a message to a chat room
  Future<void> sendMessage(String chatRoomId, String text, String senderId) async {
    await _db
        .collection(_collectionPath)
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Create a chat room
  Future<String> createChatRoom(List<String> userIds) async {
    final chatRoom = await _db.collection(_collectionPath).add({
      'users': userIds,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return chatRoom.id;
  }
}
