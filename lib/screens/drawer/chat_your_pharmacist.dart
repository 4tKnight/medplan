import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medplan/api/chat_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../utils/functions.dart';
import '../../utils/global.dart';
import '../../utils/view_image.dart';
import 'medplan_coin.dart';

class ChatWithPharmacist extends StatefulWidget {
  const ChatWithPharmacist({super.key});

  @override
  ChatWithPharmacistState createState() => ChatWithPharmacistState();
}

class ChatWithPharmacistState extends State<ChatWithPharmacist> {
  @override
  void initState() {
    _streamController.add([]);

    checkIfNewConversation();
    requestStoragePermission();
    getDownloadDirectory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_socket != null) {
      _socket!.dispose();
    }
  }

  bool checkingIfUsersHavePreviousConversation = true;

  IO.Socket? _socket;

  _connectSocket() {
    _socket = IO.io(
      '$dioBaseUrl/',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build(),
    );
    _socket!.connect();
    _socket!.onConnect((data) {
      my_log("Connection established:$data");
    });
    _socket!.onConnectError((err) {
      my_log("Connection Error:$err");
    });
    _socket!.onDisconnect((_) => my_log('Connection Disconnected'));

    _socket!.on("receive-error-message", (data) {
      my_log("error:$data");
    });
    _socket!.on("receive-message-$conversationID", (data) {
      my_log("msg:$data");
      if (data['msg'] == "You don't have enough medplan coins") {
        showNoCoinLeftDialog();
        return;
      }
      List updatedMessageList = myMessages + [data['message']];
      _streamController.add(updatedMessageList);
      scrollToEnd();
    });

    _socket?.onError((err) => my_log(err));
  }

  bool isNewConv = false;

  final ChatService _chatService = ChatService();

  checkIfNewConversation() async {
    final cachedData = getX.read(v.CACHED_CONV_ID);
    if (cachedData != null && cachedData.isNotEmpty) {
      isNewConv = false;
      conversationID = cachedData;
      _connectSocket();
      _getPreviousMessages();
    }

    try {
      var res = await _chatService.checkConvers();
      my_log(res);
      if (res != null) {
        if (res['msg'] == "Success") {
          if (cachedData == null) {
            getX.write(v.CACHED_CONV_ID, res['conversation_id']);
            isNewConv = false;
            conversationID = res['conversation_id'];
            print('>>>>>>>>>>>>>>>>>>>>>>> convID: ${res['conversation_id']} ');
            _connectSocket();
            _getPreviousMessages();
          }
        } else if (res['msg'] == "created new conversation") {
          if (cachedData == null) {
            getX.write(v.CACHED_CONV_ID, res['conversation_id']);
            showImportantNoticeDialog();
            print('created new conversation');
            isNewConv = true;
            conversationID = res['conversation_id'];
            _connectSocket();
            _streamController.add([]);
            setState(() => checkingIfUsersHavePreviousConversation = false);
          }
        } else if (res['msg'] == "insufficient medplan coins") {
          Navigator.pop(context);
          showNoCoinLeftDialog();
        } else {
          helperWidget.showToast('Something went wrong.\n Try again later');
          Navigator.pop(context);
        }
      } else {
        helperWidget.showToast("Check your internet connection and try again.");
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>>> $e ');
      if (e is SocketException) {
        helperWidget.showToast("Check your internet connection");
      } else {
        helperWidget.showToast("An error occurred. Please try again later.");
      }
    }
  }

  int pagec = 1;

  _getPreviousMessages() async {
    final cachedData = getX.read(v.CACHED_MESSAGES);

    if (cachedData != null) {
      _streamController.add(cachedData["messages"] ?? []);
      setState(() => checkingIfUsersHavePreviousConversation = false);
      if (cachedData['messages'] != null && cachedData['messages'].isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 700), () {
          scrollToEnd();
        });
      }
    }

    try {
      var res = await _chatService.getMessages(
        convoID: conversationID,
        pagec: pagec,
      );

      if (res['status'] == "ok") {
        if (cachedData == null ||
            jsonEncode(cachedData['messages']) != jsonEncode(res['messages'])) {
          my_log("cached messages updated: ${res['messages']}");
          getX.write(v.CACHED_MESSAGES, res);
          _streamController.add(res["messages"] ?? []);
          setState(() => checkingIfUsersHavePreviousConversation = false);
          if (res['messages'] != null && res['messages'].isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 700), () {
              scrollToEnd();
            });
          }
        }
      } else {
        helperWidget.showToast("Check your internet connection and try again.");
      }
    } catch (e) {
      if (e is SocketException) {
        helperWidget.showToast("Check your internet connection");
      } else {
        print('>>>>>>>>>>>>>>>>>>>>>>> $e ');
      }
    }
  }

  //0 means loading
  //1 means okay and good
  //2 means error
  // int checkingConversations = 0;

  // String content = '';

  //if its empty, it will throw error. So use 'a' by default
  String conversationID = 'a';

  TextEditingController messageController = TextEditingController();

  final ScrollController _controller =
      ScrollController(); //attached this _controller to a scrollable widget to help auto scroll when a new message is sent
  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  @override
  build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Chat your Pharmacist'),
      body:
          checkingIfUsersHavePreviousConversation == true
              ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
              : Column(
                children: <Widget>[
                  sendingImage
                      ? const LinearProgressIndicator()
                      : const SizedBox(),

                  // WHEN DOWNLOADING A FILE
                  downloading
                      ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$downloadingFileName: $totalFileSize',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: _percentage,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  progress,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : const SizedBox(),

                  Flexible(
                    child: StreamBuilder<dynamic>(
                      stream: _streamController.stream,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot asyncSnapshot,
                      ) {
                        if (asyncSnapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }
                        if (asyncSnapshot.hasError) {
                          return const Center(
                            child: Text('Error fetching messages'),
                          );
                        }

                        myMessages = asyncSnapshot.data;

                        if (!asyncSnapshot.hasData) {
                          return const Center(child: Text('Loading...'));
                        } else if (myMessages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 41.w,
                                    ),
                                    height: 175.h,
                                    child: Image.asset(
                                      "./assets/no_message.png",
                                    ),
                                  ),
                                ),
                                SizedBox(height: 19.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    "Need a medication review or unsure of your medicines? Chat with your Pharmacist today for free",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            // reverse: true,
                            controller: _controller,
                            itemCount: myMessages.length,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  if (displayChatDate(index))
                                    Row(
                                      children: [
                                        const Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            // showImportantNoticeDialog();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                154,
                                                154,
                                                154,
                                                1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                            child: Text(
                                              time.formattedDateFromTimestamp(
                                                myMessages[index][db.TIMESTAMP],
                                              ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                      ],
                                    ),
                                  if (index < myMessages.length)
                                    buildMessageOrImage(
                                      screen,
                                      myMessages[index],
                                    ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  //*BUTTON BELOW
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 20.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Row(
                      children: [
                        getX.read(v.GETX_USER_IMAGE) == ''
                            ? myWidgets.noProfileImage(35.r)
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(360),
                              child: helperWidget.cachedImage(
                                url: '${getX.read(v.GETX_USER_IMAGE)}',
                                height: 35.r,
                                width: 35.r,
                              ),
                            ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 7.w),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 10.h,
                              ),
                              child: Center(
                                child: TextField(
                                  controller: messageController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: ' Type here',
                                    hintStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(0, 0, 0, 0.53),
                                    ),
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                  ),
                                  minLines: 1,
                                  maxLines: 4,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildAttachButton(),
                        InkWell(
                          onTap: () async {
                            if (messageController.text.isNotEmpty) {
                              _sendMessage();
                            } else {
                              my_log('empty');
                            }
                          },
                          child: Container(
                            // margin: EdgeInsets.only(left: 0.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(180.r),
                              ),
                              color:
                                  messageController.text.isNotEmpty
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                            ),
                            padding: EdgeInsets.all(6.r),
                            child: Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  showImportantNoticeDialog() {
    bool agree = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 420.h,
                // width: 120,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'IMPORTANT NOTICE',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Image.asset(
                        "./assets/yellow_warning.png",
                        height: 50.h,
                        width: 40.w,
                      ),
                      SizedBox(height: 15.h),

                      // ☐ I have read and understand this information.
                      myWidgets.buildBulletPoint(
                        'This chat is for general information and medication support only.',
                      ),
                      myWidgets.buildBulletPoint(
                        'It is not a substitute for professional medical advice or treatment.',
                      ),
                      myWidgets.buildBulletPoint(
                        'Always consult your doctor for medical concerns or emergencies.',
                      ),

                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Checkbox(
                            value: agree,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              setCustomState(() {
                                agree = value!;
                              });
                            },
                          ),
                          // const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "I have read and understand this information.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 23.h),
                      ElevatedButton(
                        onPressed: () {
                          if (agree) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 36.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showNoCoinLeftDialog() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 242.h,
            // width: 120,
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'NO COINS LEFT',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Image.asset(
                    "./assets/smiley_delete.png",
                    height: 46.h,
                    width: 48.w,
                  ),
                  SizedBox(height: 17.h),
                  Text.rich(
                    TextSpan(
                      text:
                          "You have run out of your free coins.\nThese FREE coins are given to you as a reward system for taking good charge of your health.\n",
                      children: [
                        TextSpan(
                          text: "Learn how to get more for FREE",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MedplanCoin(),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool displayChatDate(int index) {
    // one message
    if (myMessages.length == 1) {
      return true;
    }
    //first message
    if (index == 0) {
      return true;
    }
    //if message date the same as previous message date don't display
    if (time.formattedDateFromTimestamp(myMessages[index][db.TIMESTAMP]) ==
        time.formattedDateFromTimestamp(myMessages[index - 1][db.TIMESTAMP])) {
      return false;
    }
    return true;
  }

  requestStoragePermission() async {
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    } else {
      var status = await Permission.storage.status;
      if (status.isGranted == false) {
        await Permission.storage.request();
      }
    }
  }

  buildMessageOrImage(screen, dynamic messageDocument) {
    bool isOwnMessage = true;
    if (messageDocument['sender_id'] == getX.read(v.GETX_USER_ID)) {
      isOwnMessage = true;
    } else {
      isOwnMessage = false;
    }

    if (messageDocument[db.MESSAGE_TYPE] != 'img') {
      return Padding(
        padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10.h),
        child: Row(
          mainAxisAlignment:
              isOwnMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isOwnMessage)
              getX.read(v.GETX_USER_IMAGE) == ''
                  ? myWidgets.noProfileImage(26.r)
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: helperWidget.cachedImage(
                      url: '${getX.read(v.GETX_USER_IMAGE)}',
                      height: 26.r,
                      width: 26.r,
                    ),
                  ),
            if (isOwnMessage) SizedBox(width: 6.w),

            Material(
              // elevation: 5,
              color:
                  isOwnMessage
                      ? Color.fromRGBO(237, 249, 255, 1)
                      : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxWidth: screen.width - 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageDocument[db.CONTENT],
                            style: TextStyle(
                              color: isOwnMessage ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          messageDocument[db.TIMESTAMP] == null
                              ? Text(
                                "...",
                                style: TextStyle(
                                  color:
                                      isOwnMessage
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                              : Text(
                                time.timeFromTimestamp(
                                  messageDocument[db.TIMESTAMP],
                                ),
                                style: TextStyle(
                                  color:
                                      isOwnMessage
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isOwnMessage) SizedBox(width: 6.w),
            if (!isOwnMessage)
              ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.asset(
                  'assets/icon/icon.png',
                  height: 26.r,
                  width: 26.r,
                ),
              ),
          ],
        ),
      );
    } else {
      //an image
      return Padding(
        padding: EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 10.h),
        child: Row(
          mainAxisAlignment:
              isOwnMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isOwnMessage)
              getX.read(v.GETX_USER_IMAGE) == ''
                  ? myWidgets.noProfileImage(26.r)
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: helperWidget.cachedImage(
                      url: '${getX.read(v.GETX_USER_IMAGE)}',
                      height: 26.r,
                      width: 26.r,
                    ),
                  ),
            if (isOwnMessage) SizedBox(width: 6.w),
            Material(
              color:
                  isOwnMessage
                      ? Color.fromRGBO(237, 249, 255, 1)
                      : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxWidth: screen.width / 2),
                      child: FutureBuilder<bool>(
                        future: checkIfImageIsDownloaded(
                          messageDocument[db.FILE_NAME],
                        ),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<bool> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              bool? isImageDownloaded = snapshot.data;
                              return GestureDetector(
                                child: Column(
                                  children: [
                                    !isImageDownloaded!
                                        ? Icon(
                                          Icons.image_outlined,
                                          size: 100,
                                          color:
                                              isOwnMessage
                                                  ? Colors.black
                                                  : Colors.white,
                                        )
                                        : Image.file(
                                          File(
                                            "$downloadDirectory/${messageDocument[db.FILE_NAME]}",
                                          ),
                                        ),
                                    SizedBox(height: 7.h),
                                    messageDocument[db.TIMESTAMP] == null
                                        ? Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "...",
                                            style: TextStyle(
                                              color:
                                                  isOwnMessage
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        )
                                        : Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            // "8:02",
                                            time.timeFromTimestamp(
                                              messageDocument[db.TIMESTAMP],
                                            ),
                                            style: TextStyle(
                                              color:
                                                  isOwnMessage
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                                onTap: () async {
                                  if (!isImageDownloaded) {
                                    downloadOrOpenFile(
                                      messageDocument[db.FILE_NAME],
                                      messageDocument[db.MESSAGE_IMAGE][0],
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ViewImage(
                                              fileImage: File(
                                                "$downloadDirectory/${messageDocument[db.FILE_NAME]}",
                                              ),
                                            ),
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isOwnMessage) SizedBox(width: 6.w),
            if (!isOwnMessage)
              ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.asset(
                  'assets/icon/icon.png',
                  height: 26.r,
                  width: 26.r,
                ),
              ),
          ],
        ),
      );
    }
  }

  _sendMessage() {
    FocusScope.of(context).requestFocus(FocusNode());

    my_log({
      "token": getX.read(v.TOKEN),
      "sender_name": getX.read(v.GETX_USERNAME),
      "receiver_id": 'admin',
      "message": messageController.text.trim(),
      'conv_id': conversationID,
      'user_type': 'user',
      'new_conv': isNewConv,
      "sender_img":
          getX.read(v.GETX_USER_IMAGE).isEmpty
              ? 'a'
              : getX.read(v.GETX_USER_IMAGE),

      'other_username': 'admin',
      'other_user_img': 'admin',

      // "conversation_id": conversationID,
      // "sender_id": getX.read(v.GETX_USER_ID),
      // "msg_type": "msg",
    });

    setState(() {
      //  !message.token ||
      //     !message.sender_name ||
      //     !message.receiver_id ||
      //     !message.message ||
      //     !message.user_type ||
      //     !message.sender_img ||
      //     !message.conv_id ||
      //     !message.msg_type
      _socket!.emit('send-message', {
        "token": getX.read(v.TOKEN),
        "sender_name": getX.read(v.GETX_USERNAME),
        "receiver_id": 'admin',
        "message": messageController.text.trim(),
        'conv_id': conversationID,
        'user_type': 'user',
        'new_conv': isNewConv,
        "sender_img":
            getX.read(v.GETX_USER_IMAGE).isEmpty
                ? 'a'
                : getX.read(v.GETX_USER_IMAGE),

        'other_username': 'admin',
        'other_user_img': 'admin',

        // "conversation_id": conversationID,
        // "sender_id": getX.read(v.GETX_USER_ID),
        "msg_type": "msg",
      });

      messageController.clear();
    });
  }

  //function to scroll page automatically after sending a new message
  scrollToEnd() {
    if (myMessages.length > 5) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        // 0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  List<dynamic> myMessages = <dynamic>[];

  //the reason I am causing this restriction is because I dont want the user to be able to send
  //an image as the first file when a conversationID has not been created considering it is from mongo we get the conv_id first from
  buildAttachButton() {
    if (!messageController.text.isNotEmpty) {
      // my_log('>>>>>>>>>>>>>>>>>>>>>>> NO TEXT IN THE TEXTFIELD YET ');

      return IconButton(
        icon: const Icon(Icons.attach_file_sharp),
        onPressed: () {
          // if (myMessages.isEmpty) {
          // helperWidget.showToast("Send a message first");
          // } else {
          // FocusScope.of(context).requestFocus(FocusNode());

          showModalToSelectImage();
          // }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Future<bool> checkIfImageIsDownloaded(String fileName) async {
    String fileDownloadPath = "$downloadDirectory/$fileName";

    bool isfileExist = await File(fileDownloadPath).exists();

    return Future<bool>.value(isfileExist);
  }

  String? downloadDirectory;
  getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }

    downloadDirectory = directory!.path;
  }

  //
  File? pickedImage;
  bool sendingImage = false;
  late ImageSource picTypeSelection;

  String downloadingFileName = '';

  var progress = '';
  bool downloading = false;
  String totalFileSize = '';
  final double _percentage = 0;

  // //METHOD TO CONVERT THE FILE FROM BYTES TO MB
  String formatBytes(int bytes) {
    if (bytes <= 0) return "0 KB";
    const suffixes = ['b', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb', 'zb', 'yb'];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(0)) + suffixes[i];
  }

  // // On IOS it create a folder with the name of your app and put the file inside it. Users can easily find the folder, it's intuitive.
  // // On Android, I test if the default download folder exist (it work most of the time), else I put inside the external storage directory (in this case, it's hard for the user to manually find the file...).
  downloadOrOpenFile(String fileName, String fileUrl) async {
    try {
      //this will be the location path of the file downloading/downloaded
      String fileDownloadPath = "$downloadDirectory/$fileName";

      if (await File(fileDownloadPath).exists()) {
        helperWidget.showToast("File already downloaded");
        // OpenFilex.open(fileDownloadPath);
        // myWidgets.showToast("File already downloaded. View through your gallery app");
      } else {
        setState(() {
          downloading = true;
        });
        //THIS WILL SHOW THE CUSTOMIZED SNACKBAR (FLUSHBAR)
        // showFlushBar2(context, 'Please do not leave this screen while download is in progress');

        //DOWNLOAD BEGINS HERE
        await dio.Dio()
            .download(
              fileUrl,
              fileDownloadPath,
              onReceiveProgress: (rec, total) {
                my_log('Received: $rec, Total: $total');

                var percentage = rec / total * 100;

                // _percentage = percentage / 100;

                setState(() {
                  downloadingFileName = fileName;
                  totalFileSize = formatBytes(total);
                  progress = ("${percentage.floor()}%");
                });
              },
            )
            .then((val) {
              helperWidget.showToast("Download complete");

              setState(() {
                downloading = false;
              });
            })
            .catchError((e) {
              if (e is SocketException) {
                helperWidget.showToast(
                  "Check your internet connection & try again",
                );
              } else {
                my_log(e);
                helperWidget.showToast("Download failed");
              }
              setState(() {
                downloading = false;
              });
            });
      }
    } catch (e) {
      my_log("$e");
    }
  }

  showModalToSelectImage() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Choose from:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      picTypeSelection = ImageSource.camera;
                      chooseFile(picTypeSelection);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.camera, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      picTypeSelection = ImageSource.gallery;
                      chooseFile(picTypeSelection);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.image, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  chooseFile(ImageSource imageSource) {
    ImagePicker().pickImage(source: imageSource).then((tempImage) async {
      if (tempImage != null) {
        setState(() {
          sendingImage = true;
        });

        pickedImage = File(tempImage.path);

        String fileName = "IMG_${DateTime.now().millisecondsSinceEpoch}.jpg";

        var formData = dio.FormData.fromMap({
          "token": getX.read(v.TOKEN),
          'user_type': 'user',
          "sender_name": getX.read(v.GETX_USERNAME),
          "sender_img":
              getX.read(v.GETX_USER_IMAGE).isEmpty
                  ? 'a'
                  : getX.read(v.GETX_USER_IMAGE),
          "receiver_id": 'admin',
          // "new_conv": false,
          // "conv_id": conversationID,
          "conversation_id": conversationID,
          "message": 'a',
          "other_username": 'admin',
          "other_user_img": 'a',
          "chat_init_user_id": "a",
          "msg_type": "img",
          "msg_file_ext": "png",
          "msg_file_name": fileName,
          "resource_type": "image",

          // "sender_id": getX.read(v.GETX_USER_ID),
          // "to": 'admin',
        });

        // print(formData.fields);

        var file = await dio.MultipartFile.fromFile(
          pickedImage!.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        );
        formData.files.add(MapEntry('images', file));

        try {
          var res = await _chatService.sendFile(formData);

          if (res['msg'] == "Message sent") {
            print('>>>>>>>>>>>>>>>>>>>>>>> $res ');
            isNewConv = false;
            scrollToEnd();
          } else {
            helperWidget.showToast("Oops an error occured please resend image");
          }
        } catch (e) {
          helperWidget.showToast("oOps something went wrong");
        } finally {
          setState(() {
            sendingImage = false;
          });
        }
      } else {
        print("didnt select image");
      }
    });
  }
}
