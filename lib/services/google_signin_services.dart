import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '1005197027466-5527ftrhk0s4uooqulase8dm958gvogm.apps.googleusercontent.com' : null,
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign In process...');
      
      if (kIsWeb) {
        // For web, use Firebase's signInWithPopup
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
        googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
        
        // Force showing the account picker
        googleProvider.setCustomParameters({
          'prompt': 'select_account'
        });
        
        final userCredential = await _auth.signInWithPopup(googleProvider);
        log('Firebase sign in successful. User: ${userCredential.user?.email}');
        return userCredential;
      } else {
        // For mobile platforms
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        log('Google Sign In attempt completed. User: ${googleUser?.email ?? 'null'}');

        if (googleUser == null) {
          log('Google Sign In was cancelled or failed');
          return null;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        final userCredential = await _auth.signInWithCredential(credential);
        log('Firebase sign in successful. User: ${userCredential.user?.email}');
        return userCredential;
      }
    } catch (e) {
      log("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (kIsWeb) {
        // For web, just sign out from Firebase
        await _auth.signOut();
      } else {
        // For mobile, sign out from both
        await _googleSignIn.signOut();
        await _auth.signOut();
      }
    } catch (e) {
      log("Sign out error: $e");
    }
  }
}
