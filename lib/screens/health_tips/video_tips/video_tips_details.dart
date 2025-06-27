// youtube_player_flutter: ^8.0.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips_comments.dart';
import 'package:medplan/screens/video_player.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'video_tip_widgets.dart';

class VideoTipDetails extends StatefulWidget {
  List<dynamic> videoTipList = <dynamic>[];
  var videoTipData;
  VideoTipDetails({
    super.key,
    required this.videoTipData,
    required this.videoTipList,
  });

  @override
  State<VideoTipDetails> createState() => _VideoTipDetailsState();
}

class _VideoTipDetailsState extends State<VideoTipDetails> {
  final VideoTipService _videoTipService = VideoTipService();
  bool isSharing = false;
  bool isCommenting = false;

  final TextEditingController _commentController = TextEditingController();

  List<dynamic> videoTipComments = [];
  bool loadComment = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadComments();
    () {
      double coinAmount = 0.5;
      increaseMedplanCoin(coinAmount);
    }();
  }

  loadComments() async {
    setState(() {
      loadComment = true;
    });
    try {
      var res = await _videoTipService.viewVideoTipComments(
        videoTipId: widget.videoTipData['_id'],
      );
      if (res['status'] == 'ok') {
        setState(() {
          videoTipComments = res['comments'];
          videoTipComments = videoTipComments.reversed.toList();
        });
      } else {
        helperWidget.showToast(
          'oOps an error occurred while fetching comments',
        );
      }
    } catch (e) {
      print(e);

      helperWidget.showToast('oOps an error occurred while fetching comments');
    } finally {
      setState(() {
        loadComment = false;
      });
    }
  }

  String extract_videoID_from_url(String url) {
    // "https://youtu.be/rMMpeLLgdgY"
    // "https://m.youtube.com/watch?v=rMMpeLLgdgY"
    print('-----------------> $url ');
    String videoId;
    if (url.contains(".be/")) {
      videoId = url.split(".be/")[1];
      return videoId;
    } else if (url.contains("?v=")) {
      videoId = url.split("?v=")[1];
      return videoId;
    } else {
      return "null";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, ''),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  // debugPrint(
                  //   '----------> ${widget.videoTipData['video_url']} ',
                  // );

                  String title = widget.videoTipData['title'];
                  String videoUrl = widget.videoTipData['video_url'];

                  String videoId = extract_videoID_from_url(videoUrl);
                  if (videoId == "null") {
                    helperWidget.showToast("Invalid video url");
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoPlayer(title, videoUrl, videoId),
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: helperWidget.cachedImage(
                    url: '${widget.videoTipData['img_url']}',
                    height: 210,
                    width: double.maxFinite,
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 5,
                child: VideoTipWidgets().buildDurationWidget(
                  context,
                  '${widget.videoTipData['video_duration'] ?? "00:00"}',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '${widget.videoTipData['title']}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 4),
          build_sub_widget(),
          const SizedBox(height: 10),
          helperWidget.build_divider(),

          build_action_buttons(),
          helperWidget.build_divider(),
          SizedBox(height: 16.h),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 10),

          Text(
            '${widget.videoTipData['description']}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
          const SizedBox(height: 10),

          helperWidget.build_divider(),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${widget.videoTipData['comment_count'] ?? 0})',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              if (videoTipComments.length > 1)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder:
                                (_) => VideoTipsComments(
                                  videoTipData: widget.videoTipData,
                                  videoTipComments: videoTipComments,
                                ),
                          ),
                        )
                        .then((val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {});
                        });
                  },
                  child: Text(
                    'View more',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          loadComment
              ? const Center(child: CupertinoActivityIndicator())
              : videoTipComments.isEmpty
              ? const Center(
                child: Text(
                  'No comments yet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    videoTipComments.length > 3 ? 3 : videoTipComments.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },

                itemBuilder: (context, index) {
                  return VideoTipWidgets().buildCommentWidget(
                    context: context,
                    commentData: videoTipComments[index],
                    eventId: widget.videoTipData['_id'],
                    refresh: () => setState(() {}),
                  );
                },
              ),
          const SizedBox(height: 30),
          Row(
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
                            helperWidget.showToast(
                              'Comment field must be filled',
                            );

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
                                if (widget.videoTipData['comment_count'] ==
                                    null) {
                                  widget.videoTipData['comment_count'] = 1;
                                } else {
                                  widget.videoTipData['comment_count']++;
                                }
                                videoTipComments.insert(0, res['comment']);
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

          const SizedBox(height: 35),
          if ((widget.videoTipList.length - 1) != 0)
            const Text(
              'More Video Tips',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          const SizedBox(height: 16),
          ...List.generate(
            (widget.videoTipList.length > 5 ? 5 : widget.videoTipList.length),
            (idx) {
              if (widget.videoTipList[idx]['_id'] ==
                  widget.videoTipData['_id']) {
                return const SizedBox.shrink();
              }
              return VideoTipWidgets().buildVideoTipsWidget(
                context,
                widget.videoTipList[idx],
                widget.videoTipList,
                refresh: () => setState(() {}),
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Row build_action_buttons() {
    bool isLiked =
        widget.videoTipData['likes'] == null
            ? false
            : widget.videoTipData['likes'].contains(getX.read(v.GETX_USER_ID));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () async {
            try {
              setState(() {
                isLiked = !isLiked;
                if (isLiked) {
                  widget.videoTipData['like_count']++;
                  widget.videoTipData['likes'].add(getX.read(v.GETX_USER_ID));
                } else {
                  widget.videoTipData['like_count']--;
                  widget.videoTipData['likes'].remove(
                    getX.read(v.GETX_USER_ID),
                  );
                }
              });
              var res = await VideoTipService().likeVideoTip(
                videoTipId: widget.videoTipData['_id'],
              );
              my_log(res);
              if (res['status'] != 'ok') {
                setState(() {
                  isLiked = !isLiked;
                });
              }
            } catch (e) {
              setState(() {
                isLiked = !isLiked;
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.favorite,
              //   color: Color.fromRGBO(242, 10, 10, 1),
              //   size: 22,
              // ),
              Icon(
                Icons.favorite,
                color:
                    isLiked == true
                        ? Color.fromRGBO(242, 10, 10, 1)
                        : Colors.grey,
                size: 22,
              ),
              Text(
                'Like',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: greyTextColor,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/comment.png",
                fit: BoxFit.cover,
                height: 17,
                width: 17,
              ),
              Text(
                'Comment',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: greyTextColor,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed:
              isSharing
                  ? null
                  : () async {
                    setState(() {
                      isSharing = true;
                    });
                    try {
                      var res = await _videoTipService.incVideoTipshareCount(
                        videoTipId: widget.videoTipData['_id'],
                      );

                      if (res['status'] == 'ok') {
                        setState(() {
                          if (widget.videoTipData['share_count'] == null) {
                            widget.videoTipData['share_count'] = 1;
                          } else {
                            widget.videoTipData['share_count']++;
                          }
                        });
                        // Share.share(
                        //   '${widget.videoTipData['title']}\n\n${widget.videoTipData['content'][selectedLanguage]}',
                        // );
                      } else {
                        helperWidget.showToast('oOps something went wrong');
                      }
                    } catch (e) {
                      print(e);
                      helperWidget.showToast('oOps something went wrong');
                    } finally {
                      setState(() {
                        isSharing = false;
                      });
                    }
                  },
          child:
              isSharing == true
                  ? CupertinoActivityIndicator()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap:
                            isSharing
                                ? null
                                : () async {
                                  setState(() {
                                    isSharing = true;
                                  });
                                  try {
                                    var res = await _videoTipService
                                        .incVideoTipshareCount(
                                          videoTipId:
                                              widget.videoTipData['_id'],
                                        );

                                    if (res['status'] == 'ok') {
                                      setState(() {
                                        if (widget
                                                .videoTipData['share_count'] ==
                                            null) {
                                          widget.videoTipData['share_count'] =
                                              1;
                                        } else {
                                          widget.videoTipData['share_count']++;
                                        }
                                      });
                                      Share.share(
                                        '${widget.videoTipData['title']}\n\n${widget.videoTipData['description']}',
                                      );
                                    } else {
                                      helperWidget.showToast(
                                        'oOps something went wrong',
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                    helperWidget.showToast(
                                      'oOps something went wrong',
                                    );
                                  } finally {
                                    setState(() {
                                      isSharing = false;
                                    });
                                  }
                                },
                        child:
                            isSharing
                                ? CupertinoActivityIndicator()
                                : Image.asset(
                                  "assets/share.png",
                                  fit: BoxFit.cover,
                                  height: 20,
                                  width: 20,
                                ),
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: greyTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }

  Row build_sub_widget() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${widget.videoTipData['view_count'] ?? 0} view${pluralize(widget.videoTipData['view_count'] ?? 0)}, ${time.myTimestamp(widget.videoTipData['timestamp'] ?? 0)}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
          ),
        ),
        VideoTipWidgets().buildLikeWidget(
          itemData: widget.videoTipData,
          textColor: null,
          iconSize: 12,
          isComment: true,
        ),
        // Text(
        //   '${widget.videoTipData['like_count']}',
        //   style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        // ),

        // const Icon(
        //   Icons.favorite,
        //   color: Color.fromRGBO(242, 10, 10, 1),
        //   size: 14,
        // ),
        const SizedBox(width: 10),
        Text(
          '${widget.videoTipData['comment_count']}',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        const SizedBox(width: 1),
        Image.asset(
          "assets/comment.png",
          fit: BoxFit.cover,
          height: 12,
          width: 12,
        ),
        const SizedBox(width: 10),
        Text(
          '${widget.videoTipData['share_count']}',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        const SizedBox(width: 3),
        Image.asset(
          "assets/share.png",
          fit: BoxFit.cover,
          height: 10,
          width: 10,
        ),
      ],
    );
  }
}

// class VideoPlayer extends StatefulWidget {
//   Map<String, dynamic> video;
//   VideoPlayer(this.video, {Key? key}) : super(key: key);

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   late YoutubePlayerController _controller;
//   @override
//   void initState() {
//     // print('------video--||--------->${widget.video} ');
//     total_comments_count = widget.video[db.DB_COMMENT_COUNT];

//     if (widget.video["_id"].isNotEmpty) {
//       increase_video_tip_views(widget.video["_id"]).then((resp) {
//         if (resp['msg'] == "Successful") {
//           setState(() {
//             views_count++;
//           });
//         }
//       });
//     }
//     get_video_tips_comments(widget.video["_id"]).then((res) {
//       print('---comments-----||--------->$res ');

//       if (res['msg'] == "Success") {
//         comments_list = res['comments'];
//       }
//     });
//     get_video_tips().then((res) {
//       // print('-----videos---||--------->$res ');
//       if (res['msg'] == "Successful") {
//         sub_list = res['videotips'];
//         sub_list.shuffle();
//         setState(() {});
//       }
//     });

// //for youtube
//     String video_id = extract_videoID_from_url(widget.video[db.DB_VIDEO_URL]);
//     if (video_id == "null") {
//       helperWidget.showSnackbar(context, "Invalid youtube url");
//       Navigator.pop(context);
//     } else {
//       _controller = YoutubePlayerController(
//         initialVideoId: video_id,
//         flags: YoutubePlayerFlags(autoPlay: false, mute: false, controlsVisibleAtStart: true),
//       );
//     }
//     super.initState();
//   }

//   List<dynamic> sub_list = [];
//   List<dynamic> comments_list = [];
//   // int comments_position = 0;
//   late int total_comments_count;

//   int views_count = 0;
//   String extract_videoID_from_url(String url) {
//     // "https://youtu.be/rMMpeLLgdgY"
//     // "https://m.youtube.com/watch?v=rMMpeLLgdgY"
//     print('-----------------> $url ');
//     String video_id;
//     if (url.contains(".be/")) {
//       video_id = url.split(".be/")[1];
//       return video_id;
//     } else if (url.contains("?v=")) {
//       video_id = url.split("?v=")[1];
//       return video_id;
//     } else {
//       return "null";
//     }
//   }

// // Note that this method assumes that the URL is a valid YouTube video URL and
// //contains a v= parameter. It may not work for other types of URLs
// //or if the URL format changes in the future.
//   String extractVideoIdFromYoutubeApp(String url) {
//     print('----------VIDEO_ID ------->  $url');
//     RegExp regExp = new RegExp(r'(?<=v=)[a-zA-Z0-9_-]+(?=&|\?)');
//     String? match = regExp.stringMatch(url);
//     return match ?? '';
//   }

//   @override
//   void dispose() {
//     _controller.dispose();

//     // Change the screen orientation back to portrait mode
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp
//     ]);
//     super.dispose();
//   }

//   Future<bool> _confirmExit() {
//     Navigator.pop(context, views_count);
//     return Future.value(true);
//     // print('---------||tapped--------> ');
//     // get_video_tips_comments(widget.video["_id"]).then((res) {
//     //   print('---comments-----||--------->$res ');

//     //   if (res['msg'] == "Success") {
//     //     comments_list = res['comments'];
//     //   }
//     // });
//     // return Future.value(false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screen_width = MediaQuery.of(context).size.width;

//     return WillPopScope(
//       onWillPop: _confirmExit,
//       child: Scaffold(
//         appBar: MediaQuery.of(context).orientation == Orientation.landscape ? null : helperWidget.myAppBar(context, "Video Tips"),
//         backgroundColor: darkNotifier.value ? Colors.black : Colors.white,
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   // Padding(
//                   //   padding: EdgeInsets.fromLTRB(10, 5, 10.0, 5),
//                   //   child: Material(
//                   //     // shadowColor: Colors.red,
//                   //     shadowColor: Theme.of(context).shadowColor,
//                   //     elevation: 0.5,
//                   //     borderRadius: BorderRadius.circular(8),
//                   //     child: ListTile(
//                   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   //       tileColor: Theme.of(context).shadowColor,
//                   //       dense: true,
//                   //       title: Text(widget.title),
//                   //       trailing: Image.asset(
//                   //         "./assets/video.png",
//                   //         height: 25,
//                   //         width: 25,
//                   //         color: darkNotifier.value ? Colors.white : Colors.black,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   // SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: YoutubePlayer(
//                       controller: _controller,
//                       showVideoProgressIndicator: true,
//                       //remove the bottomActions if you want the icon to control the speed to show
//                       bottomActions: [
//                         CurrentPosition(),
//                         ProgressBar(
//                           isExpanded: true,
//                         ),
//                         RemainingDuration(),
//                         FullScreenButton(),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.video[db.DB_TITLE],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("$views_count ${views_count > 1 ? "views" : "view"}, ${time.myTimestamp(widget.video[db.DB_TIMESTAMP])}", style: TextStyle(fontSize: 12)),
//                             Row(
//                               children: [
//                                 SizedBox(width: 6),
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (widget.video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))) {
//                                       _unlike_video_tip_func(widget.video['_id']);
//                                     } else {
//                                       _like_video_tip_func(widget.video['_id']);
//                                     }
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Text("${widget.video[db.DB_LIKES].length}"),
//                                       widget.video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))
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
//                                 GestureDetector(
//                                   onTap: () {
//                                     print('-----------------> ${widget.video} ');
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => VideoTipsComments(widget.video, comments_list, total_comments_count ~/ 10),
//                                       ),
//                                     );
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Text("${widget.video[db.DB_COMMENT_COUNT]}"),
//                                       SizedBox(width: 1),
//                                       SvgPicture.asset(
//                                         "./assets/comment.svg",
//                                         height: 14.5,
//                                         width: 14.5,
//                                         color: Colors.grey,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 20),
//                                 InkWell(
//                                   child: SvgPicture.asset(
//                                     "./assets/share.svg",
//                                     height: 14.5,
//                                     width: 14.5,
//                                     color: darkNotifier.value ? Colors.grey : Colors.black87,
//                                   ),
//                                   onTap: () {
//                                     // print('-----------------> ${widget.video}');
//                                     Share.share("${widget.video[db.DB_TITLE]}\n${widget.video["description"]}\n\nShared from medPlan app");

//                                     // Share.share("${widget.video[db.DB_TITLE]}\n${widget.video["body"]}\n\nShared from medPlan app");
//                                   },
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         Divider(),
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   if (widget.video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))) {
//                                     _unlike_video_tip_func(widget.video['_id']);
//                                   } else {
//                                     _like_video_tip_func(widget.video['_id']);
//                                   }
//                                 },
//                                 child: Column(
//                                   children: [
//                                     // Icon(
//                                     //   Icons.favorite_outline,
//                                     //   color: Colors.grey,
//                                     //   size: 22,
//                                     // ),
//                                     widget.video[db.DB_LIKES].contains(getX.read(v.GETX_USER_ID))
//                                         ? Icon(Icons.favorite_rounded, size: 22, color: Colors.red)
//                                         : Icon(
//                                             Icons.favorite_border_outlined,
//                                             size: 22,
//                                             color: Colors.grey,
//                                           ),
//                                     Text("Like")
//                                   ],
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   print('-----------------> ${widget.video} ');
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => VideoTipsComments(
//                                         widget.video,
//                                         comments_list,
//                                         total_comments_count ~/ 10,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Column(
//                                   children: [
//                                     SvgPicture.asset(
//                                       "./assets/comment.svg",
//                                       height: 20,
//                                       width: 20,
//                                       color: Colors.grey,
//                                     ),
//                                     Text("Comment")
//                                   ],
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                         share_to_external(title: widget.video[db.DB_TITLE],body: widget.video[db.DB_DESC]);

//                                   // Share.share("${widget.video[db.DB_TITLE]}\n${widget.video[db.DB_DESC]}\n\nShared from medPlan app");
//                                 },
//                                 child: Column(
//                                   children: [
//                                     SvgPicture.asset(
//                                       "./assets/share.svg",
//                                       height: 20,
//                                       width: 20,
//                                       color: Colors.grey,
//                                     ),
//                                     Text("Share")
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         GestureDetector(
//                           onTap: () {
//                             print('-----------------> $comments_list ');
//                           },
//                           child: Text(
//                             "Description",
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(widget.video[db.DB_DESC]),
//                         Divider(),
//                       ],
//                     ),
//                   ),
//                   comments_list.isEmpty
//                       ? SizedBox()
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Comments  $total_comments_count",
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // print('----------------->${comments_list[0]} ');
//                                       Navigator.of(context).push(CupertinoPageRoute(builder: (_) => VideoTipsComments(widget.video, comments_list, total_comments_count ~/ 10)));
//                                     },
//                                     child: Text("see all"),
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 6,
//                               ),
//                               Row(
//                                 children: [
//                                   helperWidget.buildProfilePicture("${comments_list[0][db.DB_POST_OWNER_IMG]}", 16),
//                                   SizedBox(
//                                     width: 6,
//                                   ),
//                                   Expanded(
//                                     child: Text(comments_list[0][db.DB_COMMENT]),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                   sub_list.isNotEmpty
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 6.0),
//                               child: Text(
//                                 "Other Video Tips",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Container(
//                               // color: Colors.red,
//                               height: 250,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: sub_list.length,
//                                 physics: BouncingScrollPhysics(),
//                                 itemBuilder: (BuildContext context, int index) {
//                                   if (widget.video["_id"] == sub_list[index]["_id"]) {
//                                     return SizedBox();
//                                   } else {
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) => VideoPlayer(
//                                               sub_list[index],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: SizedBox(
//                                           width: screen_width - 20,
//                                           child: BuildVideoTipWidget(
//                                             sub_list[index],
//                                           ),
//                                         ),
//                                       ),
//                                       // child: BuildHealthTipsWidget(healthTip: healthTipsList[index], screen_width: screen_width),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                           ],
//                         )
//                       : SizedBox(),
//                 ],
//               ),
//             ),
//             MediaQuery.of(context).orientation == Orientation.landscape
//                 ? SizedBox()
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                     child: Row(
//                       children: [
//                         // myWidgets.buildProfilePicture("${getX.read(v.GETX_USER_IMAGE)}", 16),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               // color: Color.fromRGBO(241, 242, 245, 1),
//                               color: Theme.of(context).shadowColor,
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                             child: TextField(
//                               controller: textEditingController,
//                               textCapitalization: TextCapitalization.sentences,
//                               keyboardType: TextInputType.multiline,
//                               onChanged: (val) {
//                                 comment = val;
//                               },
//                               minLines: 1,
//                               maxLines: 4,
//                               // style: const TextStyle(color: Colors.black),
//                               decoration: const InputDecoration(
//                                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 border: InputBorder.none,
//                                 isDense: true,
//                                 hintText: "Type your comment here...",
//                                 hintStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w300, color: Color.fromRGBO(102, 103, 107, 1), fontSize: 13),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         GestureDetector(
//                           onTap: () {
//                             _post_video_tip_comment_func();
//                           },
//                           child: sending
//                               ? SizedBox(
//                                   height: 24,
//                                   width: 24,
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation(primaryColor),
//                                   ))
//                               : Text("Post", style: TextStyle(fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.w300, color: primaryColor)),
//                         )
//                       ],
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool sending = false;
//   TextEditingController textEditingController = TextEditingController();
//   String comment = "";

//   _post_video_tip_comment_func() {
//     if (comment.isNotEmpty) {
//       setState(() {
//         sending = true;
//       });
//       comment_on_video_tip(
//         widget.video['_id'],
//         comment,
//       ).then((res) {
//         print('Returned value::: $res}');
//         if (res["msg"] == "Comment Sent") {
//           textEditingController.clear();
//           comment = '';
//           setState(() {
//             comments_list.insert(0, res['comment']);
//             // ++widget.health_tips_doc[db.DB_COMMENT_COUNT];
//             total_comments_count++;
//             sending = false;
//           });
//         } else {
//           helperWidget.showSnackbar(context, "An error occured");
//           setState(() {
//             sending = false;
//           });
//         }
//       }).catchError(
//         (e) {
//           print(e);
//           if (e is SocketException) {
//             helperWidget.showSnackbar(context, "Check your internet connection & try again");
//           } else {
//             helperWidget.showSnackbar(context, "A server error occured");
//           }
//           setState(() {
//             sending = false;
//           });
//         },
//       );
//     }
//   }

//   _like_video_tip_func(String videotip_id) {
//     print('-----------------> ${widget.video[db.DB_LIKES]} ');
//     setState(() {
//       widget.video[db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
//     });
//     like_video_tips(videotip_id).then((res) {
//       if (res['status'] == 'ok') {
//       } else {
//         if (res['msg'] == "You already liked this post") {
//           helperWidget.showSnackbar(context,  res['msg']);
//         } else {
//           helperWidget.showSnackbar(context,  "An unknown error occured");
//         }
//         setState(() {
//           widget.video[db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
//         });
//       }
//     }).catchError((e) {
//       print('----------------->$e ');
//       if (e is SocketException) {
//         // print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
//         helperWidget.showSnackbar(context,  "Check your internet connection & try again");
//       } else {
//         helperWidget.showSnackbar(context,  "A server error occured");
//       }
//       setState(() {
//         widget.video[db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
//       });
//     });
//   }

//   _unlike_video_tip_func(String videotip_id) {
//     print('-----------------> ${widget.video[db.DB_LIKES]} ');

//     setState(() {
//       widget.video[db.DB_LIKES].remove(getX.read(v.GETX_USER_ID));
//     });
//     unlike_video_tips(videotip_id).then((res) {
//       if (res['status'] == 'ok') {
//       } else {
//         if (res['msg'] == "You never liked this post") {
//           helperWidget.showSnackbar(context,  res['msg']);
//         } else {
//           helperWidget.showSnackbar(context,  "An unknown error occured");
//         }
//         setState(() {
//           widget.video[db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
//         });
//       }
//     }).catchError((e) {
//       if (e is SocketException) {
//         print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
//         helperWidget.showSnackbar(context,  "Check your internet connection & try again");
//       } else {
//         helperWidget.showSnackbar(context,  "A server error occured");
//       }
//       setState(() {
//         widget.video[db.DB_LIKES].add(getX.read(v.GETX_USER_ID));
//       });
//     });
//   }
// }
