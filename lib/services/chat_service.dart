import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _chatsCollectionPath = 'chats';
  final String _roomsCollectionPath = 'community_rooms';

  // Get a stream of messages for a chat room
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _db
        .collection(_chatsCollectionPath)
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Send a message to a chat room
  Future<void> sendMessage(String chatRoomId, String text) async {
    final currentUser = _auth.currentUser!;
    await _db
        .collection(_chatsCollectionPath)
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Create a chat room
  Future<String> createChatRoom(List<String> userIds) async {
    final chatRoom = await _db.collection(_chatsCollectionPath).add({
      'users': userIds,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return chatRoom.id;
  }

  // Create a community room
  Future<String> createCommunityRoom(String name) async {
    final currentUser = _auth.currentUser!;
    final room = await _db.collection(_roomsCollectionPath).add({
      'name': name,
      'createdBy': currentUser.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return room.id;
  }

  // Get a stream of messages for a community room
  Stream<QuerySnapshot> getCommunityRoomMessages(String roomId) {
    return _db
        .collection(_roomsCollectionPath)
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Send a message to a community room
  Future<void> sendCommunityRoomMessage(String roomId, String text) async {
    final currentUser = _auth.currentUser!;
    await _db
        .collection(_roomsCollectionPath)
        .doc(roomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
