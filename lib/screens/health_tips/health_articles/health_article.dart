import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/utils/global.dart';

import 'health_article_widgets.dart';

class HealthArticle extends StatefulWidget {
  const HealthArticle({super.key});

  @override
  HealthArticleState createState() => HealthArticleState();
}

class HealthArticleState extends State<HealthArticle> {
  List<dynamic> healthArticleList = <dynamic>[];

  Future<dynamic>? futureData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadFuture();
  }

  final HealthArticleService _healthArticleService = HealthArticleService();

  void loadFuture() {
    futureData = _healthArticleService.viewHealthArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Blog Tips', isBack: true),

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
            return Center(child: Text('No health article at the moment'));
          } else {
            if (snapshot.data['count'] > 0) {
              healthArticleList = snapshot.data['health_articles'];
            }
            return healthArticleList.isEmpty
                ? Center(child: Text('No health article at the moment'))
                : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 5.h,
                  ),
                  itemCount: healthArticleList.length,
                  separatorBuilder: (context, index) {
                    return  SizedBox(height: 15.h);
                  },
                  itemBuilder: (context, index) {
                    return HealthArticleWidgets().buildHealthArticleWidget(
                      context,
                      healthArticleList[index],
                      healthArticleList,
                      refresh: () => setState(() {}),
                    );
                  },
                );
          }
        },
      ),
    );
  }
}
