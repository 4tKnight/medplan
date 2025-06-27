import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:medplan/api/reply_comment_service.dart';
import 'package:medplan/main.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_widgets.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import '../../../server/health_tips_api_requests.dart';

class HealthArticleCommentReply extends StatefulWidget {
  dynamic commentData;
  String eventId;
  HealthArticleCommentReply({
    super.key,
    required this.commentData,
    required this.eventId,
  });

  @override
  _HealthArticleCommentReplyState createState() =>
      _HealthArticleCommentReplyState();
}

class _HealthArticleCommentReplyState extends State<HealthArticleCommentReply> {
  final TextEditingController _commentController = TextEditingController();

  bool isReplying = false;

  Future<dynamic>? fetchReplies;
  List<dynamic> repliesList = <dynamic>[];

  final ReplyCommentService _replyCommentService = ReplyCommentService();

  @override
  void initState() {
    super.initState();

    fetchReplies = _replyCommentService.getRepliesPostComments(
      commentId: widget.commentData['_id'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Comments"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),

        child: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Replies to ${widget.commentData['owner_name']}'s comment on this health article",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 18),
                    HealthArticleWidgets().buildCommentWidget(
                      context: context,
                      commentData: widget.commentData,
                      eventId: widget.eventId,
                      // isReply: true,
                      refresh: () => setState(() {}),
                    ),

                    SizedBox(height: 20),
                    FutureBuilder<dynamic>(
                      future: fetchReplies,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return const SizedBox();
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          return const SizedBox();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CupertinoActivityIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          my_log(snapshot.data);
                          if (snapshot.hasError) {
                            return helperWidget.noInternetScreen(() {
                              setState(() {
                                fetchReplies = _replyCommentService
                                    .getRepliesPostComments(
                                      commentId: widget.commentData['_id'],
                                    );
                              });
                            });
                          } else if (snapshot.hasData) {
                            repliesList = snapshot.data['comments'];

                            if (repliesList.isEmpty) {
                              return Column(
                                children: [
                                  SizedBox(height: 20),
                                  Center(child: Text("No replies yet")),
                                ],
                              );
                            } else if (repliesList.isNotEmpty) {
                              return ListView.separated(
                                itemCount: repliesList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 40),
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 20);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return HealthArticleWidgets()
                                      .buildCommentWidget(
                                        context: context,
                                        commentData: repliesList[index],
                                        eventId: widget.eventId,
                                        isReply: true,
                                        refresh: () => setState(() {}),
                                      );
                                },
                              );
                            } else {
                              return const Text(
                                'AN ERROR OCCURED FROM THE API',
                              );
                            }
                          } else {
                            return const Text('AN ERROR OCCURED');
                          }
                        } else {
                          return const Text('AN ERROR OCCURED WITH THE STATE');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            buildPostCommentWidget(context),
          ],
        ),
      ),
    );
  }

  Padding buildPostCommentWidget(BuildContext context) {
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
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 4),
                  border: InputBorder.none,
                  hintText: "@ ${widget.commentData["owner_name"]}",

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
                isReplying
                    ? null
                    : () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (_commentController.text.isEmpty) {
                        helperWidget.showToast('Comment field must be filled');

                        return;
                      }
                      setState(() {
                        isReplying = true;
                      });
                      try {
                        var res = await _replyCommentService.commentReply(
                          commentId: widget.commentData['_id'],
                          eventId: widget.eventId,
                          comment: _commentController.text,
                        );
                        my_log(res);
                        if (res['status'] == 'ok') {
                          setState(() {
                            _commentController.clear();
                            if (widget.commentData['reply_count'] == null) {
                              widget.commentData['reply_count'] = 1;
                            } else {
                              widget.commentData['reply_count']++;
                            }
                            repliesList.insert(0, res['comment']);
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
                          isReplying = false;
                        });
                      }
                    },
            child:
                isReplying
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
                        fontSize: 14,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
