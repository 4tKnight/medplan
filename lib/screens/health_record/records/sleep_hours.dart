import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class SleepHours extends StatefulWidget {
  final String dependentId;
  const SleepHours({super.key, this.dependentId=''});

  @override
  State<SleepHours> createState() => _SleepHoursState();
}

class _SleepHoursState extends State<SleepHours> {
  String language = 'English';
  String content =
      "Getting enough sleep can help strengthen your heart and reduce your risk of developing high blood pressure and heart disease. Sleeping fewer than 7 hours per night is linked to an increased risk of death from heart disease. Experts recommend that adults sleep between 7 and 9 hours a night. Adults who sleep less than 7 hours a night may have more health issues than those who sleep 7 or more hours a night.";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int minReading = 0;
  int maxReading = 0;
  int avgReading = 0;
  List<dynamic> readings = [];

  String fieldName = 'sleep_hours';

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
      var res = await _healthRecordServices.viewSleepHours(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading = data['fitness_sleep_hours']['min_reading'] ?? 0;
          maxReading = data['fitness_sleep_hours']['max_reading'] ?? 0;
          avgReading =
              (data['fitness_sleep_hours']['avg_reading'] ?? 0).toInt();
          readings = data['fitness_sleep_hours']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, 'Sleep Hours'),
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
                    'Sleep Hours',
                    'sleep_hours',
                    '',
                    'hours',
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
                    'Sleep Hours (hours)',
                    20,
                    0,
                    2,
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
      'What is Sleep Hours?',

      Text.rich(
        TextSpan(
          text:
              "Getting enough sleep can help strengthen your heart and reduce your risk of developing high blood pressure and heart disease. Sleeping fewer than 7 hours per night is linked to an increased risk of death from heart disease. Experts recommend that adults sleep between 7 and 9 hours a night. Adults who sleep less than 7 hours a night may have more health issues than those who sleep 7 or more hours a night.",
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
          title: 'Sleep Hours (hours)',
          recordName: 'Sleep Hours',
          fieldName: fieldName,
          month: month,
          year: year,
          apiCall: (recordData) {
            return _healthRecordServices.addSleepHours(
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
              minReading = data['fitness_sleep_hours']['min_reading'] ?? 0;
              maxReading = data['fitness_sleep_hours']['max_reading'] ?? 0;
              avgReading =
                  (data['fitness_sleep_hours']['avg_reading'] ?? 0).toInt();
              readings = data['fitness_sleep_hours']['readings'] ?? [];
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

  Future<dynamic> buildAddBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enter Sleep Hours(hours)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      time.dateFromTimestamp(
                        DateTime.now().millisecondsSinceEpoch,
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  height: 45,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle save
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                    ),
                    child: const Text(
                      'Save Record',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
