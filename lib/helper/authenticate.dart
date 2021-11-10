import 'package:flutter/material.dart';
import '../screens/AuthenticationPages/login.dart';
import '../screens/AuthenticationPages/signupfiles/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LogIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
