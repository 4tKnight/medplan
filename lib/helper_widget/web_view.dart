import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../utils/global.dart';

class ExploreWebview extends StatefulWidget {
  const ExploreWebview({Key? key, required this.url,this.title}) : super(key: key);
  final String url;
  final String? title;
  @override
  State<ExploreWebview> createState() => _ExploreWebviewState();
}

class _ExploreWebviewState extends State<ExploreWebview> {
  late WebViewController controller;
  double progress = 0;
  bool onError = false;
  bool isLoading = true;
  String status = "";
  
  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onPageStarted: (url) {
                setState(() {
                  isLoading = true;
                  status = "";
                });
              },
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                  if (status != "error") {
                    onError = false;
                    status = "";
                  }
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  onError = true;
                  status = "error";
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white60,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))),
              body: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  LinearProgressIndicator(
                    value: progress,
                    color: primaryColor,
                    backgroundColor: Colors.white,
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: onError,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              isLoading
                                  ? "Reconnecting..."
                                  : "oOps, something went wrong!",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              isLoading
                                  ? "Please wait"
                                  : "Please check your internet connection and retry",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              isLoading = true;
                              Future.delayed(const Duration(milliseconds: 500),
                                  () async {
                                await controller.reload();
                                onError == false;
                              });
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                        color: Colors.grey,
                                        offset: Offset(0, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  color: primaryColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLoading ? "Retrying . . . " : "Retry",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  isLoading
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.refresh_rounded,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
