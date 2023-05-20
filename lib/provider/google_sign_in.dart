import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_note/screens/home_screen.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin(BuildContext context) async {
    print('Starting Google Sign-In');

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return;
      }

      print('Google User: ${googleUser.displayName}');

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Firebase Authentication successful');

      // Navigate to the next page after successful authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Replace 'NextPage' with your desired page
      );
    } catch (e) {
      print('Firebase Authentication failed: $e');
    }
  }
}
