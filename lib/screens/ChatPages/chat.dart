import 'package:final_bf/services/auth.dart';
import 'package:final_bf/services/database.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  final String chatRoomId;
  final String email;
  ChatScreen(this.chatRoomId,this.email);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  DatabaseService databaseService = new DatabaseService();
  TextEditingController messageEditingController = new TextEditingController();
  Stream chatMessagesStream;

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.docs[index]['message'],snapshot.data.docs[index]['sentByMe'] == AuthMethods().getMyEmail());
          },
        ) : Loading();
      },
    );
  }

  sendText(){

    if(messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> textMap = {
        "message": messageEditingController.text,
        "sentByMe" : AuthMethods().getMyEmail(),
        "time" : DateTime.now().microsecondsSinceEpoch,
      };
      databaseService.storeMessagesForChat(widget.chatRoomId, textMap);
      messageEditingController.text = "";
    }
  }


  @override
  void initState() {
    databaseService.getMessagesForChat(widget.chatRoomId).then((val){
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                          controller: messageEditingController,
                          decoration: InputDecoration(
                            hintText: 'Type a massage',
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
                        sendText();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0x54FFFFFF),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Icon(Icons.send, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSentByMe;

  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
              ]
          ),
        borderRadius: BorderRadius.circular(5)
        ),
        child: Text(message,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
          ),
        ),
      ),
    );
  }
}

