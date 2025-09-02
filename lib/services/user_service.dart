import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  // Create a user document in Firestore
  Future<void> createUser(User user) async {
    return await _db.collection(_collectionPath).doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get a user document from Firestore
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection(_collectionPath).doc(uid).get();
  }

  // Update a user document in Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    return await _db.collection(_collectionPath).doc(uid).update(data);
  }
}
