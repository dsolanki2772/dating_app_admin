import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authProvider = Provider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider {
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      final _userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _userCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        EasyLoading.showError(
            'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.');
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong.');
    }
    return null;
  }

  Future<User?> signInWithPhoneNumber(
      String smsCode, String verificationId) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final _userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _userCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        EasyLoading.showError('Invalid code.');
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong.');
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
