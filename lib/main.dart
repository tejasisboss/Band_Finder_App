import 'package:final_bf/constants/constantcolors.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/screens/FeedPage/feedhelper.dart';
import 'package:final_bf/screens/FeedPage/utils/postoptions.dart';
import 'package:final_bf/screens/FeedPage/utils/uploadpost.dart';
import 'package:final_bf/screens/ProfilePage/profilehelpers.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/services/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'helper/Wrapper.dart';
import 'screens/AuthenticationPages/signupfiles/signuphelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthMethods().user,
      initialData: null,
      child: MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff145C9E),
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            primarySwatch: Colors.blue,
          ),
          home: Wrapper(),
        ),
        providers: [
          ChangeNotifierProvider(create: (context) => ProfileHelpers()),
          ChangeNotifierProvider(create: (context) => AuthMethods()),
          ChangeNotifierProvider(create: (context) => PostFunctions()),
          ChangeNotifierProvider(create: (context) => UploadPost()),
          ChangeNotifierProvider(create: (context) => FeedHelpers()),
          ChangeNotifierProvider(create: (context) => FirebaseOperations()),
          ChangeNotifierProvider(create: (context) => SignUpHelper()),
        ],
      ),
    );
  }
}
