import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class RandomBloodGlucose extends StatefulWidget {
  final String dependentId;
  const RandomBloodGlucose({super.key,this.dependentId=''});

  @override
  State<RandomBloodGlucose> createState() => _RandomBloodGlucoseState();
}

class _RandomBloodGlucoseState extends State<RandomBloodGlucose> {
  String language = 'English';
  String content =
      "A random glucose test is one method for measuring the amount of glucose or sugar circulating in a person’s blood at any time of day. For a glucose tolerance test, normal ranges are typically 140 mg/dl or slightly lower. Prediabetes: 140–199 mg/dl. Diabetes: >=200 mg/dl.";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int minReading = 0;
  int maxReading = 0;
  int avgReading = 0;
  List<dynamic> readings = [];
  String fieldName = 'random_bg';

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
      var res = await _healthRecordServices.viewRandomBloodGlucose(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading = data['bg_random_bg']['min_reading'] ?? 0;
          maxReading = data['bg_random_bg']['max_reading'] ?? 0;
          avgReading = (data['bg_random_bg']['avg_reading'] ?? 0).toInt();
          readings = data['bg_random_bg']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, 'Random Blood Glucose'),
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
                    'Random B. Glucose',
                    'blood_glucose2',
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
                    'RBG (mg/dl)',
                    300,
                    0,
                    30,
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
      'What is Random Blood Glucose?',

      Text.rich(
        TextSpan(
          text:
              "A random glucose test is one method for measuring the amount of glucose or sugar circulating in a person’s blood at any time of day. For a glucose tolerance test, normal ranges are typically ",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            TextSpan(
              text: "140 mg/dl",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
            TextSpan(
              text:
                  " or slightly lower. Prediabetes: 140–199 mg/dl. Diabetes: >=200 mg/dl.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildAddButton() {
    return InkWell(
      onTap: () {
        buildAddBottomSheet();
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

  TextEditingController recordValueController = TextEditingController();
  Future<dynamic> buildAddBottomSheet() {
    bool isLoading = false;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter RBG (mg/dl)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          time.dateFromTimestamp(
                            DateTime.now().millisecondsSinceEpoch,
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      // height: 45,
                      child: TextField(
                        autofocus: true,
                        controller: recordValueController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          isDense: true,

                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              width: 1.h,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.r),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Center(
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());

                                  if (recordValueController.text.isEmpty) {
                                    helperWidget.showToast(
                                      "Please enter RBG value",
                                    );
                                    return;
                                  }
                                  setCustomState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    var recordData = {
                                      'timestamp':
                                          DateTime.now().millisecondsSinceEpoch,
                                      fieldName: int.parse(
                                        recordValueController.text,
                                      ),
                                    };

                                    var res = await _healthRecordServices
                                        .addRandomBloodGlucose(
                                          reading: recordData,
                                          month: month - 1,
                                          dependentId: widget.dependentId,
                                          year: year,
                                        );
                                    my_log(res);
                                    if (res['status'] == 'ok') {
                                      setState(() {
                                        readings.add(recordData);
                                        helperWidget.showToast(
                                          "Record updated successfully",
                                        );
                                        recordValueController.clear();
                                        var data = res['health_record'];
                                        minReading =
                                            data['bg_random_bg']['min_reading'] ??
                                            0;
                                        maxReading =
                                            data['bg_random_bg']['max_reading'] ??
                                            0;
                                        avgReading =
                                            (data['bg_random_bg']['avg_reading'] ??
                                                    0)
                                                .toInt();
                                        readings =
                                            data['bg_random_bg']['readings'] ??
                                            [];
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      helperWidget.showToast(
                                        "Failed to update record",
                                      );
                                    }
                                  } catch (e) {
                                    my_log(e);

                                    helperWidget.showToast(
                                      "Failed to update record",
                                    );
                                  } finally {
                                    setCustomState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 30.w,
                          ),
                        ),
                        child:
                            isLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                  'Save Record',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
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
      },
    );
  }
}
