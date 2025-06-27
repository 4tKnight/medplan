import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class BloodPressure extends StatefulWidget {
  String dependentId;
   BloodPressure({super.key,this.dependentId = ''});

  @override
  State<BloodPressure> createState() => _BloodPressureState();
}

class _BloodPressureState extends State<BloodPressure> {
  String language = 'English';
  String content =
      "Blood pressure is the force of your blood pushing against the walls of your arteries as your heart pumps it around your body. A normal, healthy blood pressure range for adults is typically around 120/80 mmHg, where 120 represents the pressure when the heart beats (systolic) and 80 represents the pressure when the heart is resting between beats (diastolic). Both are measured in units called millimetres of mercury (mmHg).";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  String minReading = '--';
  String maxReading = '--';
  String avgReading = '--';
  List<dynamic> readings = [];

  @override
  void initState() {
    super.initState();
    fetchBloodPressure();
  }

  final HealthRecordServices _healthRecordServices = HealthRecordServices();
  List<dynamic> healthRecordList = [];
  bool isLoading = true;

  fetchBloodPressure() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await _healthRecordServices.viewBloodPressure(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading =
              "${(data['cv_blood_pressure']['upper_min_reading']).toInt()}/${(data['cv_blood_pressure']['lower_min_reading']).toInt()}";
          maxReading =
              "${(data['cv_blood_pressure']['upper_max_reading']).toInt()}/${(data['cv_blood_pressure']['lower_max_reading']).toInt()}";
          avgReading =
              "${(data['cv_blood_pressure']['upper_avg_reading']).toInt()}/${(data['cv_blood_pressure']['lower_avg_reading']).toInt()}";
          readings = data['cv_blood_pressure']['readings'] ?? [];
        } else {
          minReading = '--';
          maxReading = '--';
          avgReading = '--';
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
      appBar: helperWidget.myAppBar(context, 'Blood Pressure'),
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
                children: [
                  healthRecordWidgets.buildRecordValueArea(
                    'Blood Pressure',
                    'blood_pressure',
                    '',
                    'mmHg',
                    buildAddButton(),
                    fieldName: 'lower_value',
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
                          fetchBloodPressure();
                        }),
                  ),
                  SizedBox(height: 16.h),
                  healthRecordWidgets.buildChartArea(
                    'Systolic BP (mmHg)',
                    300,
                    0,
                    30,
                    fieldName: 'lower_value',

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
      'What is Blood Pressure?',

      Text.rich(
        TextSpan(
          text:
              "Blood pressure is the force of your blood pushing against the walls of your arteries as your heart pumps it around your body. A normal, healthy blood pressure range for adults is typically around ",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            TextSpan(
              text: "120/80 mmHg",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
            TextSpan(
              text:
                  ", where 120 represents the pressure when the heart beats (systolic) and 80 represents the pressure when the heart is resting between beats (diastolic). Both are measured in units called millimetres of mercury (mmHg).",
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

  TextEditingController recordUpperValueController = TextEditingController();
  TextEditingController recordLowerValueController = TextEditingController();

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
                          'Enter Blood Pressure (mmHg)',
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
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Systolic: Upper value ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              SizedBox(
                                // height: 45,
                                child: TextField(
                                  controller: recordUpperValueController,
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
                            ],
                          ),
                        ),
                        SizedBox(width: 14.sp),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diastolic: Lower value ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 3),
                              SizedBox(
                                // height: 45,
                                child: TextField(
                                  controller: recordLowerValueController,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 23.h),
                    Center(
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());

                                  if (recordUpperValueController.text.isEmpty) {
                                    helperWidget.showToast(
                                      "Please enter upper value",
                                    );
                                    return;
                                  }
                                  if (recordLowerValueController.text.isEmpty) {
                                    helperWidget.showToast(
                                      "Please enter lower value",
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
                                      'upper_value': int.parse(
                                        recordUpperValueController.text,
                                      ),
                                      'lower_value': int.parse(
                                        recordLowerValueController.text,
                                      ),
                                    };

                                    var res = await _healthRecordServices
                                        .addBloodPressure(
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
                                        recordUpperValueController.clear();
                                        recordLowerValueController.clear();
                                        var data = res['health_record'];
                                        minReading =
                                            "${(data['cv_blood_pressure']['upper_min_reading']).toInt()}/${(data['cv_blood_pressure']['lower_min_reading']).toInt()}";
                                        maxReading =
                                            "${(data['cv_blood_pressure']['upper_max_reading']).toInt()}/${(data['cv_blood_pressure']['lower_max_reading']).toInt()}";
                                        avgReading =
                                            "${(data['cv_blood_pressure']['upper_avg_reading']).toInt()}/${(data['cv_blood_pressure']['lower_avg_reading']).toInt()}";
                                        readings =
                                            data['cv_blood_pressure']['readings'] ??
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
