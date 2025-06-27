import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/daily_tip_services.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_details.dart';
import 'package:medplan/screens/health_tips/health_articles/search_health_articles.dart';
import 'package:medplan/screens/health_tips/share_medplan_story.dart';
import 'package:medplan/screens/health_tips/video_tips/search_video_tips.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tip_widgets.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips_details.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import 'health_articles/health_article.dart';

class HealthTipsControl extends StatefulWidget {
  const HealthTipsControl({super.key});

  @override
  HealthTipsControlState createState() => HealthTipsControlState();
}

class HealthTipsControlState extends State<HealthTipsControl>
     {

  @override
  initState() {
    super.initState();
    loadEndpoints();
  }

  loadEndpoints() async {
    await Future.wait<void>([
      fetchDailyTips(),
      fetchVideoTips(),
      fetchHealthArticles(),
    ]);
  }

  final DailyTipService _dailyTipService = DailyTipService();
  bool isDailyTipLoading = false;
  List<dynamic> dailyTips = [];
  fetchDailyTips() async {
    setState(() {
      isDailyTipLoading = true;
    });
    try {
      var res = await _dailyTipService.viewDailyTips();
      my_log(res);
      if (res['status'] == 'ok') {
        setState(() {
          dailyTips = res['daily_tips'] ?? [];
        });
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching daily tips",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    } finally {
      setState(() {
        isDailyTipLoading = false;
      });
    }
  }

  final VideoTipService _videoTipService = VideoTipService();
  bool isVideoTipLoading = false;
  List<dynamic> videoTips = [];
  fetchVideoTips() async {
    setState(() {
      isVideoTipLoading = true;
    });
    try {
      var res = await _videoTipService.viewVideoTips();
      if (res['status'] == 'ok') {
        setState(() {
          videoTips = res['video_tips'] ?? [];
        });
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching video tips",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    } finally {
      setState(() {
        isVideoTipLoading = false;
      });
    }
  }

  final HealthArticleService _healthArticleService = HealthArticleService();
  bool isHealthArticleLoading = false;
  List<dynamic> healthArticles = [];
  fetchHealthArticles() async {
    try {
      var res = await _healthArticleService.viewHealthArticles();
      if (res['status'] == 'ok') {
        setState(() {
          healthArticles = res['health_articles'] ?? [];
        });
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching top health article",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Health Tips",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            loadEndpoints();
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildShareMedplanStory(),
              SizedBox(height: 24.h),
              if (dailyTips.isNotEmpty)
                Text(
                  'Tips of the Day',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              if (dailyTips.isNotEmpty) SizedBox(height: 9.h),
              isDailyTipLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : dailyTips.isEmpty
                  ? SizedBox()
                  : SizedBox(
                    height: 220.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: dailyTips.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return buildTipOfTheDay(dailyTips[index]);
                      },
                    ),
                  ),
              if (dailyTips.isNotEmpty) SizedBox(height: 12.h),
              if (videoTips.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Video Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => VideoTips()));
                      },
                      child: Text(
                        'view all',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 13.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

              // SizedBox(height: 12.h),
              isVideoTipLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : videoTips.isEmpty
                  ? SizedBox()
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videoTips.length > 3 ? 3 : videoTips.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return buildVideoTipWidget(videoTips[index]);
                    },
                  ),
              if (videoTips.isNotEmpty) SizedBox(height: 12.h),

              if (healthArticles.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Blog Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HealthArticle()),
                        );
                      },
                      child: Text(
                        'view all',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 13.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              // SizedBox(height: 9.h),
              isHealthArticleLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : healthArticles.isEmpty
                  ? SizedBox()
                  : SizedBox(
                    height: 180.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount:
                          healthArticles.length > 3 ? 3 : healthArticles.length,
                      itemBuilder: (context, index) {
                        return buildTopBlogTipWidget(healthArticles[index]);
                      },
                    ),
                  ),

              SizedBox(height: 12.h),
              if ((healthArticles.length - 3) + (healthArticles.length - 3) > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More Health Tips for you',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HealthArticle()),
                        );
                      },
                      child: Text(
                        'view all',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 13.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if ((healthArticles.length - 3) + (healthArticles.length - 3) > 0)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 11.w,
                    mainAxisSpacing: 20.h,
                    childAspectRatio: 0.65,
                  ),
                  itemCount:
                      (healthArticles.length - 3).clamp(
                        0,
                        healthArticles.length - 3,
                      ) +
                      (videoTips.length - 3).clamp(0, videoTips.length - 3),
                  itemBuilder: (context, index) {
                    // Calculate the number of extra articles and videos
                    final extraArticles = (healthArticles.length - 3).clamp(
                      0,
                      healthArticles.length - 3,
                    );
                    final extraVideos = (videoTips.length - 3).clamp(
                      0,
                      videoTips.length - 3,
                    );

                    // Alternate between articles and videos
                    bool isArticle = index % 2 == 0;
                    int articleIdx = index ~/ 2;
                    int videoIdx = index ~/ 2;

                    if (isArticle && articleIdx < extraArticles) {
                      // Show extra health article
                      return buildMoreHealthTipWidget(
                        healthArticles[articleIdx + 3],
                        false,
                      );
                    } else if (!isArticle && videoIdx < extraVideos) {
                      // Show extra video tip
                      return buildMoreHealthTipWidget(
                        videoTips[videoIdx + 3],
                        true,
                      );
                    } else if (isArticle && articleIdx < extraArticles) {
                      // Fallback to article if videos run out
                      return buildMoreHealthTipWidget(
                        healthArticles[articleIdx + 3],
                        false,
                      );
                    } else if (!isArticle && videoIdx < extraVideos) {
                      // Fallback to video if articles run out
                      return buildMoreHealthTipWidget(
                        videoTips[videoIdx + 3],
                        true,
                      );
                    } else {
                      // Empty container if out of items
                      return SizedBox();
                    }
                  },
                ),
              //  [HealthArticle(), VideoTips()],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoreHealthTipWidget(var healthTipData, bool isVideoTip) {
    return InkWell(
      onTap: () {
        if (isVideoTip) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => VideoTipDetails(
                    videoTipData: healthTipData,
                    videoTipList: videoTips,
                  ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => HealthArticleDetails(
                    healthArticleData: healthTipData,
                    healthArticleList: healthArticles,
                  ),
            ),
          );
        }
      },
      child: Container(
        width: 183.w,
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.1),
          //     spreadRadius: 0,
          //     blurRadius: 1,
          //     offset: const Offset(1, 1),
          //   ),
          // ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              child: helperWidget.cachedImage(
                url: '${healthTipData['img_url']}',
                height: 119.h,
                width: 182.w,
              ),
            ),
            SizedBox(height: 11.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              child: Column(
                children: [
                  Text(
                    '${healthTipData['title']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  ReadMoreText(
                    isVideoTip
                        ? '${healthTipData['description']}'
                        : '${healthTipData['content']['English']}',
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
                  SizedBox(height: 13.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      VideoTipWidgets().buildLikeWidget(
                        itemData: healthTipData,
                        isComment: false,
                        iconSize: 18.r,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        ' ${healthTipData['comment_count'] ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Image.asset(
                        "assets/chat.png",
                        fit: BoxFit.cover,
                        height: 18.h,
                        width: 18.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }

  Widget buildTopBlogTipWidget(var healthArticleData) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => HealthArticleDetails(
                  healthArticleData: healthArticleData,
                  healthArticleList: healthArticles,
                ),
          ),
        );
      },
      child: Container(
        height: 180.h,
        width: 191.w,
        margin: EdgeInsets.only(left: 9.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey[300]!, width: 0.5.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              child: helperWidget.cachedImage(
                url: '${healthArticleData['img_url']}',
                height: 119.h,
                width: double.maxFinite,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 9.w,
                right: 9.w,
                top: 5.h,
                bottom: 15.h,
              ),
              child: Text(
                '${healthArticleData['title']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoTipWidget(var videoTipData) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => VideoTipDetails(
                  videoTipData: videoTipData,
                  videoTipList: videoTips,
                ),
          ),
        );
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 12.h),
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.1),
          //     spreadRadius: 0,
          //     blurRadius: 1,
          //     offset: const Offset(1, 1),
          //   ),
          // ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: helperWidget.cachedImage(
                    url: '${videoTipData['img_url']}',
                    height: 169.h,
                    width: 140.w,
                  ),
                ),
                Positioned(
                  bottom: 75.h,
                  left: 60.w,
                  right: 60.w,
                  child: Container(
                    height: 21.r,
                    width: 21.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.h),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 15.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 13.w),
            Expanded(
              // flex: 3,
              child: Container(
                height: 169.h,
                padding: EdgeInsets.only(
                  right: 7.w,
                  // right: 13.w,
                  top: 7.h,
                  bottom: 11.h,
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  '${videoTipData['title']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Container(
                                height: 21.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(179, 216, 250, 1),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                                child: Center(
                                  child: Text(
                                    '${videoTipData['video_duration'] ?? '00:00'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          ReadMoreText(
                            '${videoTipData['description']}',
                            trimLines: 3,
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'watch tip',
                            trimExpandedText: 'Show less',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VideoTipWidgets().buildLikeWidget(
                          itemData: videoTipData,
                          isComment: false,
                          iconSize: 18.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          ' ${videoTipData['comment_count']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Image.asset(
                          "assets/chat.png",
                          fit: BoxFit.cover,
                          height: 18.h,
                          width: 18.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 11.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTipOfTheDay(var dailyTipData) {
    return Padding(
      padding: EdgeInsets.only(right: 9.h),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(360.r),
            child: helperWidget.cachedImage(
              url: '${dailyTipData['img_url']}',
              height: 219.h,
              width: 219.w,
            ),
          ),
          Positioned(
            bottom: 15.h,
            left: 45.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDailyTipLikeWidget(dailyTipData),
                SizedBox(width: 95.w),
                buildDailyTipShareWidget(dailyTipData),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${dailyTipData['share_count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StatefulBuilder buildDailyTipShareWidget(dailyTipData) {
    bool isSharing = false;
    return StatefulBuilder(
      builder: (context, setCustomState) {
        return Column(
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
                          var res = await DailyTipService()
                              .incDailyTipShareCount(dailyTipData['_id']);

                          if (res['status'] == 'ok') {
                            setState(() {
                              if (dailyTipData['share_count'] == null) {
                                dailyTipData['share_count'] = 1;
                              } else {
                                dailyTipData['share_count']++;
                              }
                            });
                            Share.share(
                              'Your health is your greatest asset. Take charge of it today! 💪\nDownload the MedPlan app now to stay consistent with your medications and become more informed about your health\n\n${dailyTipData['img_url']}',
                            );
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
                  isSharing
                      ? CupertinoActivityIndicator()
                      : Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 20.r,
                      ),
            ),
            Text(
              '${dailyTipData['share_count'] ?? 0}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  StatefulBuilder buildDailyTipLikeWidget(dailyTipData) {
    bool isLiked =
        dailyTipData['likes'] == null
            ? false
            : dailyTipData['likes'].contains(getX.read(v.GETX_USER_ID));
    return StatefulBuilder(
      builder: (context, setCustomState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                try {
                  setCustomState(() {
                    isLiked = !isLiked;
                    if (isLiked) {
                      dailyTipData['like_count']++;
                      dailyTipData['likes'].add(getX.read(v.GETX_USER_ID));
                    } else {
                      dailyTipData['like_count']--;
                      dailyTipData['likes'].remove(getX.read(v.GETX_USER_ID));
                    }
                  });
                  var res = await DailyTipService().likeDailyTip(
                    dailyTipData['_id'],
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
                isLiked ? Icons.favorite : Icons.favorite_outline,
                color:
                    isLiked == true
                        ? Color.fromRGBO(242, 10, 10, 1)
                        : Colors.white,
                size: 20.r,
              ),
            ),
            Text(
              '${dailyTipData['like_count'] ?? 0}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  bool closeMedplanStoryWidget = false;

  Widget buildShareMedplanStory() {
    return closeMedplanStoryWidget
        ? SizedBox()
        : Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 242, 222, 1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getX.read(v.GETX_USER_IMAGE) == ''
                      ? myWidgets.noProfileImage(40.r)
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(360.r),
                        child: helperWidget.cachedImage(
                          url: '${getX.read(v.GETX_USER_IMAGE)}',
                          height: 40.r,
                          width: 40.r,
                        ),
                      ),
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share your MedPlan Story',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          'Hi ${getX.read(v.GETX_USERNAME ?? 'User')}, we would like to know how MedPlan has impacted your health journey',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 11.sp),
                  InkWell(
                    onTap: () {
                      setState(() {
                        closeMedplanStoryWidget = true;
                      });
                    },
                    child: Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 12.sp),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ShareMedplanStory()),
                    );
                  },
                  child: Text(
                    'Share Story >>',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
