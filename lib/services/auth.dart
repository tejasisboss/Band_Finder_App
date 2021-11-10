import 'package:final_bf/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(dynamic user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

  String userUid;
  String get getUserUid => userUid;

  //auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //login method
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      userUid = firebaseUser.uid;
      print('Created account uid => $userUid');
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signUp with email & password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      userUid = firebaseUser.uid;
      print('Created account uid => $userUid');
      //create a new doc for the user
      //commented this caz found a way to do it from screen
      //await DatabaseService(uid: firebaseUser.uid).updateUserData("", email);
      //return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //to reset password
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Used in search file to get current email for chat
  getMyEmail() {
    var user1 = FirebaseAuth.instance.currentUser;
    return user1.email;
  }

//sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
