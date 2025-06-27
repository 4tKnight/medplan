import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/screens/home/health_diary/my_health_diary.dart';

import '../../utils/global.dart';
import '../bottom_control/bottom_nav_bar.dart';
import '../medicines/medication_reminder/medication_reminders.dart';

class MedplanCoin extends StatelessWidget {
  const MedplanCoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Medplan Coins', isBack: true),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Image.asset(
            "assets/medplan_coin_page.png",
            fit: BoxFit.cover,
            height: 242.h,
            // width: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 23.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'What are MedPlan Coins?',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    Image.asset(
                      "assets/coin.png",
                      fit: BoxFit.cover,
                      height: 19.h,
                      width: 21.w,
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                Text(
                  'These are FREE coins given to you as a reward system for taking good charge of your health. ',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 26.h),
                Text(
                  'What can i use these coins for?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 7.h),
                Text.rich(
                  TextSpan(
                    text:
                        'These coins can be used to chat with a Pharmacist for health complaints or medication reviews. \nEach free consultation uses up ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '4 of your FREE coins.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 17.h),
                Text(
                  'How do I earn these coins?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "You earn these coins on the MedPlan app by doing the following:",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Taking your ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'medications',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BottomNavBar(index: 1),
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(
                              text:
                                  ' as prescribed by your doctor. We reward you for up to 90% compliance with instructions.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Documenting how you feel daily in your ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'health diary',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MyHealthDiary(),
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Keeping track of at least one ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'health record',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BottomNavBar(index: 2),
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(
                              text:
                                  ' daily eg Blood Pressure, Daily steps etc.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Reading ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'health articles',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BottomNavBar(index: 3),
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(text: ' daily and Watching '),
                            TextSpan(
                              text: 'video articles',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BottomNavBar(
                                                index: 3,
                                                ht_index: 1,
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        'Taking your medications as prescribed by your doctor. earns you 1 coin daily. Also, using your health diary, tracking your health records and getting informed with articles and video tips earn you 1 points daily per activity.',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        'To receive your coin rewards, you device must have an active internet connection.',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black.withValues(alpha: 0.7),
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
    );
  }
}
