class UserModel{

  String userId;
  String fname;
  String lname;
  String email;

  //UserModel({this.userId});

  UserModel({this.userId, this.fname , this.lname, this.email});

  String getuserId() {
    return userId;
  }
  String getfname() {
    return fname;
  }
  String getlname() {
    return lname;
  }
  String getemail() {
    return email;
  }

}