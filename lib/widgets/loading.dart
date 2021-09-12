import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Color(0xff007EF4),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xff007EF4),
          size: 50,
        ),
      ),
    );
  }
}