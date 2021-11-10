import 'package:final_bf/helper/helperfunctions.dart';
import 'package:final_bf/models/user.dart';
import 'package:final_bf/screens/AuthenticationPages/signupfiles/signuphelper.dart';
import 'package:final_bf/services/database.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/services/firebaseoperations.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethod = new AuthMethods();
  DatabaseService databaseService = new DatabaseService();

  final formKey = GlobalKey<FormState>();
  TextEditingController fNameTextEditingController =
      new TextEditingController();
  TextEditingController lNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController skillsTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  // text field state
  String error = "";

  signMeUp() async {
    //saves email in shared preference
    HelperFunctions.saveUserEmailSharedPreference(
        emailTextEditingController.text);

    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      dynamic result = await authMethod
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .whenComplete(() {
        Provider.of<FirebaseOperations>(context, listen: false)
            .createUserCollection(context, {
          "firstName": fNameTextEditingController.text,
          "lastName": lNameTextEditingController.text,
          "email": emailTextEditingController.text,
          "skills": skillsTextEditingController.text,
          'useruid': Provider.of<UserModel>(context, listen: false).getuserId(),
          'userimage': Provider.of<SignUpHelper>(context, listen: false)
              .getUserAvatarUrl,
        });
      }).whenComplete(() =>
          Provider.of<FirebaseOperations>(context, listen: false)
              .initUserData(context));
      //below line can be used to upload from each screen
      /*if (result == null) {
        setState(() {
          error = "This email is in use by another account.";
          isLoading = false;
        });
      }*/
    }
  }

  Widget buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Skills',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator: (val) {
              return val.isEmpty ? "Please Provide Yous Skills" : null;
            },
            controller: skillsTextEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.music_note, color: Color(0x66a3def8)),
                hintText: 'Singer, Lyricist, Guitarist..',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator: (val) {
              return val.isEmpty ? "Please Provide First name" : null;
            },
            controller: fNameTextEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.person, color: Color(0x66a3def8)),
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator: (val) {
              return val.isEmpty ? "Please Provide Last name" : null;
            },
            controller: lNameTextEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.person, color: Color(0x66a3def8)),
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator: (val) {
              return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)
                  ? null
                  : "Enter correct email";
            },
            controller: emailTextEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Color(0x66a3def8)),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextFormField(
              obscureText: true,
              validator: (val) {
                return val.length < 8
                    ? "Enter Password with 8+ characters"
                    : null;
              },
              controller: passwordTextEditingController,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.lock, color: Color(0x66a3def8)),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black38)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          print('Signup Pressed');
          signMeUp();
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Text(
          'Sign Up',
          style: TextStyle(
              color: Color(0xffa3def8),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            body: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0x66a3def8),
                    Color(0x99a3def8),
                    Color(0xcca3def8),
                    Color(0xffa3def8),
                  ])),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 70.0,
                                  //backgroundColor: Colors.green,
                                  backgroundImage: Provider.of<SignUpHelper>(
                                                  context,
                                                  listen: false)
                                              .getUserAvatar ==
                                          null
                                      ? AssetImage('assets/images/logo.png')
                                      : FileImage(Provider.of<SignUpHelper>(
                                              context,
                                              listen: false)
                                          .getUserAvatar),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<SignUpHelper>(context,
                                              listen: false)
                                          .selectAvatarOptionsSheet(context);
                                    },
                                    child: buildEditiIcon(Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                buildFirstName(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                buildLastName(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                buildEmail(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                buildSkills(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                buildPassword(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          buildSignUpBtn(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have account?",
                                style: biggerTextStyle(),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'LogIn Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
