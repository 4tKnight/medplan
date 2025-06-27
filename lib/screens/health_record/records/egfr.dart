import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class EGFR extends StatefulWidget {
  final String dependentId;

  const EGFR({super.key,this.dependentId=''});

  @override
  State<EGFR> createState() => _EGFRState();
}

class _EGFRState extends State<EGFR> {
  String name = 'Estimate Glomerular Filtration rate';
  String unit = 'mL/min';
  String language = 'English';
  String content =
      "An estimated glomerular filtration rate (eGFR) is a calculation that estimates how well your kidneys filter waste and toxins from your blood. It's calculated using a blood test that measures creatinine levels, along with your age, weight, height, and sex. eGFR is reported in milliliters of cleansed blood per minute per body surface area (mL/min/1.73m2). The normal GFR is 60-110mL/min.";

  int month = DateTime.now().month;
  int year = DateTime.now().year;
  double minReading = 0;
  double maxReading = 0;
  double avgReading = 0;
  List<dynamic> readings = [];

  String fieldName = 'eGFR_value';

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
      var res = await _healthRecordServices.viewEGFR(
        dependentId: widget.dependentId,
        month: month - 1,
        year: year,
      );

      my_log(res);
      if (res['status'] == 'ok') {
        if (res['health_record'] != null) {
          var data = res['health_record'];
          minReading =
              data['lab_tests_eGFR']['min_reading'] is int
                  ? (data['lab_tests_eGFR']['min_reading'] as int).toDouble()
                  : (data['lab_tests_eGFR']['min_reading'] ?? 0.0);
          maxReading =
              data['lab_tests_eGFR']['max_reading'] is int
                  ? (data['lab_tests_eGFR']['max_reading'] as int).toDouble()
                  : (data['lab_tests_eGFR']['max_reading'] ?? 0.0);
          if (data['lab_tests_eGFR']['avg_reading'] is int) {
            double tempAvg =
                (data['lab_tests_eGFR']['avg_reading'] as int).toDouble();
            if (tempAvg.toStringAsFixed(1) == 'NaN') {
              avgReading = 0.0;
            } else {
              avgReading = double.parse(tempAvg.toStringAsFixed(1));
            }
          } else if ((data['lab_tests_eGFR']['avg_reading'] ?? 0.0) is double) {
            avgReading = double.parse(
              (data['lab_tests_eGFR']['avg_reading'] ?? 0.0).toStringAsFixed(1),
            );
          } else {
            avgReading = double.parse(
              ((data['lab_tests_eGFR']['avg_reading'] ?? 0.0) as num)
                  .toDouble()
                  .toStringAsFixed(1),
            );
          }
          readings = data['lab_tests_eGFR']['readings'] ?? [];
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
      appBar: helperWidget.myAppBar(context, name),
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
                    name,
                    'eGFR',
                    '',
                    unit,
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
                    '$name ($unit)',
                    2.0,
                    0.0,
                    0.2,
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
      'What is $name?',

      Text.rich(
        TextSpan(
          text:
              "An estimated glomerular filtration rate (eGFR) is a calculation that estimates how well your kidneys filter waste and toxins from your blood. It's calculated using a blood test that measures creatinine levels, along with your age, weight, height, and sex. eGFR is reported in milliliters of cleansed blood per minute per body surface area (mL/min/1.73m2). The normal GFR is 60-110mL/min.",
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
          title: 'Enter Creatinine value (mg/dl)',
          recordName: 'Creatine',
          fieldName: fieldName,
          month: month,
          year: year,
          apiCall: (recordData) {
            return _healthRecordServices.addEGFR(
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
                  data['lab_tests_eGFR']['min_reading'] is int
                      ? (data['lab_tests_eGFR']['min_reading'] as int)
                          .toDouble()
                      : (data['lab_tests_eGFR']['min_reading'] ?? 0.0);
              maxReading =
                  data['lab_tests_eGFR']['max_reading'] is int
                      ? (data['lab_tests_eGFR']['max_reading'] as int)
                          .toDouble()
                      : (data['lab_tests_eGFR']['max_reading'] ?? 0.0);
              if (data['lab_tests_eGFR']['avg_reading'] is int) {
                double tempAvg =
                    (data['lab_tests_eGFR']['avg_reading'] as int).toDouble();
                if (tempAvg.toStringAsFixed(1) == 'NaN') {
                  avgReading = 0.0;
                } else {
                  avgReading = double.parse(tempAvg.toStringAsFixed(1));
                }
              } else if ((data['lab_tests_eGFR']['avg_reading'] ?? 0.0)
                  is double) {
                avgReading = double.parse(
                  (data['lab_tests_eGFR']['avg_reading'] ?? 0.0)
                      .toStringAsFixed(1),
                );
              } else {
                avgReading = double.parse(
                  ((data['lab_tests_eGFR']['avg_reading'] ?? 0.0) as num)
                      .toDouble()
                      .toStringAsFixed(1),
                );
              }
              readings = data['lab_tests_eGFR']['readings'] ?? [];
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
  //                   Text(
  //                     'Enter eGFR value ($unit)',
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
