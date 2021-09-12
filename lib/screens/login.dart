import 'package:flutter/material.dart';
import 'package:final_bf/widgets/widgets.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/widgets/loading.dart';

class LogIn extends StatefulWidget {

  final Function toggleView;
  LogIn({this.toggleView});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  bool isLoading = false;

  AuthMethods authMethod = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();


  // text field state
  String error = "";

  logMeIn() async {
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      dynamic result = await authMethod.logInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text);
      if(result == null){
        setState(() {
          error = "please enter a valid Email and Password";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
      appBar: appBarMain(context,'Band Finder'),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', width: 200,height: 200,),
                  //SizedBox(height: 50,),
                  Text(error,style: TextStyle(color: Colors.red),),
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
                  ),
                  SizedBox(height: 8,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        //TODO
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Forgot Password?',
                          style: simpleTextStyle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      logMeIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]
                        )
                      ),
                      child: Text(
                          'Log In', style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
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
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?", style: biggerTextStyle(),),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text('Register Now',
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
                  SizedBox(height: 60,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
