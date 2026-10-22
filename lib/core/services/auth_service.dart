import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/model/user.dart' as usermodel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract final class AuthService {
  static const String serverClientId =
      "447250715587-sumu7tqpa7i8kqapvtorrbhpvbfhgf71.apps.googleusercontent.com";

  static Future<void> init() async {
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
  }

  static Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();
    GoogleSignInAuthentication auth = account.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
    );
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    var userDoc = await FirebaseFirestore.instance
        .collection("User")
        .doc(userCredential.user?.uid)
        .get();
    if (!userDoc.exists) {
      await FirestoreManager.saveUser(usermodel.User(
        id: userCredential.user?.uid,
        name: userCredential.user?.displayName,
        email: userCredential.user?.email,
        favorites: [],
      ));
    }
    return userCredential;
  }
}