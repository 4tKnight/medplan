import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationPreference extends StatefulWidget {
  const NotificationPreference({super.key});

  @override
  State<NotificationPreference> createState() => _NotificationPreferenceState();
}

class _NotificationPreferenceState extends State<NotificationPreference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Notification Preferences',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,

        children: [
          Image.asset(
            "assets/notification_preference_page.png",
            fit: BoxFit.cover,
            height: 242.h,
            // width: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your preferred notification sound',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                ...constants.notificationSoundAssets.keys.map(
                  (sound) => _buildNotificationSound(sound),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

@override
  void dispose() async{
    await player.dispose();
    super.dispose();
  }

  String? selectedSound = constants.notificationSoundAssets.keys.first;

  final player = AudioPlayer();
  Widget _buildNotificationSound(String name) {
    return InkWell(
      onTap: () async {
        setState(() {
          selectedSound = name;
        });
        final soundPath = constants.notificationSoundAssets[selectedSound];

        if (soundPath != null) {
          await player.play(AssetSource(soundPath));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(width: 14.w),
                SvgPicture.asset(
                  'assets/notification.svg',
                  color: Colors.black,
                ),
                const Spacer(),
                if (name == selectedSound)
                  Container(
                    height: 20.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.check, color: Colors.white, size: 20.r),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 7.h),
            Divider(color: Colors.grey, height: 1, thickness: 1.h),
          ],
        ),
      ),
    );
  }
}
