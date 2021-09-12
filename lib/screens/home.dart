import 'package:final_bf/screens/chatlistScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/services/auth.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthMethods authMethod = new AuthMethods();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Finder'),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatListScreen()
                ));
              },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authMethod.signOut();
            },
          ),
        ],
      ),
    );
  }
}
