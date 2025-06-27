import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';

import '../../../utils/global.dart';

class BodyMassIndex extends StatefulWidget {
  const BodyMassIndex({super.key});

  @override
  State<BodyMassIndex> createState() => _BodyMassIndexState();
}

class _BodyMassIndexState extends State<BodyMassIndex> {
  String language = 'English';
  String content =
      "Body Mass Index (BMI) is a calculation that estimates body fat based on a person's height and weight. It is a screening tool to help assess a person's risk of developing health conditions associated with higher body fat, such as heart disease, high blood pressure, and type 2 diabetes.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Body Mass Index (BMI)',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        children: [
          myWidgets.buildChangeLanguageWidget(content, language, (language) {
            setState(() {
              this.language = language;
            });
          }),
          SizedBox(height: 10.h),
          CustomExpandableWidget(
            'What is Body Mass Index (BMI) ?',
            Text(
              content,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: myWidgets.commonContainerDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI Targets',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 11.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'BMI',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Weight Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.h, bottom: 8.w),
                  child: helperWidget.build_divider(),
                ),
                buildBMITable(
                  'Below 18.5',
                  'Underweight',
                  'You are underweight, you may need to put on some weight. You are recommended to ask your doctor or a dietitian for advice.',
                ),
                _divider(),
                buildBMITable(
                  '18.5- 24.9',
                  'Normal or Healthy weight',
                  'You are at healthy weight for your height. By maintaining a healthy weight you lower your risk of developing serious health problems.',
                ),
                _divider(),
                buildBMITable(
                  '25.0- 29.9',
                  'Over weight',
                  'You are slightly overweight. You may be advised to lose some weight for health reasons. You are recommended to talk to your doctor or a dietitian for advice.',
                ),
                _divider(),
                buildBMITable(
                  '30.0 & Above',
                  'Obese',
                  'You are heavily overweight. Your health may be at risk if you do not lose weight. You are recommended to talk to your doctor or dietitian for advice.',
                ),
                // _divider(),
              ],
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 3, bottom: 8.0),
      child: Divider(height: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
    );
  }

  Row buildBMITable(String bmiLevel, String bmiStatusTitle, String bmiStatus) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            bmiLevel,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bmiStatusTitle,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
              ),
              const SizedBox(height: 3),
              Text(
                bmiStatus,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
