import 'package:final_bf/screens/AuthenticationPages/signupfiles/signuphelper.dart';
import 'package:final_bf/services/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/widgets/widgets.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;
  LogIn({this.toggleView});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;

  //AuthMethods authMethod = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  // text field state
  String error = "";

  logMeIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      dynamic result = await AuthMethods()
          .logInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .whenComplete(() =>
              Provider.of<FirebaseOperations>(context, listen: false)
                  .initUserData(context));
      if (result == null) {
        setState(() {
          error = "please enter a valid Email and Password";
          isLoading = false;
        });
      }
    }
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

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          print('Login Pressed');
          if (formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });

            dynamic result =
                await Provider.of<AuthMethods>(context, listen: false)
                    .logInWithEmailAndPassword(emailTextEditingController.text,
                        passwordTextEditingController.text)
                    .whenComplete(() =>
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .initUserData(context));
            if (result == null) {
              setState(() {
                error = "please enter a valid Email and Password";
                isLoading = false;
              });
            }
          }
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Text(
          'LOGIN',
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
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
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
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                      child: Container(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/logo.png',
                                  height: 200.0, fit: BoxFit.cover),
                              //SizedBox(height: 50,),
                              buildEmail(),
                              buildPassword(),
                              /* Text(error,style: TextStyle(color: Colors.red),),
                      TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Enter correct email";
                          },
                          controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Email')
                      ),
                      TextFormField(
                          obscureText: true,
                          validator:  (val){
                            return val.length < 6 ? "Enter Password with 6+ characters" : null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('Password')
                      ),*/
                              //SizedBox(height: 3,),
                              Container(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Text(
                                      'Forgot Password?',
                                      style: simpleTextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                              //SizedBox(height: 8,),
                              buildLoginBtn(),
                              /*  GestureDetector(
                                onTap: () {
                                  //logMeIn();
                                  print('Login Pressed');
                                  logMeIn();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 6,
                                            offset: Offset(0, 2))
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Color(0xffa3def8),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ), */
                              /*SizedBox(height: 8,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                        ),
                        child: Text(
                          'Log In with Google', style: TextStyle(color: Color(0xff1F1F1F), fontSize: 17),
                        ),
                      ),*/
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have account?",
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
                                        'Register Now',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
