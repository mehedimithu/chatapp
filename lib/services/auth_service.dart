import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  //Login
  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        _firestore
            .collection('user')
            .doc(_firebaseAuth.currentUser!.uid)
            .get()
            .then((value) => _firebaseAuth.currentUser!
                .updateProfile(displayName: value['name']));
        return _userFromFirebase(credential.user);
      } else {
        return _userFromFirebase(credential.user);
      }
    } catch (e) {
      print(e);
      // return null;
    }
  }

  //Signup
  Future<User?> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        _firebaseAuth.currentUser!.updateProfile(displayName: name);
        await _firestore
            .collection('user')
            .doc(_firebaseAuth.currentUser!.uid)
            .set({
          "name": name,
          "email": email,
          "status": "Unavailable",
          "uid": _firebaseAuth.currentUser!.uid,
        });
        return _userFromFirebase(credential.user);
      } else {
        return _userFromFirebase(credential.user);
      }
    } catch (e) {
      print(e);
      // return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
