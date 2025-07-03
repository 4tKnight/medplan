import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medplan/api/companion_service.dart';
import 'package:medplan/api/notification_service.dart';
import 'package:medplan/helper_widget/loading_widgets.dart';
import 'package:medplan/screens/bottom_control/bottom_nav_bar.dart';
import 'package:medplan/utils/functions.dart';
import 'package:readmore/readmore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medplan/utils/global.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool read_more = false;
  Future<dynamic>? _futureData;
  List<dynamic> returnedNotifications = <dynamic>[];

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _futureData = _notificationService.viewNotifications();
  }

  loadFuture() {
    final cachedData = getX.read(v.CACHED_NOTIFICATIONS);
    if (cachedData != null) {
      _futureData = Future.value(cachedData);
      fetchAndUpdateCache();
    } else {
      _futureData =
          _notificationService.viewNotifications()..then((data) {
            if (data != null) {
              getX.write(v.CACHED_NOTIFICATIONS, data);
            }
          });
    }
  }

  void fetchAndUpdateCache() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.viewNotifications().then((updatedData) async {
        var currentData = await _futureData;
        if (updatedData != null &&
            jsonEncode(updatedData) != jsonEncode(currentData)) {
          my_log('updating cache');
          getX.write(v.CACHED_NOTIFICATIONS, updatedData);
          setState(() {
            _futureData = Future.value(updatedData);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Notifications', isBack: true),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: FutureBuilder<dynamic>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const SizedBox();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return const SizedBox();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    //BUILD LOADING WIDGET
                    // return Center(
                    //   child: CircularProgressIndicator(),
                    // );
                    return buildLoadingNotifications();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      //THIS WIDGET WILL SHOW ALSO IF THERE IS NO INTERNET CONNECTION

                      return helperWidget.noInternetScreen(() {
                        setState(() {
                          _futureData =
                              _notificationService.viewNotifications();
                        });
                      });
                    } else if (snapshot.hasData) {
                      print('>>>>>>>>>>>>>>>>>>>>>>> ${snapshot.data} ');

                      if (snapshot.data['status'] == 'ok') {
                        returnedNotifications = snapshot.data['notifications'];
                        print(
                          '>>>>>>>>>>>>>>>>>>>>>>> $returnedNotifications ',
                        );

                        // print(snapshot.data);
                        if (returnedNotifications.isEmpty) {
                          return emptyNotification();
                        } else {
                          return ListView.separated(
                            itemCount: returnedNotifications.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0.0, 20),
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                  right: 8,
                                  left: 8,
                                ),
                                height: 0.8,
                                width: double.maxFinite,
                                color: Colors.grey,
                              );
                            },
                            itemBuilder: (context, idx) {
                              return displayNotificationWidget(
                                notificationData: returnedNotifications[idx],
                                prevNotificationTimestamp:
                                    idx > 0
                                        ? returnedNotifications[idx -
                                            1]['timestamp']
                                        : 0,
                              );
                            },
                          );
                        }
                      } else {
                        return helperWidget.errorScreen(() {
                          setState(() {
                            _futureData =
                                _notificationService.viewNotifications();
                          });
                        });
                      }
                    } else {
                      return helperWidget.errorScreen(() {
                        setState(() {
                          _futureData =
                              _notificationService.viewNotifications();
                        });
                      });
                    }
                  } else {
                    //BUILD LOADING WIDGET
                    return helperWidget.errorScreen(() {
                      setState(() {
                        _futureData = _notificationService.viewNotifications();
                      });
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyNotification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "./assets/no_notification.png",
            height: 136.h,
            width: 130.w,
          ),
          SizedBox(height: 15.h),
          Text(
            "You have no notifications at this time.",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void deleteNotificationEndpoint(String notificationId) async {
    try {
      var res = await _notificationService.deleteNotification(
        notificationId: notificationId,
      );
      if (res['status'] == 'ok') {
        helperWidget.showToast("Notification deleted successfully");
        setState(() {
          _futureData = _notificationService.viewNotifications();
        });
      } else {
        helperWidget.showToast("Oops! Something went wrong.");
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    }
  }

  Widget displayNotificationWidget({
    dynamic notificationData,
    required int prevNotificationTimestamp,
  }) {
    return GestureDetector(
      onLongPress: () {
        // helperWidget.showToast("Swipe left to delete");

        // deleteNotificationDialogue(title: "Delete Notification", content: "Are you sure you want to delete this notification?", notiData: notificationData, notiID: notificationData['_id']);
      },
      onTap: () {
        // cheer_post, cheer_comment, cheer_reply, post_comment, reply_comment, new_conv, cheer_conv, cheer_conv_message, join_request, accept_join_request, decline_join_request, make_group_admin, group_invite

        if (notificationData["noti_type"] == "follow") {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ViewProfile(
          //       userID: notificationData["from_id"],
          //     ),
          //   ),
          // );
        } else if (notificationData['noti_type'] == 'group_msg' ||
            notificationData['noti_type'] == 'react_message' ||
            notificationData['noti_type'] == 'make_group_admin' ||
            notificationData['noti_type'] == 'accept_invite_request' ||
            notificationData['noti_type'] == 'accept_join_request') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => Inside_A_Channel(
          //       group_id: notificationData['group_id'],
          //     ),
          //   ),
          // );
        } else if (notificationData['noti_type'] == 'post' ||
            notificationData['noti_type'] == 'post_comment' ||
            notificationData['noti_type'] == 'cheer_post' ||
            notificationData['noti_type'] == 'cheer_comment') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => ViewPostFromNotification(
          //       // groupsUserIsAdmin: groupsUserIsAdmin,
          //       postID: notificationData['post_id'],
          //     ),
          //   ),
          // );
        } else if (notificationData['noti_type'] == 'job_share') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => ViewJobPage(
          //       pharmsjobID: notificationData['post_id'],
          //     ),
          //   ),
          // );
        } else if (notificationData['noti_type'] == 'group_invite') {
          print('>>>>>>>>>>>>>>>>>>>>>>> $notificationData ');

          // groupInvitationDialogue(
          //   notificationData: notificationData,
          //   inviterID: notificationData['from_id'],
          // );
          // getSingleGroup(groupID: notificationData['group_id']).then((res) {
          //   print(res);
          //   if (res['status'] == 'ok') {
          //     groupInvitationDialogue(groupData: res['group'], inviterID: notificationData['from_id'], notificationData: notificationData);
          //   } else {
          //     helperWidget.showToast("an error occured");
          //   }
          // });
        }
        //*not yet confirmed this
        else if (notificationData['noti_type'] == 'join_request') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => JoinGroupPending(
          //       groupID: notificationData['group_id'],
          //     ),
          //   ),
          // );
        }
        //*have no clue what will trigger this
        else if (notificationData['noti_type'] == 'cheer_reply' ||
            notificationData['noti_type'] == 'reply_comment') {
          // navigatorKey.currentState!.push(
          //   MaterialPageRoute(
          //     builder: (_) => ViewPostFromNotification(
          //       userImage: userImage,
          //       groupsUserIsAdmin: groupsUserIsAdmin,
          //       postID: noti_payload['post_id'],
          //     ),
          //   ),
          // );
        } else {
          // group_invite
          // decline_join_request
          // new_conv
          // cheer_conv_message
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        }

        //!old checks
        // if (notificationData['noti_type'] == 'new_conv') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewGroupConvoFromNotification(
        //                 userImage: userImage,
        //                 convoID: notificationData['gconv_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'cheer_post') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewPostFromNotification(
        //                 postID: notificationData['post_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'cheer_comment') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewPostFromNotification(
        //                 postID: notificationData['post_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'post_comment') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewPostFromNotification(
        //                 postID: notificationData['post_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'cheer_conv') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewGroupConvoFromNotification(
        //                 userImage: userImage,
        //                 convoID: notificationData['gconv_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'cheer_conv_message') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewGroupConvoFromNotification(
        //                 userImage: userImage,
        //                 convoID: notificationData['gconv_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'join_request') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => JoinGroupPending(
        //                 groupID: notificationData['group_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'accept_join_request') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => InsideGroupPageFromNotification(
        //                 groupID: notificationData['group_id'],
        //                 isAdmin: false,
        //               )));
        // } else if (notificationData['noti_type'] == 'make_group_admin') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => InsideGroupPageFromNotification(
        //                 groupID: notificationData['group_id'],
        //                 isAdmin: false,
        //               )));
        // } else if (notificationData['noti_type'] == 'group_invite') {
        //   getSingleGroup(groupID: notificationData['group_id']).then((res) {
        //     print(res);
        //     if (res['status'] == 'ok') {
        //       groupInvitationDialogue(groupData: res['group'], inviterID: notificationData['from_id'], notificationData: notificationData);
        //     } else {
        //       helperWidget.showToast("an error occured");
        //     }
        //   });
        // } else if (notificationData['noti_type'] == 'job_share') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewJobPage(
        //                 pharmsjobID: notificationData['post_id'],
        //               )));
        // } else if (notificationData['noti_type'] == 'follow') {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ViewProfile(
        //                 userID: notificationData['from_id'],
        //               )));
        // }
      },
      child: Slidable(
        closeOnScroll: false,
        endActionPane: ActionPane(
          extentRatio: 0.2,
          // openThreshold: 0.3,
          // closeThreshold: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // flex: 2,
              padding: const EdgeInsets.symmetric(vertical: 5),
              backgroundColor: Colors.red,
              // foregroundColor: Colors.white,
              icon: Icons.delete_outline_outlined,
              autoClose: true,
              // label: 'Delete',
              onPressed: (BuildContext context) {
                deleteNotificationEndpoint(notificationData['_id']);
              },
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigator.push(context, CupertinoPageRoute(builder: (_) => ViewProfile(userID: notificationData['from_id'])));
                  //   },
                  //   child: SizedBox(
                  //     height: 45,
                  //     width: 45,
                  //     child: Image.asset("./assets/calories.png"),
                  //   ),
                  //   // child: helperWidget.buildProfilePicture(
                  //   //     "${notificationData['from_img']}", 18)),
                  // ),
                  // const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReadMoreText(
                          '${notificationData["message"]}',
                          trimLines: 2,
                          colorClickableText: Theme.of(context).primaryColor,
                          trimMode: TrimMode.Line,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            time.myTimestamp(notificationData["timestamp"]),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (notificationData['event'] == 'companion request')
                          buildCompanionRequestButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompanionRequestButtons() {
    bool isAccepting = false;
    bool isDeclining = false;
    CompanionService companionService = CompanionService();
    return StatefulBuilder(
      builder: (context, setCustomState) {
        return Row(
          children: [
            TextButton(
              onPressed:
                  isAccepting || isDeclining
                      ? null
                      : () async {
                        setCustomState(() {
                          isAccepting = true;
                        });
                        try {
                          var res = await companionService.companionRequest(
                            true,
                          );
                          if (res['message'] == 'success') {
                            helperWidget.showToast(
                              "Companion request accepted successfully",
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => BottomNavBar(),
                              ),
                              (route) => false,
                            );
                          } else {
                            helperWidget.showToast(
                              "oOps an error occurred. Try again later",
                            );
                          }
                        } catch (e) {
                          helperWidget.showToast(
                            "oOps an error occurred. Try again later",
                          );
                        } finally {
                          setCustomState(() {
                            isAccepting = false;
                          });
                        }
                      },
              child:
                  isAccepting
                      ? CupertinoActivityIndicator(
                        color: Color.fromRGBO(43, 193, 40, 1),
                      )
                      : Text(
                        'Accept',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color.fromRGBO(43, 193, 40, 1),
                        ),
                      ),
            ),
            SizedBox(width: 15.w),
            TextButton(
              onPressed:
                  isAccepting || isDeclining
                      ? null
                      : () async {
                        setCustomState(() {
                          isDeclining = true;
                        });
                        try {
                          var res = await companionService.companionRequest(
                            true,
                          );
                          if (res['message'] == 'success') {
                            helperWidget.showToast(
                              "Companion request declined successfully",
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => BottomNavBar(),
                              ),
                              (route) => false,
                            );
                          } else {
                            helperWidget.showToast(
                              "oOps an error occurred. Try again later",
                            );
                          }
                        } catch (e) {
                          helperWidget.showToast(
                            "oOps an error occurred. Try again later",
                          );
                        } finally {
                          setCustomState(() {
                            isDeclining = false;
                          });
                        }
                      },
              child:
                  isDeclining
                      ? CupertinoActivityIndicator(
                        color: Color.fromRGBO(43, 193, 40, 1),
                      )
                      : Text(
                        'Decline',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color.fromRGBO(242, 10, 10, 1),
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  // Future<dynamic> groupInvitationDialogue({
  //   required String inviterID,
  //   required Map<String, dynamic> notificationData,
  // }) {
  //   bool loader = false;

  //   String groupName;
  //   String temp = notificationData["message"];
  //   groupName = temp.split("their group")[1];

  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setCustomState) {
  //           return AlertDialog(
  //             title: Text(
  //               'Invitation to Join Group',
  //               style: TextStyle(
  //                 color: darkNotifier.value ? Colors.white : Colors.black,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Group name: $groupName',
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     // Row(
  //                     //   children: [
  //                     //     Text('About',
  //                     //         style: TextStyle(
  //                     //           fontSize: 14,
  //                     //           fontWeight: FontWeight.w400,
  //                     //         ),),
  //                     //     SizedBox(
  //                     //       width: 10,
  //                     //     ),
  //                     //     Text('(${notificationData['members_count']} ',
  //                     //         style: TextStyle(
  //                     //           fontSize: 12,
  //                     //           fontWeight: FontWeight.w300,
  //                     //         )),
  //                     //     Icon(
  //                     //       Icons.groups_outlined,
  //                     //       size: 20,
  //                     //     ),
  //                     //     Text(' )',
  //                     //         style: TextStyle(
  //                     //           fontSize: 12,
  //                     //           fontWeight: FontWeight.w300,
  //                     //         )),
  //                     //   ],
  //                     // ),
  //                     Text(
  //                       'About: ${notificationData['comment']}',
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         delete_notification(notificationData);
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         height: 40.0,
  //                         width: 110,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(4.0),
  //                           color:
  //                               darkNotifier.value
  //                                   ? Colors.grey[800]
  //                                   : Colors.white,
  //                           border: Border.all(
  //                             color:
  //                                 darkNotifier.value
  //                                     ? Colors.white
  //                                     : Colors.black,
  //                             // width: 5,
  //                           ),
  //                         ),
  //                         child: const Text(
  //                           'Decline',
  //                           style: TextStyle(
  //                             // color: Theme.of(context).primaryColor,
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const Spacer(),
  //                     GestureDetector(
  //                       onTap: () {
  //                         setCustomState(() {
  //                           loader = true;
  //                         });
  //                         // acceptGroupInvite(
  //                         //         groupID: notificationData['group_id'],
  //                         //         inviterID: inviterID)
  //                         //     .then((res) {
  //                         //   print(res);
  //                         //   if (res['status'] == 'ok') {
  //                         //     setCustomState(() {
  //                         //       loader = false;
  //                         //     });
  //                         //     add_channelID_to_getX(notificationData['group_id']);
  //                         //     Navigator.pop(context);
  //                         //     delete_notification(notificationData);
  //                         //   } else if (res["msg"] ==
  //                         //       "you already accepted this invite request") {
  //                         //     helperWidget.showToast(
  //                         //         "You already accepted this invite request");
  //                         //     setCustomState(() {
  //                         //       loader = false;
  //                         //     });
  //                         //   } else {
  //                         //     setCustomState(() {
  //                         //       loader = false;
  //                         //     });
  //                         //     helperWidget.showToast("An error occured");
  //                         //   }
  //                         // });
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         height: 40.0,
  //                         width: 110,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(4.0),
  //                           color: Theme.of(context).primaryColor,
  //                         ),
  //                         child:
  //                             loader
  //                                 ? const SizedBox(
  //                                   height: 20,
  //                                   width: 20,
  //                                   child: CircularProgressIndicator(
  //                                     color: Colors.white,
  //                                   ),
  //                                 )
  //                                 : const Text(
  //                                   'Accept',
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 14,
  //                                   ),
  //                                 ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<dynamic> deleteNotificationDialogue({
  //   required dynamic notiData,
  //   required String notiID,
  //   required String title,
  //   required String content,
  // }) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           title,
  //           style: TextStyle(
  //             color: Theme.of(context).primaryColor,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 16,
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               content,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w300,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     // setState(() {
  //                     //   isAvailableForWork = true;
  //                     // });
  //                     Navigator.pop(context);
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: 40.0,
  //                     width: 69,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(4.0),
  //                       color: darkNotifier.value ? Colors.black : Colors.white,
  //                       border: Border.all(
  //                         color: Theme.of(context).primaryColor,
  //                         // width: 5,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       'No',
  //                       style: TextStyle(
  //                         color: Theme.of(context).primaryColor,
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // Spacer(),
  //                 GestureDetector(
  //                   onTap: () {
  //                     // deleteNotification(notiID: notiID).then((res) {
  //                     //   if (res['status'] == 'ok') {
  //                     //     returnedNotifications.remove(notiData);

  //                     //     Navigator.pop(context);
  //                     //     setState(() {});
  //                     //   } else {
  //                     //     helperWidget.showToast(res['msg']);
  //                     //     Navigator.pop(context);
  //                     //   }
  //                     // });
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: 40.0,
  //                     width: 69,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(4.0),
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                     child: Text(
  //                       'Yes',
  //                       style: TextStyle(
  //                         color:
  //                             darkNotifier.value ? Colors.black : Colors.white,
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
