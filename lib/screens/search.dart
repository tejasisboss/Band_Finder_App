import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bf/screens/chat.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/services/database.dart';
import 'package:final_bf/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseService databaseService = new DatabaseService();

  QuerySnapshot querySnapshot;

  initiateSearch(){
    databaseService.getUserByName(searchTextEditingController.text).then((val) {
      setState(() {
        querySnapshot = val;
      });
    });
  }


  Widget searchList(){
    return querySnapshot != null ? ListView.builder(
      itemCount: querySnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return searchTile(
          fName: querySnapshot.docs[0].get('firstName'),
          email: querySnapshot.docs[0].get('email'),
        );
        }) : Container();
  }

  //This function will create and then send the user to chat screen
  createAndGoToChatScreen({String userEmail}){

    if(userEmail != AuthMethods().getMyEmail()){
      String chatRoomId = getChatRoomId(userEmail, AuthMethods().getMyEmail());

      List<String> users = [userEmail, AuthMethods().getMyEmail()];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId" : chatRoomId
      };
      DatabaseService().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatScreen(chatRoomId,userEmail)
      ));
    }

  }

  Widget searchTile({String fName, String email}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fName, style: simpleTextStyle(),),
              Text(email, style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createAndGoToChatScreen(
                userEmail: email,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Connect", style: simpleTextStyle()),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: 'search with email',
                          hintStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                    },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0x54FFFFFF),
                      borderRadius: BorderRadius.circular(50)
                    ),
                      child: Icon(Icons.search, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          searchList(),
        ],
      )
    );
  }
}

getChatRoomId(String a, String b){
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}



