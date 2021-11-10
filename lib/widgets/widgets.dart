import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context,String name) {
  return AppBar(
    title: Text(name),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

Widget buildEditiIcon(Color color) => buildCircle(
  color: Colors.white,
  all:3,
  child:   buildCircle(
      color: color,
      all: 8,
      child: Icon(
        Icons.edit,
        size: 30,
        color: Colors.white,
      ),
  ),
);

Widget buildCircle({Color color, double all, Widget child}){
  return ClipOval(
    child: Container(
      color: color,
      padding: EdgeInsets.all(all),
      child: child,
    ),
  );
}