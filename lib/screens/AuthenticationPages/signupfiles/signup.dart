import 'package:final_bf/helper/helperfunctions.dart';
import 'package:final_bf/services/database.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:final_bf/widgets/widgets.dart';

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
  TextEditingController fNameTextEditingController = new TextEditingController();
  TextEditingController lNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  // text field state
  String error = "";

  signMeUp() async {
    Map<String, dynamic> userInfoMap = {
      "firstName" : fNameTextEditingController.text,
      "lastName" : lNameTextEditingController.text,
      "email" : emailTextEditingController.text,
    };

    //saves email in shared preference
    HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      dynamic result = await authMethod.signUpWithEmailAndPassword(emailTextEditingController.text,
      passwordTextEditingController.text);
      //below line can be used to upload from each screen
      databaseService.updateUserData(userInfoMap);
      if(result == null){
        setState(() {
          error = "This email is in use by another account.";
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
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty ? "Please Provide First name" : null;
                        },
                          controller: fNameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('First Name')
                      ),
                      TextFormField(
                          validator: (val){
                            return val.isEmpty ? "Please Provide Last name" : null;
                          },
                          controller: lNameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('Last Name')
                      ),
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
                            return val.length < 8 ? "Enter Password with 8+ characters" : null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('Password')
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
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
                      'Sign Up', style: TextStyle(color: Colors.white, fontSize: 17),
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
                    'Sign Up with Google', style: TextStyle(color: Color(0xff1F1F1F), fontSize: 17),
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account?", style: biggerTextStyle(),),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        widget.toggleView();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text('LogIn Now',
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
                Text(error,style: TextStyle(color: Colors.red),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
