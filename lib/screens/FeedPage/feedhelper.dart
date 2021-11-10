import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:final_bf/constants/constantcolors.dart';
import 'package:final_bf/screens/FeedPage/utils/postoptions.dart';
import 'package:final_bf/screens/FeedPage/utils/uploadpost.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffa3def8).withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .SelectPostImageType(context);
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        ),
      ],
      title: RichText(
        text: TextSpan(
          text: 'Feed ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: 400,
                    //child: Lottie.asset('assets/animations/loading.json'),
                    child: Loading(),
                  ),
                );
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Color(0xFF100E20),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0))),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data.docs.map(
        (DocumentSnapshot documentSnapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.63,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade900,
                          radius: 20,
                          backgroundImage:
                              NetworkImage(documentSnapshot['userimage']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  documentSnapshot['caption'],
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: documentSnapshot['username'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' , 12 hrs to go',
                                          style: TextStyle(
                                              color: Color(0xff6c788a)
                                                  .withOpacity(0.8)),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.46,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(
                        documentSnapshot['postimage'],
                        scale: 2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showLikes(
                                  context,
                                  documentSnapshot['caption'],
                                );
                              },
                              onTap: () {
                                print('Adding like..');
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .addLike(
                                        context,
                                        documentSnapshot['caption'],
                                        AuthMethods().getUserUid);
                              },
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot['caption'])
                                  .collection('likes')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(context, documentSnapshot,
                                        documentSnapshot['caption']);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.blue,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot['caption'])
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.upload,
                                color: Colors.yellow,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      AuthMethods().getUserUid == documentSnapshot['useruid']
                          ? IconButton(
                              icon: Icon(
                                EvaIcons.moreVertical,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
