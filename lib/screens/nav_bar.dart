import 'package:final_bf/constants/constantcolors.dart';
import 'package:final_bf/screens/ProfilePage/profile.dart';
import 'package:final_bf/screens/ChatPages/chatlistScreen.dart';
import 'package:final_bf/screens/FeedPage/feed.dart';
import 'package:final_bf/screens/newpostpage/newpost.dart';
import 'package:final_bf/screens/SearchPage/search.dart';
import 'package:final_bf/services/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  ConstantColors constantColors = ConstantColors();
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Widget body(int _page) {
    switch (_page) {
      case 0:
        return Feed();
      case 1:
        return SearchScreen();
      case 2:
        return NewPostPage();
      case 3:
        return ChatListScreen();
      case 4:
        return ProfilePage();
      default:
        return new Container(
          child: new Text("No Page Found", textScaleFactor: 2.0),
        );
    }
  }

  Widget newPage = new Feed();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.feed, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.message, size: 30),
          CircleAvatar(
            radius: 20.0,
            backgroundColor: constantColors.blueGreyColor,
            backgroundImage: NetworkImage(Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage),
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: constantColors.darkColor,
        //backgroundColor: Color(0xff1F1F1F),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (int index) {
          setState(() {
            newPage = body(index);
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        //color: Colors.blueAccent,
        color: Color(0xff1F1F1F),
        child: Center(
          child: newPage,
        ),
      ),
    );
  }
}
