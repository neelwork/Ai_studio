import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '1005197027466-5527ftrhk0s4uooqulase8dm958gvogm.apps.googleusercontent.com' : null,
    scopes: [
      'email',
      'profile',
    ],
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
          'prompt': 'select_account',
          'access_type': 'offline',
        });
        
        try {
          debugPrint('Attempting popup sign in...');
          final userCredential = await _auth.signInWithPopup(googleProvider);
          debugPrint('Sign in successful with popup. User: ${userCredential.user?.email}');
          return userCredential;
        } catch (popupError) {
          debugPrint('Popup error details: $popupError');
          
          // Check if it's an unauthorized domain error
          if (popupError.toString().contains('unauthorized-domain')) {
            debugPrint('Domain not authorized. Please add your domain to Firebase Console.');
            debugPrint('Current hostname: ${Uri.base.host}');
            debugPrint('Current port: ${Uri.base.port}');
            debugPrint('Full origin: ${Uri.base.origin}');
          }
          
          // Try redirect as fallback
          debugPrint('Attempting redirect sign in...');
          await _auth.signInWithRedirect(googleProvider);
          return null;
        }
      } else {
        // For mobile platforms
        // First sign out to force showing the account picker
        await _googleSignIn.signOut();
        
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        debugPrint('Google Sign In attempt completed. User: ${googleUser?.email ?? 'null'}');

        if (googleUser == null) {
          debugPrint('Google Sign In was cancelled or failed');
          return null;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        final userCredential = await _auth.signInWithCredential(credential);
        debugPrint('Firebase sign in successful. User: ${userCredential.user?.email}');
        return userCredential;
      }
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      if (kIsWeb) {
        await _auth.signOut();
      } else {
        await _googleSignIn.signOut();
        await _auth.signOut();
      }
    } catch (e) {
      debugPrint("Sign out error: $e");
      rethrow;
    }
  }
}
