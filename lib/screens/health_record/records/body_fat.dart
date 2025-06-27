import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class BodyFat extends StatefulWidget {
  String dependentId;

   BodyFat({super.key,  this.dependentId=''});

  @override
  State<BodyFat> createState() => _BodyFatState();
}

class _BodyFatState extends State<BodyFat> {
  String language = 'English';
  String content =
      "Body fat percentage is the proportion of fat in your body compared to your total body composition. It's a key indicator of health and can help determine if someone is overweight, obese, or at a healthy weight. Higher body fat percentages are associated with an increased risk of chronic disease, such as heart and circulatory diseases and type 2 diabetes. A healthy body fat percentage is 18–24% for men and 25–31% for women. ";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int minReading = 0;
  int maxReading = 0;
  int avgReading = 0;
  List<dynamic> readings = [];

  String fieldName = 'percentage';

  @override
  void initState() {
    super.initState();
    fetchRecord();
  }

  final HealthRecordServices _healthRecordServices = HealthRecordServices();
  List<dynamic> healthRecordList = [];
  bool isLoading = true;

  fetchRecord() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await _healthRecordServices.viewBodyFatPercentage(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading = data['fitness_body_fat_percentage']['min_reading'] ?? 0;
          maxReading = data['fitness_body_fat_percentage']['max_reading'] ?? 0;
          avgReading =
              (data['fitness_body_fat_percentage']['avg_reading'] ?? 0).toInt();
          readings = data['fitness_body_fat_percentage']['readings'] ?? [];
        } else {
          minReading = 0;
          maxReading = 0;
          avgReading = 0;
          readings = [];
        }
      }
    } catch (e) {
      helperWidget.showToast('Failed to fetch records');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Body Fat Percentage'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        children: [
          myWidgets.buildChangeLanguageWidget(content, language, (language) {
            setState(() {
              this.language = language;
            });
          }),
          SizedBox(height: 10.h),
          buildRecordDescriptionArea(),
          SizedBox(height: 14.h),
          isLoading
              ? CupertinoActivityIndicator()
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  healthRecordWidgets.buildRecordValueArea(
                    'Body Fat Percentage',
                    'body_fat',
                    '',
                    '%',
                    buildAddButton(),
                    fieldName: fieldName,
                    maxReading: maxReading,
                    minReading: minReading,
                    avgReading: avgReading,
                    readings: readings,
                    month: month,
                    year: year,
                    setDateFunc:
                        (month, year) => setState(() {
                          this.month = month;
                          this.year = year;
                          fetchRecord();
                        }),
                  ),
                  SizedBox(height: 16.h),
                  healthRecordWidgets.buildChartArea(
                    'Body Fat Percentage (%)',
                    100,
                    0,
                    10,
                    fieldName: fieldName,

                    month: month,
                    readings: readings,
                  ),
                  const SizedBox(height: 55),
                ],
              ),
        ],
      ),
    );
  }

  CustomExpandableWidget buildRecordDescriptionArea() {
    return CustomExpandableWidget(
      'What is Body Fat Percentage?',

      Text.rich(
        TextSpan(
          text:
              "Body fat percentage is the proportion of fat in your body compared to your total body composition. It's a key indicator of health and can help determine if someone is overweight, obese, or at a healthy weight. Higher body fat percentages are associated with an increased risk of chronic disease, such as heart and circulatory diseases and type 2 diabetes. A healthy body fat percentage is 18–24% for men and 25–31% for women. ",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            // TextSpan(
            //   text: "99 mg/dL",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14,
            //   ),
            // ),
            // TextSpan(
            //   text: " or slightly lower. 100–125 mg/dL typically indicates prediabetes. 126 mg/dL or above indicates high blood sugar, the main sign of diabetes.",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     fontSize: 14,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  InkWell buildAddButton() {
    return InkWell(
      onTap: () {
        myWidgets.buildAddBottomSheet(
          context: context,
          title: 'Enter Body Fat Percentage value (%)',
          recordName: 'Body Fat Percentage',
          fieldName: fieldName,
          month: month,
          year: year,
          apiCall: (recordData) {
            return _healthRecordServices.addBodyFatPercentage(
              dependentId: widget.dependentId,
              reading: recordData,
              month: DateTime.now().month - 1,
              year: DateTime.now().year,
            );
          },
          onSuccess: (recordData, res) {
            setState(() {
              readings.add(recordData);
              helperWidget.showToast("Record updated successfully");
              var data = res['health_record'];
              minReading =
                  data['fitness_body_fat_percentage']['min_reading'] ?? 0;
              maxReading =
                  data['fitness_body_fat_percentage']['max_reading'] ?? 0;
              avgReading =
                  (data['fitness_body_fat_percentage']['avg_reading'] ?? 0)
                      .toInt();
              readings = data['fitness_body_fat_percentage']['readings'] ?? [];
            });
          },
        );
      },
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 15),
        ),
      ),
    );
  }

  // Future<dynamic> buildAddBottomSheet() {
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Container(
  //           height: MediaQuery.of(context).size.height * 0.3,
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     'Enter Body Fat Percentage value (%)',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     time.dateFromTimestamp(
  //                       DateTime.now().millisecondsSinceEpoch,
  //                     ),
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 30),
  //               const SizedBox(
  //                 height: 45,
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(4)),
  //                     ),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                 ),
  //               ),
  //               const SizedBox(height: 25),
  //               Center(
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     // Handle save
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Theme.of(context).primaryColor,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(6.0),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(
  //                       vertical: 10,
  //                       horizontal: 30,
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Save Record',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
