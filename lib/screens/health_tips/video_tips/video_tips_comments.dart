// import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

// import 'package:http/http.dart' as http;
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tip_widgets.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips_comments_replies.dart';

import 'package:medplan/utils/global.dart';

import '../../../helper_widget/web_view.dart';
// import '../../../server/health_tips_api_requests.dart';
import '../../../server/posts_api_requests.dart';

class VideoTipsComments extends StatefulWidget {
  dynamic videoTipData;
  List<dynamic> videoTipComments;
  VideoTipsComments({
    super.key,
    required this.videoTipData,
    required this.videoTipComments,
  });

  @override
  _VideoTipsCommentsState createState() => _VideoTipsCommentsState();
}

class _VideoTipsCommentsState extends State<VideoTipsComments> {
  final TextEditingController _commentController = TextEditingController();

  bool isCommenting = false;
  final VideoTipService _videoTipService = VideoTipService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Comments"),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: widget.videoTipComments.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (BuildContext context, int index) {
                return VideoTipWidgets().buildCommentWidget(
                  context: context,
                  commentData: widget.videoTipComments[index],
                  eventId: widget.videoTipData['_id'],
                  refresh: () => setState(() {}),
                );
              },
            ),
          ),
          buildCommentWidget(context),
        ],
      ),
    );
  }

  Padding buildCommentWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          getX.read(v.GETX_USER_IMAGE) == ''
              ? myWidgets.noProfileImage(30)
              : ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: helperWidget.cachedImage(
                  url: '${getX.read(v.GETX_USER_IMAGE)}',
                  height: 30,
                  width: 30,
                ),
              ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  width: 1,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withValues(alpha: 0.1),
                //     spreadRadius: 0,
                //     blurRadius: 2,
                //     offset: const Offset(2, 2),
                //   ),
                // ],
              ),
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                  border: InputBorder.none,
                  hintText: 'Type your comment here...',

                  hintStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    fontSize: 13,
                  ),
                ),
                // textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            onPressed:
                isCommenting
                    ? null
                    : () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (_commentController.text.isEmpty) {
                        helperWidget.showToast('Comment field must be filled');

                        return;
                      }
                      setState(() {
                        isCommenting = true;
                      });
                      try {
                        var res = await _videoTipService.commentVideoTip(
                          videoTipId: widget.videoTipData['_id'],
                          comment: _commentController.text,
                        );
                        if (res['status'] == 'ok') {
                          setState(() {
                            _commentController.clear();
                            if (widget.videoTipData['comment_count'] == null) {
                              widget.videoTipData['comment_count'] = 1;
                            } else {
                              widget.videoTipData['comment_count']++;
                            }
                            widget.videoTipComments.insert(0, res['comment']);
                          });
                        } else {
                          helperWidget.showToast(
                            'oOps an error occurred while posting comment',
                          );
                        }
                      } catch (e) {
                        print(e);
                        helperWidget.showToast(
                          'oOps an error occurred while posting comment',
                        );
                      } finally {
                        setState(() {
                          isCommenting = false;
                        });
                      }
                    },
            child:
                isCommenting
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : Text(
                      'Post',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Widget build_comment_widget(Map<String, dynamic> comment) {
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: Column(
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 // Navigator.push(ctx, CupertinoPageRoute(builder: (_) => OtherUserProfile(commentObj[constants.DB_OWNER_ID])));
  //               },
  //               child: helperWidget.buildProfilePicture(
  //                 comment[db.DB_POST_OWNER_IMG],
  //                 16,
  //               ),
  //             ),
  //             SizedBox(width: 8),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).splashColor,
  //                       // decoration: BoxDecoration(color: Color.fromRGBO(241, 242, 245, 1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             // Navigator.push(ctx, CupertinoPageRoute(builder: (_) => OtherUserProfile(commentObj[constants.DB_OWNER_ID])));
  //                           },
  //                           child: Text(
  //                             comment[db.DB_POST_OWNER_NAME],
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w400,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ),

  //                         // helperWidget.statusWidget(commentObj[constants.DB_POST_OWNER_STATUS]),
  //                         SizedBox(height: 4),

  //                         // Text(
  //                         //   comment,
  //                         //   style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
  //                         // )
  //                         SelectableLinkify(
  //                           onOpen: (link) async {
  //                             print(link.url);
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder:
  //                                     (_) => ExploreWebview(
  //                                       url: link.url,
  //                                       title: '',
  //                                     ),
  //                               ),
  //                             );
  //                           },
  //                           text: comment[db.DB_COMMENT],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w300,
  //                             fontSize: 12,
  //                           ),

  //                           // style: Theme.of(context).textTheme.headline3,
  //                           linkStyle: TextStyle(
  //                             fontWeight: FontWeight.w400,
  //                             fontSize: 14,
  //                             color: Colors.blue,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () {
  //                               if (comment[db.DB_LIKES].contains(
  //                                 getX.read(v.GETX_USER_ID),
  //                               )) {
  //                                 _unlike_video_tip_comment_func(comment);
  //                               } else {
  //                                 _like_video_tip_comment_func(comment);
  //                               }
  //                             },
  //                             child: Row(
  //                               children: [
  //                                 Text(
  //                                   "${comment[db.DB_LIKES].length}",
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.w300,
  //                                     fontSize: 12,
  //                                   ),
  //                                 ),
  //                                 comment[db.DB_LIKES].contains(
  //                                       getX.read(v.GETX_USER_ID),
  //                                     )
  //                                     ? Icon(
  //                                       Icons.favorite_rounded,
  //                                       size: 15,
  //                                       color: Colors.red,
  //                                     )
  //                                     : Icon(
  //                                       Icons.favorite_border_outlined,
  //                                       size: 15,
  //                                       color: primaryColor,
  //                                     ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(width: 8),
  //                           Row(
  //                             children: [
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   Navigator.push(
  //                                     context,
  //                                     CupertinoPageRoute(
  //                                       builder:
  //                                           (_) => VideoTipCommentReply(
  //                                             commentData: null,
  //                                             eventId:
  //                                                 widget.videoTipData['_id'],
  //                                           ),
  //                                     ),
  //                                   ).then((value) {
  //                                     // print('>>>>>>>>>>>>>>>>>>>>>>> $value ');
  //                                     // if(value!=null){
  //                                     //   dynamicCommentObj = value;
  //                                     //   check();
  //                                     //   setState(() {});
  //                                     // }
  //                                   });
  //                                 },
  //                                 child: Text(
  //                                   "• ${comment[db.DB_REPLY_COUNT]} Replies",
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.w300,
  //                                     fontSize: 12,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(width: 5),
  //                       Text(time.myTimestamp(comment["timestamp"])),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String comment = "";

  Future getMoreReplies() async {
    // print('>>>>>>>>>>>>>>>>>>>>>>> GETTING MORE COMMENTS TO ADD TO THE LIST ');
    // if (!isLoading && hasNextPage) {
    //   setState(() {
    //     isLoading = true;
    //   });

    //   pageIndex -= 1;

    //   try {
    //     dynamic response = await get_video_tips_comments(widget.video_obj["_id"], position: pageIndex);

    //     dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    //     if (decodedResponse['status'] != 'error') {
    //       print('checking this stuff >>>>>>>>>>>> ${decodedResponse}');

    //       List<dynamic> tempList = <dynamic>[];

    //       for (int i = 0; i < decodedResponse["comments"].length; i++) {
    //         tempList.add(decodedResponse["comments"][i]);
    //       }

    //       if (tempList.isNotEmpty) {
    //         setState(() {
    //           isLoading = false;
    //           comments_list.addAll(tempList);
    //         });
    //       } else {
    //         setState(() {
    //           ///This means there's no more data
    //           // print('else :: ${decodedResponse.toString()}');
    //           isLoading = false;
    //           hasNextPage = false;
    //         });
    //       }
    //     } else {
    //       setState(() {
    //         isLoading = false;
    //       });
    //     }
    //   } catch (e) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
  }

  _like_video_tip_comment_func(dynamic commentDoc) {
    // int idx = comments_list.indexOf(commentDoc);
    // // print('>>>>>>>>>>>>>>>>>>>>>>> $idx ');
    // setState(() {
    //   comments_list[idx][db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
    // });
    // like_video_tips_comment(commentDoc['_id']).then((res) {
    //   print('>>>>>>>>>>>>>>>>>>>>>>> $res ');
    //   if (res['msg'] == 'Comment Liked' || res['msg'] == 'You already liked this comment') {
    //   } else {
    //     setState(() {
    //       comments_list[idx][db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
    //     });
    //   }
    // }).catchError((e) {
    //   if (e is SocketException) {
    //     print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
    //     helperWidget.showSnackbar(context, "Check your internet connection & try again");
    //   } else {
    //     helperWidget.showSnackbar(context, "A server error occured");
    //   }
    //   setState(() {
    //     comments_list[idx][db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
    //   });
    // });
  }

  _unlike_video_tip_comment_func(dynamic commentDoc) {
    // int idx = comments_list.indexOf(commentDoc);
    // setState(() {
    //   comments_list[idx][db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
    // });
    // unlike_video_tips_comment(commentDoc['_id']).then((res) {
    //   print('>>>>>>>>>>>>>>>>>>>>>>> $res ');

    //   if (res['msg'] == 'You never liked this comment' || res['msg'] == "Comment Unliked") {
    //   } else {
    //     setState(() {
    //       comments_list[idx][db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
    //     });
    //   }
    // }).catchError((e) {
    //   if (e is SocketException) {
    //     print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
    //     helperWidget.showSnackbar(context, "Check your internet connection & try again");
    //   } else {
    //     helperWidget.showSnackbar(context, "A server error occured");
    //   }
    //   setState(() {
    //     comments_list[idx][db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
    //   });
    // });
  }
}

// class VideoTipsCommentsLikesWidget extends StatefulWidget {
//   VideoTipsCommentsLikesWidget(
//     this.comment,
//     this.parentPostID,
//     this.isComment, {
//     super.key,
//     this.isMainCommentBeenReplied = false,
//     this.commentsBeenReplied = false,
//     this.changeLikesCountCallback,
//   });

//   dynamic comment;
//   String parentPostID;
//   bool isComment = false;
//   bool isMainCommentBeenReplied;
//   bool commentsBeenReplied;
//   // bool answersBeenReplied;

//   final Function(dynamic)? changeLikesCountCallback;

//   @override
//   VideoTipsCommentsLikesWidgetState createState() =>
//       VideoTipsCommentsLikesWidgetState();
// }

// class VideoTipsCommentsLikesWidgetState
//     extends State<VideoTipsCommentsLikesWidget> {
//   List<dynamic> actualLikesList =
//       <
//         dynamic
//       >[]; //this will hold the initial state of the list before any interactions with the list via like and dislike
//   int likesCount = 0;
//   int commentCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     actualLikesList = widget.comment[db.DB_LIKES];
//     dynamicCommentObj = widget.comment;
//     check();
//   }

//   //to check if the post been liked already and store the like count
//   check() {
//     List<dynamic> tempList = dynamicCommentObj[db.DB_LIKES];
//     print('>>>>>>>>>>>>>>>>>>>>>>> $dynamicCommentObj ');
//     print('>>>>>>>>>>>>>>>>>>>>>>> ${dynamicCommentObj[db.DB_LIKES]} ');
//     print('>>>>>>>>>>>>>>>>>>>>>>>tempList $tempList');
//     if (tempList.contains(getX.read(v.GETX_USER_ID))) {
//       isLiked = true;
//     } else {
//       isLiked = false;
//     }

//     likesCount = dynamicCommentObj[db.DB_LIKE_COUNT];
//   }

//   bool isLiked = false;

//   dynamic dynamicCommentObj;

//   @override
//   Widget build(BuildContext context) {
//     // return FlutterLogo();
//     // print(widget.comment);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             buildLikeButton(),
//             const SizedBox(width: 8),
//             widget.isComment == true
//                 ? Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   CupertinoPageRoute(
//                         //     builder: (_) => CommentsReplies(parentPostID: widget.parentPostID, commentObj: dynamicCommentObj, comment: widget.comment[db.DB_COMMENT], owner_img: widget.comment[db.DB_POST_OWNER_IMG], owner_img_id: widget.comment[db.DB_POST_OWNER_IMG_ID], owner_name: widget.comment[db.DB_POST_OWNER_NAME], commentID: widget.comment["_id"], postID: widget.comment[db.DB_POST_ID]),
//                         //   ),
//                         // ).then((value) {
//                         //   print('>>>>>>>>>>>>>>>>>>>>>>> $value ');
//                         //   if (value != null) {
//                         //     dynamicCommentObj = value;
//                         //     check();
//                         //     setState(() {});
//                         //   }
//                         // });
//                       },
//                       child: Text(
//                         "• ${dynamicCommentObj[db.DB_REPLY_COUNT]} Replies",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//                 : widget.isMainCommentBeenReplied == true
//                 ? Row(
//                   children: [
//                     Text(
//                       "• ${dynamicCommentObj[db.DB_REPLY_COUNT]} Replies",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 )
//                 : const SizedBox(),
//           ],
//         ),

//         const SizedBox(width: 5),
//         Text(time.myTimestamp(widget.comment["timestamp"])),

//         // widget.isComment == true ? GestureDetector(
//         //   child: Row(
//         //     children: const [
//         //       Text("• Reply", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
//         //     ],
//         //   ),
//         //   onTap: (){
//         //     Navigator.push(
//         //       context,
//         //       CupertinoPageRoute(
//         //         builder: (_) => CommentsReplies(parentPostID: widget.parentPostID, commentObj: dynamicCommentObj, comment: widget.comment[constants.DB_POST_COMMENT], owner_img: widget.comment[constants.DB_POST_OWNER_IMG], owner_img_id: widget.comment[constants.DB_POST_OWNER_IMG_ID], owner_name: widget.comment[constants.DB_POST_OWNER_NAME], commentID: widget.comment["_id"], postID: widget.comment[constants.DB_POST_ID]),
//         //       ),
//         //     ).then((value){
//         //       print('>>>>>>>>>>>>>>>>>>>>>>> $value ');
//         //       dynamicCommentObj = value;
//         //       // print('>>>>>>>>>>>>>>>>>>>>>>> ${dynamicCommentObj[constants.DB_LIKES]} ');
//         //       check();
//         //       setState(() {});
//         //     });
//         //   },
//         // ) : SizedBox()
//       ],
//     );
//   }

//   buildLikeButton() {
//     //TO LIKE
//     if (isLiked == false) {
//       return GestureDetector(
//         onTap: () {
//           print("widget.isComment: ${widget.isComment}");
//           print(
//             "widget.isMainCommentBeenReplied: ${widget.isMainCommentBeenReplied}",
//           );
//           print("widget.commentsBeenReplied: ${widget.commentsBeenReplied}");

//           setState(() {
//             likesCount++;
//             isLiked = !isLiked;
//           });

//           // if comment, else if reply
//           if (widget.isComment == true ||
//               widget.isMainCommentBeenReplied == true) {
//             //IF ITS A LIST OF COMMENTS, AND A PARTICULAR COMMENT IS LIKED OR ITS A COMMENT THAT HAS BEEN TAPPED TO REPLY THAT IS LIKED
//             // print('>>>>>>>>>>>>>>>>>>>>>>> ${widget.comment["_id"]} ');
//             // print('>>>>>>>>>>>>>>>>>>>>>>> ${widget.comment[constants.DB_POST_ID]} ');

//             like_post_comment(widget.comment["_id"])
//                 .then((response) {
//                   print('Returned value::: $response}');
//                   //only if the like worked this should happen, so i dont send bad obj to the list
//                   print(response);
//                   if (response['msg'] == "Comment Liked") {
//                     dynamicCommentObj = response['comment'];

//                     //THIS "widget.changeLikesCountCallback" CAN BE NULL WHEN THE USER IS NOT INTERACTING WITH THIS OBJECT FROM THE REPLIES ON COMMENTS PAGE
//                     if (widget.changeLikesCountCallback != null) {
//                       widget.changeLikesCountCallback!(response['comment']);
//                     } else {
//                       //DO NOTHING
//                     }

//                     actualLikesList.add(getX.read(v.GETX_USER_ID));
//                     setState(() {});
//                   } else {
//                     helperWidget.showSnackbar(context, response['msg']);
//                     // helperWidget.showSnackbar(context, "Please check your internet connection");
//                   }
//                 })
//                 .catchError((e) {
//                   print(e);
//                   if (e is SocketException) {
//                     helperWidget.showSnackbar(
//                       context,
//                       "Check your internet connection & try again",
//                     );
//                   } else {
//                     helperWidget.showSnackbar(
//                       context,
//                       "A server error occured",
//                     );
//                   }
//                 });
//           } else if (widget.commentsBeenReplied == true) {
//             // print('>>>>>>>>>>>>>>>>>>>>>>> ${widget.comment} ');
//             // likeCommentReply(
//             //   commentID: widget.comment["_id"],
//             //   commentOwnerID: widget.comment[db.DB_COMMENT_ID],
//             //   ownerImage: getX.read(v.GETX_USER_IMAGE),
//             //   // ownerImage: getX.read(constants.GETX_USER_IMAGE),
//             //   ownerName: getX.read(v.GETX_FULLNAME),
//             // ).then((response) {
//             //   print(response);

//             //   if (response['msg'] == "Comment Liked") {
//             //     actualLikesList.add(getX.read(v.GETX_USER_ID));
//             //     setState(() {});
//             //   }
//             // });

//             like_post_comment(widget.comment["_id"])
//                 .then((response) {
//                   print('Returned value::: $response}');
//                   //only if the like worked this should happen, so i dont send bad obj to the list
//                   print(response);
//                   if (response['msg'] == "Comment Liked") {
//                     print(response);

//                     if (response['msg'] == "Comment Liked") {
//                       actualLikesList.add(getX.read(v.GETX_USER_ID));
//                       setState(() {});
//                     }
//                   } else {
//                     // helperWidget.showSnackbar(context, response['msg']);
//                   }
//                 })
//                 .catchError((e) {
//                   print(e);
//                   if (e is SocketException) {
//                     helperWidget.showSnackbar(
//                       context,
//                       "Check your internet connection & try again",
//                     );
//                   } else {
//                     helperWidget.showSnackbar(
//                       context,
//                       "A server error occured",
//                     );
//                   }
//                 });
//           } else {
//             print('>>>>>>>>>>>>>>>>>>>>>>> HMMMMMM ');
//           }
//         },
//         child: Row(
//           children: [
//             Text(
//               "$likesCount ",
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontFamily: "Poppins",
//                 fontWeight: FontWeight.w300,
//                 fontSize: 12,
//               ),
//             ),
//             Icon(Icons.favorite_border_outlined, size: 15, color: primaryColor),
//           ],
//         ),
//       );
//     }
//     //TO UNLIKE
//     else {
//       return GestureDetector(
//         onTap: () {
//           // print('>>>>>>>>>>>>>>>>>>>>>>> ${widget.comment["_id"]} ');
//           setState(() {
//             isLiked = !isLiked;
//             likesCount--;
//             //this negates the state of the button even before the actual endpoint fires
//           });

//           // if comment, else if reply
//           if (widget.isComment == true ||
//               widget.isMainCommentBeenReplied == true) {
//             //IF ITS A LIST OF COMMENTS, AND A PARTICULAR COMMENT IS UNLIKED OR ITS A COMMENT THAT HAS BEEN TAPPED TO REPLY THAT IS LIKED
//             // unlike_post_comment(widget.comment['_id']).then((response) {
//             //   print(response);
//             //   dynamicCommentObj = response['comment'];

//             //   //THIS "widget.changeLikesCountCallback" CAN BE NULL WHEN THE USER IS NOT INTERACTING WITH THIS OBJECT FROM THE REPLIES ON COMMENTS PAGE
//             //   if (widget.changeLikesCountCallback != null) {
//             //     widget.changeLikesCountCallback!(response['comment']);
//             //   } else {
//             //     //DO NOTHING
//             //   }

//             //   if (response['msg'] == "Comment Unliked") {
//             //     //if the user successfully likes the post, add userID locally to the list that originally has all the lists from the db
//             //     //and this would cause the "buildPersonsThatLikedPost" widget to be properly built to the screen
//             //     actualLikesList.remove(getX.read(v.GETX_USER_ID));
//             //     setState(() {});
//             //   }
//             // });
//           } else if (widget.commentsBeenReplied == true) {
//             //THIS IS FOR THE REPLIES OF A COMMENT
//             // unlikeCommentReply(
//             //     commentID: widget.comment['_id']
//             // ).then((response) {
//             //   print(response);
//             // //   dynamicCommentObj = response['comment'];

//             // // //THIS "widget.changeLikesCountCallback" CAN BE NULL WHEN THE USER IS NOT INTERACTING WITH THIS OBJECT FROM THE REPLIES ON COMMENTS PAGE
//             // //   if(widget.changeLikesCountCallback!=null){
//             // //     widget.changeLikesCountCallback!(response['comment']);
//             // //   }else{
//             // //     //DO NOTHING
//             // //   }

//             //   if (response['msg'] == "Comment Unliked") {
//             //     //if the user successfully likes the post, add userID locally to the list that originally has all the lists from the db
//             //     //and this would cause the "buildPersonsThatLikedPost" widget to be properly built to the screen
//             //     actualLikesList.remove(getX.read(v.GETX_USER_ID));
//             //     setState(() {});
//             //   }
//             // });
//           } else {
//             print('>>>>>>>>>>>>>>>>>>>>>>> HMMMMMM ');
//           }
//         },
//         child: Row(
//           children: [
//             Text(
//               "$likesCount ",
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontWeight: FontWeight.w300,
//                 fontSize: 12,
//               ),
//             ),
//             Icon(Icons.favorite_rounded, size: 15, color: Colors.red),
//           ],
//         ),
//       );
//     }
//   }
// }
