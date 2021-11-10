import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bf/screens/AuthenticationPages/signupfiles/signup.dart';
import 'package:final_bf/screens/AuthenticationPages/signupfiles/signuphelper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("ChatRoom");

  // updates the use data in firebase
  /*Future updateUserData(String name, String mail) async {
    return await userCollection.doc(uid).set({
      'name' :  name,
      'Mail' : mail,
    });
  }*/
  updateUserData(userMap) {
    userCollection.add(userMap);
  }

  //This function is used in search.dart file
  getUserByName(String name) async {
    return await userCollection.where('firstName', isEqualTo: name).get();
  }

  getUserNameByMail(String mail) {
    return userCollection.where('email', isEqualTo: mail).get();
    //.where('email', isEqualTo: mail).docs().get('firstName');
  }

  //creates chat room
  createChatRoom(String chatRoomId, chatRoomMap) {
    chatCollection.doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  //To store messages in firebase
  storeMessagesForChat(String chatRoomId, messageMap) {
    chatCollection
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  //read messages for chat
  getMessagesForChat(String chatRoomId) async {
    return chatCollection
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  //This is used to get the chats the user is in and shown in chatlistScreen.dart file.
  getChatLists(String email) async {
    return await chatCollection
        .where("users", arrayContains: email)
        .snapshots();
  }
}
