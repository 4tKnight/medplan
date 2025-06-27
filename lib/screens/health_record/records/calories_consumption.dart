import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class CaloriesConsumption extends StatefulWidget {
  String dependentId;
  CaloriesConsumption({super.key,this.dependentId = ''});

  @override
  State<CaloriesConsumption> createState() => _CaloriesConsumptionState();
}

class _CaloriesConsumptionState extends State<CaloriesConsumption> {
  String language = 'English';
  String content =
      "Calorie consumption, also known as caloric intake, is the amount of energy a person consumes through food and drinks. The number of calories a person needs depends on their age, sex, height, lifestyle, and activity level. \nTo lose weight, a person needs to consume fewer calories than their body burns. To gain weight, a person needs to consume more calories than they expend. \nCounting calories is one way to monitor weight loss. ";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int minReading = 0;
  int maxReading = 0;
  int avgReading = 0;
  List<dynamic> readings = [];

  String fieldName = 'calory_value';

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
      var res = await _healthRecordServices.viewCaloryConsumption(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading = data['fitness_calory_consumption']['min_reading'] ?? 0;
          maxReading = data['fitness_calory_consumption']['max_reading'] ?? 0;
          avgReading =
              (data['fitness_calory_consumption']['avg_reading'] ?? 0).toInt();
          readings = data['fitness_calory_consumption']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, 'Calories consumption'),
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
                    'Calories consumption',
                    'calories',
                    '',
                    'Kcal.',
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
                    'Calories consumption (Kcal.)',
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
      'What is Calories consumption?',

      Text.rich(
        TextSpan(
          text:
              "Calorie consumption, also known as caloric intake, is the amount of energy a person consumes through food and drinks. The number of calories a person needs depends on their age, sex, height, lifestyle, and activity level. \nTo lose weight, a person needs to consume fewer calories than their body burns. To gain weight, a person needs to consume more calories than they expend. \nCounting calories is one way to monitor weight loss. ",
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
          title: 'Enter Calories consumption (Kcal.)',
          recordName: 'Calories consumption',
          fieldName: fieldName,
          month: month,
          year: year,
          apiCall: (recordData) {
            return _healthRecordServices.addCaloryConsumption(
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
                  data['fitness_calory_consumption']['min_reading'] ?? 0;
              maxReading =
                  data['fitness_calory_consumption']['max_reading'] ?? 0;
              avgReading =
                  (data['fitness_calory_consumption']['avg_reading'] ?? 0)
                      .toInt();
              readings = data['fitness_calory_consumption']['readings'] ?? [];
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
  //                     'Enter Calories consumption value (Kcal.)',
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
