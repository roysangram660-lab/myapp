
      import 'dart:developer' as developer;
      import 'package:firebase_auth/firebase_auth.dart';
      import 'package:google_sign_in/google_sign_in.dart';
      import 'package:myapp/services/user_service.dart';

      class AuthService {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final GoogleSignIn _googleSignIn = GoogleSignIn();
        final UserService _userService = UserService();

        Stream<User?> get user => _auth.authStateChanges();
        User? get currentUser => _auth.currentUser;

        Future<User?> signInWithEmailAndPassword(String email, String password) async {
          try {
            UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
            return result.user;
          } catch (e, s) {
            developer.log('Sign in with email failed', name: 'AuthService', error: e, stackTrace: s);
            return null;
          }
        }

       Future<User?> signInAnonymously() async {
         try {
           UserCredential result = await _auth.signInAnonymously();
           developer.log('✅ Signed in anonymously: ${result.user?.uid}', name: 'AuthService');
           return result.user;
         } catch (e, s) {
           developer.log('❌ Anonymous sign in failed', name: 'AuthService', error: e, stackTrace: s);
           return null;
         }
       }
      }
