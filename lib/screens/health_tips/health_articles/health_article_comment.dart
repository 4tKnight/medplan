import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_widgets.dart';
import 'package:medplan/utils/global.dart';
import 'package:medplan/utils/loading_widgets.dart';
import 'package:http/http.dart' as http;

import '../../../helper_widget/loading_widgets.dart';
import '../../../server/health_tips_api_requests.dart';
import 'health_articles_comment_replies.dart';

class HealthArticleComments extends StatefulWidget {
  dynamic healthArticleData;
  List<dynamic> healthArticleComments;
  HealthArticleComments({
    super.key,
    required this.healthArticleData,
    required this.healthArticleComments,
  });

  @override
  _HealthArticleCommentsState createState() => _HealthArticleCommentsState();
}

class _HealthArticleCommentsState extends State<HealthArticleComments> {
  final TextEditingController _commentController = TextEditingController();

  bool isCommenting = false;
  final HealthArticleService _healthArticleService = HealthArticleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Comments"),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              itemCount: widget.healthArticleComments.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (BuildContext context, int index) {
                return HealthArticleWidgets().buildCommentWidget(
                  context: context,
                  commentData: widget.healthArticleComments[index],
                  eventId: widget.healthArticleData['_id'],
                  refresh: () => setState(() {}),
                );
              },
            ),
          ),
          buildPostCommentWidget(context),
        ],
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
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 4),
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
                            widget.healthArticleComments.insert(0,res['comment']);
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
                        fontSize: 14,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
