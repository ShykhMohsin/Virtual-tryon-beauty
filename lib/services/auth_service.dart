import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final result = await _auth.signInWithCredential(credential);
        return result.user;
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // /// Facebook Sign-In
  // Future<User?> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
  //       final userCred = await _auth.signInWithCredential(facebookAuthCredential);
  //       return userCred.user;
  //     } else {
  //       print('Facebook Login Failed: ${result.message}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Facebook Sign-In Error: $e');
  //     return null;
  //   }
  // }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }
    await FacebookAuth.instance.logOut();
  }

  User? get currentUser => _auth.currentUser;
}
