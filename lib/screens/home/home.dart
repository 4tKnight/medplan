import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/api/chat_service.dart';
import 'package:medplan/api/health_articles_service.dart';
import 'package:medplan/api/video_tip_service.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_details.dart';
import 'package:medplan/screens/health_tips/health_articles/health_article_widgets.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tip_widgets.dart';
import 'package:medplan/screens/health_tips/video_tips/video_tips_details.dart';
import 'package:medplan/utils/local_notification_handler.dart';

import '../../api/appointment_service.dart';
import '../../api/medication_reminder_service.dart';
import '../../utils/functions.dart';
import '../../utils/global.dart';
import '../auth/auth_login_signup.dart';
import '../bottom_control/bottom_nav_bar.dart';
import '../drawer/app_drawer.dart';
import '../drawer/chat_your_pharmacist.dart';
import '../drawer/reminder_troubleshoot.dart';
import '../medicines/medication_reminder/set_medication_reminder_1.dart';
import 'appointments/appointments.dart';
import 'health_diary/my_health_diary.dart';
import 'notification.dart';
import 'search_medicine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    loadEndpoints();
  }

  loadEndpoints() async {
    await Future.wait<void>([
      fetchConversation(),
      fetchMedicationReminder(),
      fetchUpcomingAppointment(),
      fetchHealthArticles(),
      fetchVideoTips(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(scaffoldKey: scaffoldKey),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              loadEndpoints();
            });
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 23.h),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: const Icon(Icons.menu),
                              onTap: () {
                                scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            SizedBox(width: 9.w),
                            Text(
                              getX.read(v.GETX_USERNAME) == null ||
                                      getX.read(v.GETX_USERNAME) == ''
                                  ? 'Hi User'
                                  : 'Hi ${getX.read(v.GETX_USERNAME)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(width: 35.w),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const ReminderTroubleshoot(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/warning.png",
                                fit: BoxFit.cover,
                                height: 20.r,
                                width: 20.r,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 9.h),
                        Text.rich(
                          TextSpan(
                            text: 'How are you feeling today? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: greyTextColor,
                              fontSize: 16.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'I feel...',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const MyHealthDiary(),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      if (getX.read(v.GETX_IS_LOGGED_IN) == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChatWithPharmacist(),
                          ),
                        );
                      } else {
                        helperWidget.showToast("Please log in to continue");
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (_) => const Login()),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset("assets/chat.png", fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 13.w),
                  InkWell(
                    onTap: () {
                      if (getX.read(v.GETX_IS_LOGGED_IN) == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationPage(),
                          ),
                        );
                      } else {
                        helperWidget.showToast("Please log in to continue");
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (_) => const Login()),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/notification.png",
                        height: 20.h,
                        width: 16.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: buildSearchWidget()),
                  SizedBox(width: 12.w),
                  myWidgets.buildCoinWidget(context),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todays Medications',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SetMedicationReminderStepOne(
                                isDependent: false,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              isMedicationRemindersLoading
                  ? const CupertinoActivityIndicator()
                  : medicationReminders.isEmpty
                  ? noMedicationReminder()
                  : myWidgets.buildMedicationWidget(
                    context: context,
                    reminderData: medicationReminders[0],
                    showDate: true,
                    showViewAll: true,
                    isDependent: false,
                  ),

              SizedBox(height: 24.h),
              if (_conversationList.isNotEmpty) buildActiveChatWidget(),
              if (_conversationList.isNotEmpty) SizedBox(height: 24.h),
              if (appointments.isNotEmpty)
                Text(
                  'Upcoming Appointment',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              if (appointments.isNotEmpty) SizedBox(height: 12.h),
              isAppointmentLoading
                  ? const CupertinoActivityIndicator()
                  : appointments.isEmpty
                  ? const SizedBox()
                  : buildUpcomingAppointmentWidget(),
              SizedBox(height: 24.h),
              myWidgets.buildTalkToPharmacist(context),
              SizedBox(height: 22.h),
              Text(
                'Health Toolpack',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
              SizedBox(height: 11.h),
              buildHealthToolpack(),
              SizedBox(height: 22.h),
              if (healthArticles.length + videoTips.length > 0)
                Text(
                  'Health Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 167.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: (healthArticles.length + videoTips.length).clamp(
                    0,
                    5,
                  ),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index < healthArticles.length)
                          buildHealthTipWidget(healthArticles[index], false),
                        if (index < videoTips.length)
                          buildHealthTipWidget(videoTips[index], true),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildActiveChatWidget() {
    var messageData = _conversationList[0];
    return messageData == null
        ? SizedBox()
        : InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChatWithPharmacist()),
            );
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 9.w,
              right: 10.w,
              top: 8.h,
              bottom: 6.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chat with your Pharmacist',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.asset(
                        "assets/talk_to_pharmacist.png",
                        fit: BoxFit.cover,
                        height: 52.h,
                        width: 50.w,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'MedPlan Pharmacist',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              Text(
                                time.timestamp(
                                  messageData['latest_message_timestamp'],
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: Color.fromRGBO(142, 142, 147, 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          if (messageData['latest_message'] != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    messageData['latest_message']['sender_id'] ==
                                            getX.read(v.GETX_USER_ID)
                                        ? 'You: ${messageData['latest_message']['content'] ?? ''}'
                                        : '${messageData['latest_message']['content'] ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                      color: Color.fromRGBO(142, 142, 147, 1),
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 5.w),
                                // Container(
                                //   height: 19.r,
                                //   width: 19.r,
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context).primaryColor,
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       '3',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.w400,
                                //         fontSize: 12.sp,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }

  int currentDay = DateTime.now().day;
  String monthAbbreviation =
      DateFormat('MMM').format(DateTime.now()).toUpperCase();
  Widget noMedicationReminder() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$currentDay',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$monthAbbreviation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Container(
              // height: 150,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 16.w,
                top: 8.h,
                bottom: 8.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.grey, width: 0.2.w),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/no_medicines.png",
                    fit: BoxFit.cover,
                    height: 123.h,
                    // width: 121.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'You have not set any medication reminder.',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 8.h,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => SetMedicationReminderStepOne(
                                      isDependent: false,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            '+ Set Med. Reminder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
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

  // Row buildMedicationWidget(BuildContext context) {
  //   return Row(
  //     children: [
  //       Container(
  //         height: 150,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 14,
  //         ),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColor,
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //         child: const Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               '19',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 14,
  //               ),
  //             ),
  //             SizedBox(height: 4),
  //             Text(
  //               'NOV.',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 9,
  //       ),
  //       Expanded(
  //         child: Container(
  //           height: 150,
  //           padding: const EdgeInsets.only(
  //             left: 10,
  //             right: 10,
  //             top: 10,
  //             bottom: 15,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(4),
  //             border: Border.all(
  //               color: Colors.grey,
  //               width: 0.2,
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Day 1 of 5',
  //                       style: TextStyle(
  //                         color: Theme.of(context).primaryColor,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     SizedBox(height: 7.h),
  //                     const Text(
  //                       'Benylin Cough Mixture',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 6),
  //                     const Text(
  //                       'Take 20ml',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     const Text(
  //                       '3 times a day for 5 days',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     const Text(
  //                       'After meal',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 width: 5,
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   ClipOval(
  //                     child: Image.asset(
  //                       "assets/syrup.png",
  //                       fit: BoxFit.cover,
  //                       height: 50,
  //                       width: 50,
  //                     ),
  //                   ),
  //                   Text(
  //                     'view all',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 14,
  //                       color: Theme.of(context).primaryColor,
  //                        decoration: TextDecoration.underline,
  // decorationColor:Theme.of(context).primaryColor,
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildHealthTipWidget(var healthTipData, bool isVideoTip) {
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
        height: 167.h,
        width: 192.w,
        margin: EdgeInsets.only(left: 9.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey, width: 0.4.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  child: helperWidget.cachedImage(
                    url: '${healthTipData['img_url']}',
                    height: 119.h,
                    width: double.maxFinite,
                  ),
                ),
                if (isVideoTip)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 30.r,
                        width: 30.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(57, 57, 57, 1),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                if (isVideoTip)
                  Positioned(
                    top: 6.h,
                    right: 8.w,
                    child: Container(
                      // height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(46, 46, 46, 1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '${healthTipData['video_duration'] ?? '00:00'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 9.w,
                right: 9.w,
                top: 5.h,
                bottom: 15.h,
              ),
              child: Text(
                '${healthTipData['title']}',
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

  Row buildHealthToolpack() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => BottomNavBar(index: 2)),
                (route) => false,
              );
            },
            child: Column(
              children: [
                Container(
                  height: 57.r,
                  width: 57.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(71, 198, 68, 1),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/records.png",
                      fit: BoxFit.cover,
                      height: 30.h,
                      width: 31.w,
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Records',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MyHealthDiary()));
            },
            child: Column(
              children: [
                Container(
                  height: 57.r,
                  width: 57.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(253, 170, 39, 1),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/diary.png",
                      fit: BoxFit.cover,
                      height: 30.h,
                      width: 31.w,
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Diary',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const Appointments()));
            },
            child: Column(
              children: [
                Container(
                  height: 57.r,
                  width: 57.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(172, 102, 242, 1),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/appointments.png",
                      fit: BoxFit.cover,
                      height: 30.h,
                      width: 31.w,
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUpcomingAppointmentWidget() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 241, 219, 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('d').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      (appointments[0]['appointment_timestamp']),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('MMM').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      (appointments[0]['appointment_timestamp']),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Container(
              // height: 135,
              padding: EdgeInsets.only(
                left: 14.w,
                right: 12.w,
                top: 9.h,
                bottom: 13.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.grey, width: 0.2.w),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${appointments[0]['hospital_name']}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          '${appointments[0]['appointment_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.8),
                            fontSize: 16.sp,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          '${appointments[0]['appointment_time']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.7),

                            fontSize: 15.sp,
                            height: 1.3,
                          ),
                        ),
                        Divider(color: Colors.grey, thickness: 0.5.r),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${appointments[0]['doctors_name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.7),

                                fontSize: 15.sp,
                                height: 1.3,
                              ),
                            ),
                            if (appointments.length > 1)
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const Appointments(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'view all',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,

                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
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

  Widget buildSearchWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SearchMedicine()));
      },
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(2, 2), // Shadow only at bottom right
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(Icons.search, color: Colors.black54),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Search for medicine information',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ChatService _chatService = ChatService();
  List<dynamic> _conversationList = [];
  Future<void> fetchConversation() async {
    final cachedData = getX.read(v.CACHED_CONVERSATIONS);

    if (cachedData != null) {
      setState(() {
        _conversationList = cachedData['conversations'] ?? [];
      });
    }

    try {
      var res = await _chatService.getConversations();
      if (res['status'] == 'ok') {
        if (cachedData == null || jsonEncode(cachedData['conversations']) !=
                jsonEncode(res['conversations'])) {
          getX.write(v.CACHED_CONVERSATIONS, res);
          setState(() {
            _conversationList = res['conversations'] ?? [];
          });
        }
        
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching conversations",
        );
      }
    } catch (e) {
      my_log(e);
      helperWidget.showToast(
        "Oops! Something went wrong while fetching conversations",
      );
    }
  }

  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  bool isMedicationRemindersLoading = false;
  List<dynamic> medicationReminders = [];
  fetchMedicationReminder() async {
    final cachedData = getX.read(v.CACHED_MEDICATIONS_REMINDER);

    if (cachedData != null) {
      setState(() {
        medicationReminders = cachedData['medication_reminders'] ?? [];
        isMedicationRemindersLoading = false;
      });
    } else {
      setState(() {
        isMedicationRemindersLoading = true;
      });
    }

    try {
      var res = await _medicationReminderService.viewTodaysMedicationReminders(
        medFor: 'self',
        forId: 'a',
      );
      if (res['status'] == 'ok') {
       
        if (cachedData == null ||
            jsonEncode(cachedData['medication_reminders']) !=
          jsonEncode(res['medication_reminders'])) {
          getX.write(v.CACHED_MEDICATIONS_REMINDER, res);
          setState(() {
            medicationReminders = res['medication_reminders'] ?? [];
          });
        }
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching medication reminders",
        );
      }
    } catch (e) {
       helperWidget.showToast(
          "Oops! Something went wrong while fetching medication reminders",
        );
    } finally {
      setState(() {
        isMedicationRemindersLoading = false;
      });
    }
  }

  final AppointmentService _appointmentService = AppointmentService();
  bool isAppointmentLoading = false;
  List<dynamic> appointments = [];
  fetchUpcomingAppointment() async {
      final cachedData = getX.read(v.CACHED_APPOINTMENTS);

    if (cachedData != null) {
      setState(() {
        appointments = cachedData['appointments'] ?? [];
        isAppointmentLoading = false;
      });
    } else {
      setState(() {
        isAppointmentLoading = true;
      });
    }

   
    try {
      var res = await _appointmentService.viewUpcomingAppointment();
      if (res['status'] == 'ok') {
       
          if (cachedData == null ||
            jsonEncode(cachedData['appointments']) !=
                jsonEncode(res['appointments'])) {
          getX.write(v.CACHED_APPOINTMENTS, res);
          setState(() {
            appointments = res['appointments'] ?? [];
          });
        }
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching appointments",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    } finally {
      setState(() {
        isAppointmentLoading = false;
      });
    }
  }

  final HealthArticleService _healthArticleService = HealthArticleService();

  List<dynamic> healthArticles = [];
  fetchHealthArticles() async {
     final cachedData = getX.read(v.CACHED_HEALTH_ARTICLES);

    if (cachedData != null) {
      setState(() {
        healthArticles = cachedData['health_articles'] ?? [];
      });
    }
    try {
      var res = await _healthArticleService.viewHealthArticles();
      if (res['status'] == 'ok') {
       
         if (cachedData == null ||
            jsonEncode(cachedData['health_articles']) !=
                jsonEncode(res['health_articles'])) {
          getX.write(v.CACHED_HEALTH_ARTICLES, res);
          setState(() {
            healthArticles = res['health_articles'] ?? [];
          });
        }
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching health article",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    }
  }

  final VideoTipService _videoTipService = VideoTipService();

  List<dynamic> videoTips = [];
  fetchVideoTips() async {
     final cachedData = getX.read(v.CACHED_VIDEO_TIPS);

    if (cachedData != null) {
      setState(() {
        videoTips = cachedData['video_tips'] ?? [];
      });
    }
    try {
      var res = await _videoTipService.viewVideoTips();
      if (res['status'] == 'ok') {
       
         if (cachedData == null ||
            jsonEncode(cachedData['video_tips']) !=
                jsonEncode(res['video_tips'])) {
          getX.write(v.CACHED_VIDEO_TIPS, res);
          setState(() {
            videoTips = res['video_tips'] ?? [];
          });
        }
      } else {
        helperWidget.showToast(
          "Oops! Something went wrong while fetching video tips",
        );
      }
    } catch (e) {
      helperWidget.showToast("Oops! Something went wrong.");
    }
  }
}
