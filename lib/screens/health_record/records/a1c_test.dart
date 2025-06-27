import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class A1CTest extends StatefulWidget {
  String dependentId;
  A1CTest({super.key,this.dependentId=''});

  @override
  State<A1CTest> createState() => _A1CTestState();
}

class _A1CTestState extends State<A1CTest> {
  String language = 'English';
  String content =
      "An A1C test measures the average amount of glucose (sugar) in your blood over the past three months. The result is reported as a percentage. The higher the percentage, the higher your blood glucose levels have been, on average. For people without diabetes, a normal A1C is below 5.7%";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  double minReading = 0;
  double maxReading = 0;
  double avgReading = 0;
  List<dynamic> readings = [];

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
      var res = await _healthRecordServices.viewA1cTest(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading =
              data['bg_a1c_test']['min_reading'] is int
                  ? (data['bg_a1c_test']['min_reading'] as int).toDouble()
                  : (data['bg_a1c_test']['min_reading'] ?? 0.0);
          maxReading =
              data['bg_a1c_test']['max_reading'] is int
                  ? (data['bg_a1c_test']['max_reading'] as int).toDouble()
                  : (data['bg_a1c_test']['max_reading'] ?? 0.0);
          if (data['bg_a1c_test']['avg_reading'] is int) {
            double tempAvg =
                (data['bg_a1c_test']['avg_reading'] as int).toDouble();
            if (tempAvg.toStringAsFixed(1) == 'NaN') {
              avgReading = 0.0;
            } else {
              avgReading = double.parse(tempAvg.toStringAsFixed(1));
            }
          } else if ((data['bg_a1c_test']['avg_reading'] ?? 0.0) is double) {
            avgReading = double.parse(
              (data['bg_a1c_test']['avg_reading'] ?? 0.0).toStringAsFixed(1),
            );
          } else {
            avgReading = double.parse(
              ((data['bg_a1c_test']['avg_reading'] ?? 0.0) as num)
                  .toDouble()
                  .toStringAsFixed(1),
            );
          }
          readings = data['bg_a1c_test']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, 'AC1 Test'),
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
                    'A1C Test',
                    'a1c_test',
                    '',
                    '%',
                    buildAddButton(),
                    fieldName: 'percentage',
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
                    'A1C Test (%)',
                    200,
                    0,
                    20,
                    fieldName: 'percentage',

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
      'What is A1C Test?',

      Text.rich(
        TextSpan(
          text:
              "An A1C test measures the average amount of glucose (sugar) in your blood over the past three months. The result is reported as a percentage. The higher the percentage, the higher your blood glucose levels have been, on average. For people without diabetes, a normal A1C is ",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            TextSpan(
              text: "below 5.7%",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
            TextSpan(
              text: ".",
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
                          'Enter A1C Test (%)',
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
                                      "Please enter A1C test",
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
                                      'percentage': int.parse(
                                        recordValueController.text,
                                      ),
                                    };

                                    var res = await _healthRecordServices
                                        .addA1cTest(
                                          dependentId: widget.dependentId,
                                          reading: recordData,
                                          month: month - 1,
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
                                            data['bg_a1c_test']['min_reading']
                                                    is int
                                                ? (data['bg_a1c_test']['min_reading']
                                                        as int)
                                                    .toDouble()
                                                : (data['bg_a1c_test']['min_reading'] ??
                                                    0.0);
                                        maxReading =
                                            data['bg_a1c_test']['max_reading']
                                                    is int
                                                ? (data['bg_a1c_test']['max_reading']
                                                        as int)
                                                    .toDouble()
                                                : (data['bg_a1c_test']['max_reading'] ??
                                                    0.0);
                                        if (data['bg_a1c_test']['avg_reading']
                                            is int) {
                                          double tempAvg =
                                              (data['bg_a1c_test']['avg_reading']
                                                      as int)
                                                  .toDouble();
                                          if (tempAvg.toStringAsFixed(1) ==
                                              'NaN') {
                                            avgReading = 0.0;
                                          } else {
                                            avgReading = double.parse(
                                              tempAvg.toStringAsFixed(1),
                                            );
                                          }
                                        } else if ((data['bg_a1c_test']['avg_reading'] ??
                                                0.0)
                                            is double) {
                                          avgReading = double.parse(
                                            (data['bg_a1c_test']['avg_reading'] ??
                                                    0.0)
                                                .toStringAsFixed(1),
                                          );
                                        } else {
                                          avgReading = double.parse(
                                            ((data['bg_a1c_test']['avg_reading'] ??
                                                        0.0)
                                                    as num)
                                                .toDouble()
                                                .toStringAsFixed(1),
                                          );
                                        }
                                        readings =
                                            data['bg_a1c_test']['readings'] ??
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
