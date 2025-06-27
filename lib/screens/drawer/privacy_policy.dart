import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Privacy Policy', isBack: true),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        children: <Widget>[
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Effective Date: April 30th, 2025\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      'At MedPlan, your privacy is important to us. We are committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.\n',
                ),
              ],
            ),
          ),
          infomationWeCollect(),
          userYourInformation(),
          protectInformation(),
          sharingInformation(),
          rightNChoices(),
          childrenPolicy(),
          changeToPolicy(),
          contactUsPolicy(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget userYourInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. How We Use Your Information',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
        Text(
          'We use your information to:',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
        myWidgets.buildBulletPoint('Help you manage your medications and health vitals.'),
        myWidgets.buildBulletPoint(
          'Enable you to care for dependents and receive medication reminders through your companion feature.',
        ),
        myWidgets.buildBulletPoint(
          'Provide access to trusted pharmacists for free health consultations.',
        ),
        myWidgets.buildBulletPoint(
          'Send you reminders, educational content, and health tips.',
        ),
        myWidgets.buildBulletPoint('Improve our services and user experience.\n'),
      ],
    );
  }

  Widget sharingInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. Sharing of Information',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
        Text(
          'We do not sell, rent, or share your personal information with third parties except:',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
        myWidgets.buildBulletPoint('HWith your explicit consent.'),
        myWidgets.buildBulletPoint(
          'With licensed healthcare professionals who are bound by confidentiality agreements.',
        ),
        myWidgets.buildBulletPoint(
          'If required by law (e.g., legal requests, regulatory compliance).\n',
        ),
      ],
    );
  }

  Widget rightNChoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. Your Rights and Choices',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
        Text(
          'You have the right to:',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
        myWidgets.buildBulletPoint('Access and update your personal information.'),
        myWidgets.buildBulletPoint('Manage or delete your dependent’s information.'),
        myWidgets.buildBulletPoint(
          'Delete your account and request that your information be permanently erased.',
        ),
        myWidgets.buildBulletPoint(
          'Opt-out of non-essential notifications at any time.\n',
        ),
      ],
    );
  }

  Widget infomationWeCollect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.black,
            ),

            children: [
              TextSpan(
                text: '1. Information We Collect\n',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),

              TextSpan(text: 'When you use MedPlan, we may collect:'),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•', style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 5.w),

            Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),

                  children: [
                    TextSpan(
                      text: 'Personal Information:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          ' such as your name, email address, phone number, and information about your dependents if you manage medications on their behalf.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•', style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 5.w),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),

                  children: [
                    TextSpan(
                      text: 'Health Information:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          ' such as your name, email address, phone number, and information about your dependents if you manage medications on their behalf.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•', style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 5.w),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),

                  children: [
                    TextSpan(
                      text: 'Communication Data:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          ' conversations you have with pharmacists via our free chat feature.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•', style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 5.w),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),

                  children: [
                    TextSpan(
                      text: 'Usage Data:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          ' including information about how you use articles, video blogs, and other educational content on the app.\n',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  

  Widget protectInformation() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black,
        ),

        children: [
          TextSpan(
            text: '3. How We Protect Your Information\n',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text:
                'We implement a variety of security measures to maintain the safety of your personal and health information, including encryption, secure servers, and access controls. Only authorized personnel and healthcare professionals have access to sensitive data.\n',
          ),
        ],
      ),
    );
  }

  Widget childrenPolicy() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black,
        ),

        children: [
          TextSpan(
            text: '6. Children\'s Privacy\n',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text:
                'MedPlan is not intended for children under the age of 13 without parental consent. If you manage medications for minors, we assume you are their parent or legal guardian.\n',
          ),
        ],
      ),
    );
  }

  Widget changeToPolicy() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black,
        ),

        children: [
          TextSpan(
            text: '7. Changes to this Privacy Policy\n',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text:
                'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting a notice in the app or sending an email.\n',
          ),
        ],
      ),
    );
  }

  Widget contactUsPolicy() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black,
        ),

        children: [
          TextSpan(
            text: '8. Contact Us\n',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text:
                'If you have any questions about this Privacy Policy or your information, please contact us at:\n',
          ),
          TextSpan(
            text: 'medplan.help@gmail.com',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).primaryColor,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      Uri(scheme: 'mailto', path: 'medplan.help@gmail.com'),
                    );
                  },
          ),
        ],
      ),
    );
  }
}


// Effective Date: April 30th, 2025
// At MedPlan, your privacy is important to us. We are committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.

// 1. Information We Collect
// When you use MedPlan, we may collect:
// Personal Information: such as your name, email address, phone number, and information about your dependents if you manage medications on their behalf.
// Health Information: including your medication schedules, reminders, health vitals (e.g., blood pressure, blood sugar levels), and health history.
// Communication Data: conversations you have with pharmacists via our free chat feature.
// Usage Data: including information about how you use articles, video blogs, and other educational content on the app.

// 2. How We Use Your Information
// We use your information to:
// Help you manage your medications and health vitals.
// Enable you to care for dependents and receive medication reminders through your companion feature.
// Provide access to trusted pharmacists for free health consultations.
// Send you reminders, educational content, and health tips.
// Improve our services and user experience.

// 3. How We Protect Your Information
// We implement a variety of security measures to maintain the safety of your personal and health information, including encryption, secure servers, and access controls. Only authorized personnel and healthcare professionals have access to sensitive data.

// 4. Sharing of Information
// We do not sell, rent, or share your personal information with third parties except:
// With your explicit consent.
// With licensed healthcare professionals who are bound by confidentiality agreements.
// If required by law (e.g., legal requests, regulatory compliance).

// 5. Your Rights and Choices
// You have the right to:
// Access and update your personal information.
// Manage or delete your dependent’s information.
// Delete your account and request that your information be permanently erased.
// Opt-out of non-essential notifications at any time.

// 6. Children's Privacy
// MedPlan is not intended for children under the age of 13 without parental consent. If you manage medications for minors, we assume you are their parent or legal guardian.

// 7. Changes to this Privacy Policy
// We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting a notice in the app or sending an email.

// 8. Contact Us
// If you have any questions about this Privacy Policy or your information, please contact us at:
// 📧 medplan.help@gmail.com

