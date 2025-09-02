import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e, s) {
      developer.log('Sign in with email failed', name: 'AuthService', error: e, stackTrace: s);
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await _userService.createUser(user);
      }
      return user;
    } catch (e, s) {
      developer.log('Sign up with email failed', name: 'AuthService', error: e, stackTrace: s);
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // The web client ID for your Firebase project.
      const String webClientId = "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com";
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // This should not happen, but it's a good practice to check.
      if (googleAuth == null) {
        developer.log('Google Sign-In authentication details are null', name: 'AuthService');
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        final userDoc = await _userService.getUser(user.uid);
        if (!userDoc.exists) {
          await _userService.createUser(user);
        }
      }
      return user;
    } catch (e, s) {
      developer.log('Sign in with Google failed', name: 'AuthService', error: e, stackTrace: s);
      return null;
    }
  }


  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
       User? user = result.user;
      if (user != null) {
        await _userService.createUser(user);
      }
      return user;
    } catch (e, s) {
      developer.log('Sign in anonymously failed', name: 'AuthService', error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
