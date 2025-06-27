import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class Triglycerides extends StatefulWidget {
  final String dependentId;
  const Triglycerides({this.dependentId = '', super.key});

  @override
  State<Triglycerides> createState() => _TriglyceridesState();
}

class _TriglyceridesState extends State<Triglycerides> {
  String language = 'English';
  String content =
      "Triglycerides are a type of fat that circulate in your blood and are the most common fat in your body. They come from the food you eat, especially butter, oils, and other fats, as well as any extra calories your body doesn't need right away. Triglycerides are important for good health, but high levels can increase your risk of heart disease and stroke. Normal adult values is <150mg/dl.";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int minReading = 0;
  int maxReading = 0;
  int avgReading = 0;
  List<dynamic> readings = [];

  String fieldName = 'tri_value';

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
      var res = await _healthRecordServices.viewTriglycerides(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading = data['bc_triglycerides']['min_reading'] ?? 0;
          maxReading = data['bc_triglycerides']['max_reading'] ?? 0;
          avgReading = (data['bc_triglycerides']['avg_reading'] ?? 0).toInt();
          readings = data['bc_triglycerides']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, 'Triglycerides'),
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
                    'Triglycerides',
                    'trigly',
                    '',
                    'mg/dl',
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
                    'Triglycerides (mg/dl)',
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
      'What is Triglycerides?',

      Text.rich(
        TextSpan(
          text:
              "Triglycerides are a type of fat that circulate in your blood and are the most common fat in your body. They come from the food you eat, especially butter, oils, and other fats, as well as any extra calories your body doesn't need right away. Triglycerides are important for good health, but high levels can increase your risk of heart disease and stroke. Normal adult values is <150mg/dl.",
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
          title: 'Enter Triglycerides value (mg/dl)',
          recordName: 'Triglycerides',
          fieldName: fieldName,
          month: month,
          year: year,
          apiCall: (recordData) {
            return _healthRecordServices.addTriglycerides(
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
              minReading = data['bc_triglycerides']['min_reading'] ?? 0;
              maxReading = data['bc_triglycerides']['max_reading'] ?? 0;
              avgReading =
                  (data['bc_triglycerides']['avg_reading'] ?? 0).toInt();
              readings = data['bc_triglycerides']['readings'] ?? [];
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
  //                     'Enter Triglycerides value (mg/dl)',
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
