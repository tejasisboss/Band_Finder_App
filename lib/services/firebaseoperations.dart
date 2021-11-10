import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  String initUserEmail, initUserName, initUserImage;
  String get getInitUserName => initUserName;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserImage => initUserImage;

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserModel>(context, listen: false).getuserId())
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserModel>(context, listen: false).getuserId())
        .get()
        .then(
          (value) => {
            print('Fetching user data'),
            initUserName = value.data()['firstName'].toString(),
            initUserEmail = value.data()['email'].toString(),
            initUserImage = value.data()['userimage'],
            print(initUserName),
            print(initUserEmail),
            print(initUserImage),
            notifyListeners()
          },
        );
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }
}
