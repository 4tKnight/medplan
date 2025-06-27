import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_comment.dart';
import 'package:medplan/utils/functions.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/global.dart';
import 'health_article_widgets.dart';

class HealthArticleDetails extends StatefulWidget {
  List<dynamic> healthArticleList = <dynamic>[];
  var healthArticleData;
  HealthArticleDetails({
    super.key,
    required this.healthArticleData,
    required this.healthArticleList,
  });

  @override
  State<HealthArticleDetails> createState() => _HealthArticleDetailsState();
}

class _HealthArticleDetailsState extends State<HealthArticleDetails> {
  String selectedLanguage = 'English';
  final HealthArticleService _healthArticleService = HealthArticleService();
  bool isSharing = false;
  bool isCommenting = false;

  final TextEditingController _commentController = TextEditingController();

  List<dynamic> articleComments = [];
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
      var res = await _healthArticleService.viewHealthArticleComments(
        healthArticleId: widget.healthArticleData['_id'],
      );
      if (res['status'] == 'ok') {
        setState(() {
          articleComments = res['comments'];
          articleComments = articleComments.reversed.toList();
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Material(
              child: Stack(
                children: [
                  helperWidget.cachedImage(
                    url: '${widget.healthArticleData['img_url']}',
                    height: MediaQuery.of(context).size.height * 0.5 + 50.h,
                    width: null,
                  ),
                  bottomDetailsSheet(screenWidth),
                  Positioned(
                    top: 35,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: GestureDetector(
                        child: Icon(
                          Icons.chevron_left,
                          size: 30.r,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 45,
                    child: myWidgets.buildChangeLanguageWidget(
                      '${widget.healthArticleData['title']}\n\n${widget.healthArticleData['content'][selectedLanguage]}',
                      selectedLanguage,
                      (lang) {
                        setState(() {
                          selectedLanguage = lang;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomDetailsSheet(var screenWidth) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: .6,
      maxChildSize: .8,
      // snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: ListView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5.h),
            children: [
              Text(
                '${widget.healthArticleData['title']}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
              ),
              SizedBox(height: 9.h),
              Row(
                children: [
                  HealthArticleWidgets().buildLikeWidget(
                    itemData: widget.healthArticleData,
                    isComment: false,
                    iconSize: 18.r,
                  ),

                  SizedBox(width: 14.w),
                  Text(
                    '${widget.healthArticleData['comment_count'] ?? 0}',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                  SizedBox(width: 3.w),
                  Image.asset(
                    "assets/comment.png",
                    fit: BoxFit.fill,
                    height: 14,
                    width: 14,
                  ),
                  SizedBox(width: 25.w),
                  Text(
                    '${widget.healthArticleData['share_count'] ?? 0}',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                  const SizedBox(width: 3),
                  InkWell(
                    onTap:
                        isSharing
                            ? null
                            : () async {
                              setState(() {
                                isSharing = true;
                              });
                              try {
                                var res = await _healthArticleService
                                    .incHealthArticleShareCount(
                                      healthArticleId:
                                          widget.healthArticleData['_id'],
                                    );

                                if (res['status'] == 'ok') {
                                  setState(() {
                                    if (widget
                                            .healthArticleData['share_count'] ==
                                        null) {
                                      widget.healthArticleData['share_count'] =
                                          1;
                                    } else {
                                      widget.healthArticleData['share_count']++;
                                    }
                                  });
                                  Share.share(
                                    '${widget.healthArticleData['title']}\n\n${widget.healthArticleData['content'][selectedLanguage]}',
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
                              height: 15,
                              width: 15,
                            ),
                  ),
                ],
              ),
              SizedBox(height: 17.h),
              Text(
                '${widget.healthArticleData['content'][selectedLanguage]}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments (${widget.healthArticleData['comment_count'] ?? 0})',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (articleComments.length > 1)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (_) => HealthArticleComments(
                                      healthArticleData:
                                          widget.healthArticleData,
                                      healthArticleComments: articleComments,
                                    ),
                              ),
                            )
                            .then((val) {
                              setState(() {});
                            });
                      },
                      child: Text(
                        'View more',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
              // const SizedBox(height: 20),
              loadComment
                  ? const Center(child: CupertinoActivityIndicator())
                  : articleComments.isEmpty
                  ? Center(
                    child: Text(
                      'No comments yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        articleComments.length > 3 ? 3 : articleComments.length,
                    padding: EdgeInsets.zero,

                    itemBuilder: (context, index) {
                      return HealthArticleWidgets().buildCommentWidget(
                        context: context,
                        commentData: articleComments[index],
                        eventId: widget.healthArticleData['_id'],
                        refresh: () => setState(() {}),
                      );
                    },
                  ),
              SizedBox(height: 31.h),
              buildPostCommentWidget(context),
              SizedBox(height: 35.h),
              if ((widget.healthArticleList.length - 1) != 0)
                Text(
                  'More Health Articles',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              const SizedBox(height: 10),
              ...List.generate(
                (widget.healthArticleList.length > 5
                    ? 5
                    : widget.healthArticleList.length),
                (idx) {
                  if (widget.healthArticleList[idx]['_id'] ==
                      widget.healthArticleData['_id']) {
                    return const SizedBox.shrink(); // Skip the item with matching _id
                  }
                  return HealthArticleWidgets().buildHealthArticleWidget(
                    context,
                    widget.healthArticleList[idx],
                    widget.healthArticleList,
                    refresh: () => setState(() {}),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Row buildPostCommentWidget(BuildContext context) {
    return Row(
      children: [
        getX.read(v.GETX_USER_IMAGE) == ''
            ? myWidgets.noProfileImage(30)
            : ClipRRect(
              borderRadius: BorderRadius.circular(360),
              child: helperWidget.cachedImage(
                url: '${getX.read(v.GETX_USER_IMAGE)}',
                height: 29.r,
                width: 29.r,
              ),
            ),
        SizedBox(width: 5.w),
        Expanded(
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
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
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              // minLines: 1,
              // maxLines: 4,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                border: InputBorder.none,
                hintText: 'Type your comment here...',

                hintStyle: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  fontSize: 14.sp,
                ),
              ),
              // textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
        SizedBox(width: 6.w),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.r),
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
                      var res = await _healthArticleService
                          .commentHealthArticle(
                            healthArticleId: widget.healthArticleData['_id'],
                            comment: _commentController.text,
                          );
                      if (res['status'] == 'ok') {
                        setState(() {
                          _commentController.clear();
                          if (widget.healthArticleData['comment_count'] ==
                              null) {
                            widget.healthArticleData['comment_count'] = 1;
                          } else {
                            widget.healthArticleData['comment_count']++;
                          }
                          articleComments.insert(0, res['comment']);
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
                      fontSize: 14.sp,
                    ),
                  ),
        ),
      ],
    );
  }
}
