import 'package:final_bf/helper/helperfunctions.dart';

class Constants{

  static String myEmail = "";

  Constants(){
    getMyMail();
  }

  getMyMail() async {
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
    return myEmail;
  }


}