import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/reply_comment_service.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips_comments_replies.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import 'video_tips_details.dart';

class VideoTipWidgets {
  Widget buildVideoTipsWidget(
    BuildContext context,
    var videoTipData,
    List<dynamic> videoTipList, {
    Function()? refresh,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (_) => VideoTipDetails(
                      videoTipData: videoTipData,
                      videoTipList: videoTipList,
                    ),
              ),
            )
            .then((value) {
              if (refresh != null) {
                refresh();
              }
            });
      },
      child: Container(
        height: 210.h,
        width: double.maxFinite,
        // padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(1, 1), // Shadow only at bottom right
            ),
          ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: helperWidget.cachedImage(
                url: '${videoTipData['img_url']}',
                height: 210.h,
                width: double.maxFinite,
              ),
            ),

            Positioned(
              top: 9.h,
              right: 7.w,
              child: buildDurationWidget(
                context,
                "${videoTipData['video_duration'] ?? '00:00'}",
              ),
            ),
            Positioned(
              bottom: 6.h,
              left: 6.w,
              right: 6.w,
              child: buildDescriptionWidget(context, videoTipData),
            ),
            Center(child: buildPlayWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildDescriptionWidget(BuildContext context, var videoTipData) {
    return Container(
      // width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 9.h,
        bottom: 7.5,
        right: 7.5.w,
        left: 12.5.w,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(22, 22, 22, 0.6),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${videoTipData['title']}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  // '2 views, 5 months ago',
                  '${videoTipData['view_count'] ?? 0} view${pluralize(videoTipData['view_count'] ?? 0)}, ${time.myTimestamp(videoTipData['timestamp'] ?? 0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              buildLikeWidget(
                itemData: videoTipData,
                textColor: Colors.white,
                iconSize: 18.r,
                isComment: true,
              ),
              // Text(
              //   '${videoTipData['like_count']}',
              //   style: TextStyle(
              //     fontWeight: FontWeight.w300,
              //     fontSize: 12,
              //     color: Colors.white,
              //   ),
              // ),
              // const Icon(
              //   Icons.favorite,
              //   color: Color.fromRGBO(242, 10, 10, 1),
              //   size: 16,
              // ),
              SizedBox(width: 10.w),
              Text(
                '${videoTipData['comment_count']}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 2.w),
              Image.asset(
                "assets/comment.png",
                fit: BoxFit.cover,
                color: Colors.white,
                height: 12.r,
                width: 12.r,
              ),
              SizedBox(width: 10.w),
              Text(
                '${videoTipData['share_count']}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 2.w),
              Image.asset(
                "assets/share.png",
                fit: BoxFit.cover,
                color: Colors.white,
                height: 12.r,
                width: 12.r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  StatefulBuilder buildLikeWidget({
    var itemData,
    Color? textColor,
    required double iconSize,
    required bool isComment,
    bool isReply = false,
  }) {
    bool isLiked =
        itemData['likes'] == null
            ? false
            : itemData['likes'].contains(getX.read(v.GETX_USER_ID));

    return StatefulBuilder(
      builder: (context, setCustomState) {
        return Row(
          children: [
            Text(
              '${itemData['like_count'] ?? 0}',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: textColor,
              ),
            ),
            InkWell(
              onTap: () async {
                try {
                  setCustomState(() {
                    isLiked = !isLiked;
                    if (isLiked) {
                      itemData['like_count']++;
                      itemData['likes'].add(getX.read(v.GETX_USER_ID));
                    } else {
                      itemData['like_count']--;
                      itemData['likes'].remove(getX.read(v.GETX_USER_ID));
                    }
                  });
                  var res =
                      isComment == false
                          ? await VideoTipService().likeVideoTip(
                            videoTipId: itemData['_id'],
                          )
                          : isReply == false
                          ? await VideoTipService().likeVideoTipComment(
                            commentId: itemData['_id'],
                          )
                          : await ReplyCommentService().togglelikeCommentReply(
                            commentReplyId: itemData['_id'],
                          );
                  my_log(res);
                  if (res['status'] != 'ok') {
                    setCustomState(() {
                      isLiked = !isLiked;
                    });
                  }
                } catch (e) {
                  setCustomState(() {
                    isLiked = !isLiked;
                  });
                }
              },
              child: Icon(
                Icons.favorite,
                color:
                    isLiked == true
                        ? Color.fromRGBO(242, 10, 10, 1)
                        : Colors.grey,
                size: iconSize,
              ),
            ),
          ],
        );
      },
    );
  }

  Row buildCommentWidget({
    required BuildContext context,
    required var commentData,
    required String eventId,
    required Function() refresh,
    bool isReply = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(360),
          child: helperWidget.cachedImage(
            url: '${commentData['owner_img_url']}',
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${commentData['owner_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${commentData['comment']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  buildLikeWidget(
                    iconSize: 16,
                    itemData: commentData,
                    textColor: null,
                    isComment: true,
                    isReply: isReply,
                  ),
                  if (!isReply) SizedBox(width: 10),
                  if (!isReply)
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (_) => VideoTipCommentReply(
                                      commentData: commentData,
                                      eventId: eventId,
                                    ),
                              ),
                            )
                            .then((val) {
                              refresh();
                            });
                      },
                      child: Text(
                        '• ${commentData['reply_count']} ${commentData['reply_count'] == 1 ? "Reply" : "Replies"}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildDurationWidget(BuildContext context, String videoTipDuration) {
    return Row(
      children: [
        Container(
          height: 21.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Center(
            child: Text(
              videoTipDuration,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildPlayWidget() {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.play_arrow, color: Colors.white, size: 15),
      ),
    );
  }
}
