import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/global.dart';

class AboutMedplan extends StatelessWidget {
  const AboutMedplan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'About MedPlan', isBack: true),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        children: <Widget>[
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Company Description\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      'MedPlan Solutions is a tech-driven healthcare company headquartered in Benin city, Nigeria. Our platform addresses the critical challenges of medication adherence and health education through innovative and inclusive solutions tailored to the Nigerian populace.\n\n',
              
                ),
                TextSpan(
                  text: 'MedPlan App\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      'MedPlan is a mobile application designed to enhance medication adherence and health literacy among individuals. By leveraging technology, MedPlan empowers users to better manage their health through tools like medication reminders, appointment scheduling, health tracking, and culturally inclusive educational content. This comprehensive platform not only aids in improving personal health outcomes but also contributes to the reduction of healthcare costs caused by non-adherence and lack of awareness. With features like multilingual support and vitals tracking, MedPlan targets a broad audience, including undeserved communities in Nigeria.\n\n',
                ),
                TextSpan(
                  text: 'Mission Statement\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      'Bridging the gap in healthcare education and medication adherence.\n',
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(MEDPLAN_WEB_URL); 

              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not open browser.';
              }
            },
            child: Row(
              children: [
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                SizedBox(width: 4.w),
                Text(
                  'Visit our website',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
   
    );
  }
}
