import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/utils/global.dart';

import 'video_tip_widgets.dart';

class VideoTips extends StatefulWidget {
  const VideoTips({super.key});

  @override
  VideoTipsState createState() => VideoTipsState();
}

class VideoTipsState extends State<VideoTips> {
  List<dynamic> videoTipList = <dynamic>[];

  Future<dynamic>? futureData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadFuture();
  }

  final VideoTipService _videoTipService = VideoTipService();

  void loadFuture() {
    futureData = _videoTipService.viewVideoTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Video Tips', isBack: true),

      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return helperWidget.noInternetScreen(() {
              setState(() {
                loadFuture();
              });
            });
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No video tip at the moment'));
          } else {
            if (snapshot.data['count'] > 0) {
              videoTipList = snapshot.data['video_tips'];
            }
            return videoTipList.isEmpty
                ? Center(child: Text('No video tip at the moment'))
                : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  itemCount: videoTipList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15.h);
                  },
                  itemBuilder: (context, index) {
                    return VideoTipWidgets().buildVideoTipsWidget(
                      context,
                      videoTipList[index],
                      videoTipList,
                      refresh: () => setState(() {}),
                    );
                  },
                );
          }
        },
      ),
    );
  }

  // Widget build_video_tile(Map<String, dynamic> video) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6.0),
  //     child: StatefulBuilder(builder: (context, setCustomState) {
  //       return SizedBox(
  //         height: 220,
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (_) => VideoPlayer(
  //                   video,
  //                 ),
  //               ),
  //             ).then((value) {
  //               // print('---------in--------> $value');

  //               if (value != null) {
  //                 video[db.DB_VIEWS_COUNT] = value;
  //                 setState(() {});
  //               }
  //             });
  //           },
  //           child: Material(
  //             borderRadius: BorderRadius.circular(8),
  //             color: Theme.of(context).cardColor,
  //             elevation: 0.5,
  //             shadowColor: Theme.of(context).cardColor,
  //             child: Column(
  //               children: [
  //                 Expanded(
  //                   child: Container(
  //                     width: double.infinity,
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(8),
  //                         topRight: Radius.circular(8),
  //                       ),
  //                       child: CachedNetworkImage(
  //                         imageUrl: video[db.DB_VIDEO_THUMB_IMG],
  //                         fit: BoxFit.cover,
  //                         placeholder: (context, url) => const SkeletonItem(
  //                           child: SkeletonAvatar(style: SkeletonAvatarStyle(width: double.maxFinite, height: 120)),
  //                         ),
  //                         errorWidget: (context, url, error) => Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Icon(Icons.error, size: 150),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 50,
  //                   decoration: BoxDecoration(
  //                     color: Theme.of(context).cardColor,
  //                     borderRadius: BorderRadius.only(
  //                       bottomLeft: Radius.circular(8),
  //                       bottomRight: Radius.circular(8),
  //                     ),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SizedBox(height: 1.5),
  //                         Text(
  //                           video[db.DB_TITLE],
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //                         ),
  //                         SizedBox(height: 5),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             // Text("${time.dateFromTimestamp(video[db.DB_TIMESTAMP])}", style: TextStyle(fontSize: 10)),
  //                             Text("${video[db.DB_VIEWS_COUNT]} ${video[db.DB_VIEWS_COUNT] > 1 ? "views" : "view"}, ${time.myTimestamp(video[db.DB_TIMESTAMP])}", style: TextStyle(fontSize: 10)),
  //                             Row(
  //                               children: [
  //                                 SizedBox(width: 6),
  //                                 GestureDetector(
  //                                   onTap: () {
  //                                     print('----------------->${video['_id']}');
  //                                     if (video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))) {
  //                                       // print('-----------------> in');

  //                                       unlike_video_tips(video['_id']).then((res) {
  //                                         if (res['msg'] == 'Unliked') {
  //                                           video[db.DB_LIKE_COUNT] -= 1;
  //                                           setCustomState(() {});
  //                                         } else {
  //                                           if (res['msg'] == "You never liked this post") {
  //                                             helperWidget.showSnackbar(context, res['msg']);
  //                                           } else {
  //                                             helperWidget.showSnackbar(context, "An unknown error occured");
  //                                           }
  //                                         }
  //                                       }).catchError((e) {
  //                                         if (e is SocketException) {
  //                                           // print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
  //                                           helperWidget.showSnackbar(context, "Check your internet connection & try again");
  //                                         } else {
  //                                           helperWidget.showSnackbar(context, "A server error occured");
  //                                         }
  //                                       });
  //                                     } else {
  //                                       print('-----------------> innnnnn');
  //                                       like_video_tips(video['_id']).then((res) {
  //                                         print('-----------------> $res');
  //                                         // print('-----------------> $video');
  //                                         if (res['msg'] == 'Liked') {
  //                                           video[db.DB_LIKE_COUNT] += 1;
  //                                           setCustomState(() {});
  //                                         } else {
  //                                           if (res['msg'] == "You already liked this post") {
  //                                             helperWidget.showSnackbar(context, res['msg']);
  //                                           } else {
  //                                             helperWidget.showSnackbar(context, "An unknown error occured");
  //                                           }
  //                                         }
  //                                       }).catchError((e) {
  //                                         print('----------------->$e ');
  //                                         if (e is SocketException) {
  //                                           // print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
  //                                           helperWidget.showSnackbar(context, "Check your internet connection & try again");
  //                                         } else {
  //                                           helperWidget.showSnackbar(context, "A server error occured");
  //                                         }
  //                                       });
  //                                     }
  //                                   },
  //                                   child: Row(
  //                                     children: [
  //                                       Text("${video[db.DB_LIKES].length}"),
  //                                       video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))
  //                                           ? Icon(Icons.favorite_rounded, size: 15, color: Colors.red)
  //                                           : Icon(
  //                                               Icons.favorite_border_outlined,
  //                                               size: 15,
  //                                               color: Colors.grey,
  //                                             )
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 20),
  //                                 Row(
  //                                   children: [
  //                                     Text("${video[db.DB_COMMENT_COUNT]}"),
  //                                     SizedBox(width: 1),
  //                                     SvgPicture.asset(
  //                                       "./assets/comment.svg",
  //                                       height: 14.5,
  //                                       width: 14.5,
  //                                       color: Colors.grey,
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(width: 20),
  //                                 PopupMenuButton(
  //                                   child: SvgPicture.asset(
  //                                     "./assets/share.svg",
  //                                     height: 14.5,
  //                                     width: 14.5,
  //                                     color: darkNotifier.value ? Colors.grey : Colors.black87,
  //                                   ),
  //                                   onSelected: (int selectedItem) {
  //                                     print(selectedItem);
  //                                     // Navigator.push(context,
  //                                     //     CupertinoPageRoute(builder: (_) => Share()));

  //                                     if (selectedItem == 1) {
  //                                       // print("delete");
  //                                       // showDeleteDialog();
  //                                       // Share.share("${video[db.DB_TITLE]}\n${video[db.DB_DESC]}\n\nShared from medPlan app");
  //                                       share_to_external(title: video[db.DB_TITLE], body: video[db.DB_DESC]);
  //                                     } else {
  //                                       // Navigator.push(
  //                                       //   context,
  //                                       //   CupertinoPageRoute(
  //                                       //     builder: (_) => ShareHealthTips(
  //                                       //       health_tips_data: video,
  //                                       //     ),
  //                                       //   ),
  //                                       // );
  //                                     }
  //                                   },
  //                                   itemBuilder: (BuildContext context) {
  //                                     return [
  //                                       PopupMenuItem(
  //                                         value: 0,
  //                                         child: Row(
  //                                           children: [
  //                                             const Icon(Icons.share, size: 15),
  //                                             const SizedBox(width: 4),
  //                                             Text("Share to Feed"),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       PopupMenuItem(
  //                                         value: 1,
  //                                         child: Row(
  //                                           children: [
  //                                             const Icon(Icons.share, size: 15),
  //                                             const SizedBox(width: 4),
  //                                             Text("Share to others"),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ];
  //                                   },
  //                                 ),
  //                               ],
  //                             )

  //                             // Row(
  //                             //   mainAxisSize: MainAxisSize.min,
  //                             //   children: [
  //                             //     SizedBox(width: 6),
  //                             //     GestureDetector(
  //                             //       onTap: () {
  //                             //         // if (video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))) {
  //                             //         //   _unlike_health_tip_func(video['_id']);
  //                             //         // } else {
  //                             //         //   _like_health_tip_func(video['_id']);
  //                             //         // }
  //                             //       },
  //                             //       child: Row(
  //                             //         children: [
  //                             //           Text(
  //                             //             "3",
  //                             //             style: TextStyle(fontSize: 10),
  //                             //           ),
  //                             //           // Text("${video[db.DB_LIKES].length}"),
  //                             //           // video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))
  //                             //           // ? Icon(Icons.favorite_rounded, size: 15, color: Colors.red)
  //                             //           // :
  //                             //           Icon(
  //                             //             Icons.favorite_border_outlined,
  //                             //             size: 15,
  //                             //             color: Colors.grey,
  //                             //           )
  //                             //         ],
  //                             //       ),
  //                             //     ),
  //                             //     SizedBox(width: 16),
  //                             //     GestureDetector(
  //                             //       onTap: () {
  //                             //         // Navigator.push(
  //                             //         //   context,
  //                             //         //   MaterialPageRoute(
  //                             //         //     builder: (_) => HealthTipsComments(
  //                             //         //       health_tips_doc: video,
  //                             //         //     ),
  //                             //         //   ),
  //                             //         // );
  //                             //       },
  //                             //       child: Row(
  //                             //         children: [
  //                             //           Text(
  //                             //             "6",
  //                             //             style: TextStyle(fontSize: 10),
  //                             //           ),
  //                             //           // Text("${video[db.DB_COMMENT_COUNT]}"),
  //                             //           SizedBox(width: 1),
  //                             //           SvgPicture.asset(
  //                             //             "./assets/comment.svg",
  //                             //             height: 14.5,
  //                             //             width: 14.5,
  //                             //             color: Colors.grey,
  //                             //           ),
  //                             //         ],
  //                             //       ),
  //                             //     ),
  //                             //     SizedBox(width: 16),
  //                             //     // GestureDetector(
  //                             //     //   onTap: (){

  //                             //     //   },
  //                             //     //   child: Icon(Icons.share, color: primaryColor, size: 16),
  //                             //     // )

  //                             //     PopupMenuButton(
  //                             //       child: SvgPicture.asset(
  //                             //         "./assets/share.svg",
  //                             //         height: 14.5,
  //                             //         width: 14.5,
  //                             //         color: darkNotifier.value ? Colors.grey : Colors.black87,
  //                             //       ),
  //                             //       onSelected: (int selectedItem) {
  //                             //         print(selectedItem);
  //                             //         // Navigator.push(context,
  //                             //         //     CupertinoPageRoute(builder: (_) => Share()));

  //                             //         if (selectedItem == 1) {
  //                             //           // print("delete");
  //                             //           // showDeleteDialog();
  //                             //           Share.share("${video[db.DB_TITLE]}\n${video["body"]}\n\nShared from medPlan app");
  //                             //         } else {
  //                             //           // Navigator.push(
  //                             //           //   context,
  //                             //           //   CupertinoPageRoute(
  //                             //           //     builder: (_) => ShareHealthTips(
  //                             //           //       health_tips_data: video,
  //                             //           //     ),
  //                             //           //   ),
  //                             //           // );
  //                             //         }
  //                             //       },
  //                             //       itemBuilder: (BuildContext context) {
  //                             //         return [
  //                             //           PopupMenuItem(
  //                             //             value: 0,
  //                             //             child: Row(
  //                             //               children: [
  //                             //                 const Icon(Icons.share, size: 15),
  //                             //                 const SizedBox(width: 4),
  //                             //                 Text("Share to Feed"),
  //                             //               ],
  //                             //             ),
  //                             //           ),
  //                             //           PopupMenuItem(
  //                             //             value: 1,
  //                             //             child: Row(
  //                             //               children: [
  //                             //                 const Icon(Icons.share, size: 15),
  //                             //                 const SizedBox(width: 4),
  //                             //                 Text("Share to others"),
  //                             //               ],
  //                             //             ),
  //                             //           ),
  //                             //         ];
  //                             //       },
  //                             //     ),
  //                             //   ],
  //                             // )
  //                           ],
  //                         ),
  //                       ],
  //                     ),

  //                     //  Row(
  //                     //   children: [
  //                     //     Expanded(
  //                     //       child:
  //                     //     ),
  //                     //     SizedBox(width: 6),
  //                     //     GestureDetector(
  //                     //       onTap: () {
  //                     //         Share.share("${video[db.DB_VIDEO_URL]}");
  //                     //       },
  //                     //       child: Padding(
  //                     //         padding: const EdgeInsets.only(right: 8.0),
  //                     //         child: SvgPicture.asset(
  //                     //           "./assets/share.svg",
  //                     //           height: 20,
  //                     //           width: 20,
  //                     //           color: darkNotifier.value ? Colors.white : Colors.black,
  //                     //         ),
  //                     //       ),
  //                     //     )
  //                     //   ],
  //                     // ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }
}
