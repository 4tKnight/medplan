import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/global.dart';

class ReminderTroubleshoot extends StatefulWidget {
  const ReminderTroubleshoot({super.key});

  @override
  State<ReminderTroubleshoot> createState() => _ReminderTroubleshootState();
}

class _ReminderTroubleshootState extends State<ReminderTroubleshoot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Reminder Troubleshooting',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        children: [
          Text(
            'Complete the following steps to ensure you get your medication reminders.',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
          ),
          SizedBox(height: 23.h),
          buildReminderActionWidget(
            '1',
            'Remove the MedPlan app from battery optimization settings.',
            'Battery optimization restricts app activity when they are inactive, which may cause delays in receiving medication reminders.',
            'troubleshoot_1',
            220,
          ),
          SizedBox(height: 12.h),
          buildReminderActionWidget(
            '2',
            'Verify the Auto-start settings.',
            'MedPlan must run automatically in the background when the phone starts up to guarantee timely medication reminders.',
            'troubleshoot_2',

            // 180,
          ),
          SizedBox(height: 12.h),
          buildReminderActionWidget(
            '3',
            'Ensure notification sound is turned on.',
            'Notification sound might be turned off on your device. To resolve this, enable notification sound in your settings.',
            'troubleshoot_3',

            200,
          ),
          SizedBox(height: 12.h),
          buildReminderActionWidget(
            '4',
            'Modify the advanced battery settings.',
            'Adjust these battery settings to ensure timely notifications.',
            'troubleshoot_4',

            160,
          ),
          SizedBox(height: 12.h),
          buildStep5ReminderActionWidget(),
          SizedBox(height: 49.h),
        ],
      ),
    );
  }

  Row buildReminderActionWidget(
    String step,
    String title,
    String body,
    String image, [
    double height = 180,
  ]) {
    return Row(
      children: [
        Container(
          height: height.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Step',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                step,
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
            height: height.h,
            padding: EdgeInsets.only(
              left: 14.w,
              right: 10.w,
              top: 9..h,
              bottom: 9.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: Colors.grey, width: 0.4.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Image.asset(
                      "assets/$image.png",
                      fit: BoxFit.cover,
                      height: 33.r,
                      width: 33.r,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: Center(
                    child: Text(
                      body,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(
                        0,
                        0,
                      ), // Optional: prevents extra tap target space
                      tapTargetSize:
                          MaterialTapTargetSize
                              .shrinkWrap, // Optional: shrinks tap area
                    ),
                    child: Text(
                      'TAKE ACTION NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildStep5ReminderActionWidget() {
    return Row(
      children: [
        Container(
          height: 200.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '5',
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
            height: 200.h,
            padding: EdgeInsets.only(
              left: 13.w,
              right: 14.w,
              top: 9.h,
              bottom: 10.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: Colors.grey, width: 0.4.h),
            ),
            child: Text(
              'Disable task killers such as battery savers and antivirus apps like Clean Master, 360 Security, and Fast Booster to prevent interference with reminders. \n\nAvoid force-stopping MedPlan, as it may disrupt your reminders.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.7),

                fontSize: 14.5.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
