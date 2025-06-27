import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/api/reply_comment_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_articles_comment_replies.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:readmore/readmore.dart';

import 'health_article_details.dart';

class HealthArticleWidgets {
  Widget buildHealthArticleWidget(
    BuildContext context,
    var healthArticleData,
    List<dynamic> healthArticleList, {
    Function()? refresh,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (_) => HealthArticleDetails(
                      healthArticleData: healthArticleData,
                      healthArticleList: healthArticleList,
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
        width: double.maxFinite,
        padding: EdgeInsets.all(7.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: helperWidget.cachedImage(
                  url: '${healthArticleData['img_url']}',

                  height: 126.h,
                  width: null,
                ),
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 126.h,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${healthArticleData['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ReadMoreText(
                      '${healthArticleData['content']['English']}',
                      trimLines: 3,
                      colorClickableText: Colors.blue,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Read more',
                      trimExpandedText: 'Show less',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildLikeWidget(
                          itemData: healthArticleData,
                          isComment: false,
                          iconSize: 20.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '${healthArticleData['comment_count'] ?? 0}',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Image.asset(
                          "assets/chat.png",
                          fit: BoxFit.cover,
                          height: 20.r,
                          width: 20.r,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder buildLikeWidget({
    required var itemData,
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
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.sp),
            ),
            SizedBox(width: 3.w),
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
                          ? await HealthArticleService().likeHealthArticle(
                            healthArticleId: itemData['_id'],
                          )
                          : isReply == false
                          ? await HealthArticleService()
                              .likeHealthArticleComment(
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
            height: 32.h,
            width: 32.w,
          ),
        ),
         SizedBox(width: 9.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 0.5,
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${commentData['owner_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '${commentData['comment']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 4.h),
              Row(
                children: [
                  // Text(
                  //   '${commentData['like_count']}',
                  //   style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                  // ),
                  // SizedBox(width: 2),
                  // Icon(
                  //   Icons.favorite,
                  //   color: Color.fromRGBO(242, 10, 10, 1),
                  //   size: 16,
                  // ),
                  buildLikeWidget(
                    iconSize: 16.r,
                    itemData: commentData,
                    isComment: true,
                    isReply: isReply,
                  ),

                  if (!isReply) SizedBox(width: 5.w),
                  if (!isReply)
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (_) => HealthArticleCommentReply(
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
                          fontSize: 12.sp,
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
}
