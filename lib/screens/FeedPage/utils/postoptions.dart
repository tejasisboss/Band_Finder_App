import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bf/constants/constantcolors.dart';
import 'package:final_bf/services/auth.dart';
import 'package:final_bf/services/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<AuthMethods>(context,listen:false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<AuthMethods>(context,listen:false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(docId)
                            .collection('comments')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return !(snapshot.data == null)
                                ? new ListView(
                                    children: snapshot.data.docs.map(
                                        (DocumentSnapshot documentSnapshot) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: GestureDetector(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          constantColors
                                                              .darkColor,
                                                      radius: 15.0,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              documentSnapshot[
                                                                  "userimage"]),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                    documentSnapshot[
                                                        'username'],
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .arrowUp,
                                                          color: constantColors
                                                              .blueColor,
                                                          size: 18,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                      Text(
                                                        '0',
                                                        style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .reply,
                                                          color: constantColors
                                                              .yellowColor,
                                                          size: 18,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: constantColors
                                                          .blueColor,
                                                      size: 12,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: Text(
                                                      documentSnapshot[
                                                          'comment'],
                                                      style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      FontAwesomeIcons.trashAlt,
                                                      color: constantColors
                                                          .redColor,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: constantColors.darkColor
                                                  .withOpacity(0.2),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Center(
                                    child: Text("No Comments"),
                                  );
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add Comment...',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: commentController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            print('Adding Comment');
                            addComment(context, snapshot['caption'],
                                    commentController.text)
                                .whenComplete(() {
                              commentController.clear();
                              notifyListeners();
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
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
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              trailing: AuthMethods().getUserUid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          );
        });
  }

  showRewards(BuildContext context) {
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
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  /*child:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('awards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height: 50.0,
                                width: 50.0,
                                child: Image.network(documentSnapshot['image']),
                              );
                            }),
                          );
                        }
                      }), */
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          );
        });
  }
}
