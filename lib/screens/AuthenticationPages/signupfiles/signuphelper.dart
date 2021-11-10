import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpHelper with ChangeNotifier {
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;
  final picker = ImagePicker();
  UploadTask imageProfileUploadTask;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        ? print('Select image')
        : userAvatar = File(pickedUserAvatar.path);
    print('Path:- ${userAvatar.path}');

    userAvatar != null ? showUserAvatar(context) : print('Image Upload Error');
    notifyListeners();
  }

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${userAvatar.path}/${TimeOfDay.now()}');
    imageProfileUploadTask = imageReference.putFile(userAvatar);
    await imageProfileUploadTask.whenComplete(() {
      print('Image uploaded');
    });
    imageReference.getDownloadURL().then((value) {
      //print('hi');
      print(value);
      userAvatarUrl = value;
      print(userAvatarUrl);
    });
    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        print('im here');
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<SignUpHelper>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<SignUpHelper>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        });
  }

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(
                        Provider.of<SignUpHelper>(context, listen: false)
                            .userAvatar),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<SignUpHelper>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          },
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          child: Text(
                            'Confirm Image',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            uploadUserAvatar(context).whenComplete(() {
                              Navigator.pop(context);
                              print('Image Uploaded');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          );
        });
  }
}
