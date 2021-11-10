import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bf/helper/constants.dart';
import 'package:final_bf/helper/helperfunctions.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/screens/chat.dart';
import 'package:final_bf/screens/search.dart';
import 'package:final_bf/services/database.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:final_bf/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/services/auth.dart';

class ChatListScreen extends StatefulWidget {

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  AuthMethods authMethod = new AuthMethods();
  DatabaseService databaseService = new DatabaseService();

  Stream chatListsStream;
  QuerySnapshot querySnapshot;

  Widget chatLists(){
    return StreamBuilder(
      stream: chatListsStream,
        builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatListTile(snapshot.data.docs[index]['chatroomId']
                .toString().replaceAll("_", "")
                .replaceAll(authMethod.getMyEmail(), ""),
                snapshot.data.docs[index]['chatroomId']);
          },
        ) : Loading();
        },
    );
  }

  @override
  void initState() {
    getsaveinfo();
    databaseService.getChatLists(AuthMethods().getMyEmail()).then((val){
      setState(() {
        chatListsStream = val;
      });
    });
    super.initState();
  }

  getsaveinfo() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,'Chats'),
      body: chatLists(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatListTile extends StatefulWidget {

  final String email;
  final String chatRoomId;

  ChatListTile(this.email,this.chatRoomId);

  @override
  _ChatListTileState createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {

  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot querySnapshot;
  String name;


  @override
  void initState() {
    databaseService.getUserNameByMail(widget.email).then((val) {
      setState(() {
        querySnapshot = val;
      });
    });
    super.initState();
  }

  nameText(){
    return querySnapshot != null ? ListView.builder(
        itemCount: querySnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          name = querySnapshot.docs[0].get('firstName');
          return Text(
            querySnapshot.docs[0].get('firstName'),
            style: simpleTextStyle(),
          );
        }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatScreen(widget.chatRoomId,name)
        ));
      },
      child: Card(
        color: Color(0x54665F5F),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text("${widget.email.substring(0,1).toUpperCase()}",
                  style: simpleTextStyle(),
                ),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  children: [
                    nameText(),
                    //SizedBox(height: 5,),
                    // Text(widget.email, style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 12), textAlign: TextAlign.start,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
