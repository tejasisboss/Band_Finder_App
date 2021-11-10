import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:final_bf/constants/constantcolors.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/screens/ProfilePage/profilehelpers.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/services/auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            EvaIcons.settings2Outline,
            color: constantColors.lightBlueColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: Color(0xffa3def8).withOpacity(0.6),
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Profile",
                style: TextStyle(
                  color: Color(0xffa3def8),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF100E20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<UserModel>(context, listen: false).getuserId())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Loading(),
                );
              } else {
                return new Column(
                  children: [
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .headerProfile(context, snapshot),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .divider(),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .middleProfile(context, snapshot),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .footerProfile(context, snapshot),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
