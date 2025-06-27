import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_widgets.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tip_widgets.dart';
import 'package:medplan/utils/global.dart';

import 'package:http/http.dart' as http;

import '../../../server/health_tips_api_requests.dart';

class SearchVideoTips extends StatefulWidget {
  const SearchVideoTips({super.key});

  @override
  SearchVideoTipsState createState() => SearchVideoTipsState();
}

class SearchVideoTipsState extends State<SearchVideoTips> {
  List<dynamic> videoTipList = <dynamic>[];
  List<dynamic> result = <dynamic>[];

  final VideoTipService _videoTipService = VideoTipService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadVideoTips();
  }

  bool fetchingHealthArticles = true;

  void loadVideoTips() async {
    try {
      var res = await _videoTipService.searchVideoTip();
      if (res['status'] == 'ok') {
        setState(() {
          videoTipList = res['messages'];
        });
      }
    } catch (e) {
      print(e);
      helperWidget.showToast(
        'oOps an error occurred while fetching video tips',
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        fetchingHealthArticles = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Search Video Tips'),
      body:
          fetchingHealthArticles
              ? Center(
                child: Text(
                  'Fetching video tips...',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              )
              : ListView(
                padding: EdgeInsets.only(top: 5),

                children: [
                  SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        autofocus: true,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            RegExp regex = RegExp(val, caseSensitive: false);
                            result =
                                videoTipList.where((item) {
                                  return regex.hasMatch(item['title'] ?? '');
                                }).toList();
                          } else {
                            result = [];
                          }
                          setState(() {});
                        },
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15, top: 14),
                          hintText: "Type your search here",
                          fillColor: Theme.of(context).shadowColor,
                          filled: true,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  result.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Center(
                          child: Text('No video tips match your search'),
                        ),
                      )
                      : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        itemCount: result.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return VideoTipWidgets().buildVideoTipsWidget(
                            context,
                            result[index],
                            result,
                            refresh: () => setState(() {}),
                          );
                        },
                      ),
                ],
              ),
    );
  }
}
