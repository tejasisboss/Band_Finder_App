import 'package:flutter/material.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/screens/home.dart';
import 'package:provider/provider.dart';
import 'authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userp = Provider.of<UserModel>(context);
    //print(userp);

    // return home or authenticate widget
    if (userp == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}