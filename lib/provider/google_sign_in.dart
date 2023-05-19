import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future<void> googleLogout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> changeGoogleAccount(BuildContext context) async {
    await googleLogout();
    await googleLogin();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
