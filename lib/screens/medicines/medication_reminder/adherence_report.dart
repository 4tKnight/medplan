import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/adherence_report_service.dart';
import 'package:medplan/screens/medicines/medication_reminder/share_adherence_report.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

class AdherenceReport extends StatefulWidget {
  const AdherenceReport({super.key});

  @override
  State<AdherenceReport> createState() => _AdherenceReportState();
}

class _AdherenceReportState extends State<AdherenceReport> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    futureData = _adherenceReportService.viewAdherenceReports(
      month: month - 1,
      year: year,
    );
  }

  late Future<dynamic> futureData;
  final AdherenceReportService _adherenceReportService =
      AdherenceReportService();
  List<dynamic> adherenceReportList = [];
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myWidgets.buildRecordDateWidget(
              month: month,
              year: year,
              setDateFunc: (month, year) {
                setState(() {
                  this.month = month;
                  this.year = year;
                });
                loadFuture();
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => ShareAdherenceReport(
                      adherenceReportList: adherenceReportList,
                      selectedDate: "${time.getMonthString(month)} $year",
                    ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/button_share.png",
                fit: BoxFit.cover,
                height: 17.h,
                width: 12.w,
              ),
              SizedBox(width: 7.w),
              Text(
                'Forward ${time.getMonthString(month)} Report to Companion',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 39.h),
        FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return helperWidget.noInternetScreen(() {
                setState(() {
                  loadFuture();
                });
              });
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No adherence Report for the selected Date",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else {
              my_log(snapshot.data);
              if (snapshot.data['count'] > 0) {
                adherenceReportList = snapshot.data['adherence_reports'];
              } else {
                adherenceReportList = [];
              }
              return adherenceReportList.isEmpty
                  ? Center(
                    child: Text(
                      "No adherence Report for the selected Date",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildMAdherenceWidget(adherenceReportList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16.h);
                    },
                    itemCount: adherenceReportList.length,
                  );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildMAdherenceWidget(var adherenceReportData) {
    return Container(
      // height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey, width: 0.2),
      ),
      child: Column(
        children: [
          Container(
            height: 4.h,
            // width: double.maxFinite,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                topLeft: Radius.circular(8.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 8.h,
              bottom: 11.h,
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(200.r),
                      child: Image.asset(
                        "${constants.dosageImages[adherenceReportData['dosage_form']]}",
                        fit: BoxFit.cover,
                        height: 40.h,
                        width: 45.w,
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${adherenceReportData['medicine_name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            'Take ${adherenceReportData['dosage_quantity']}, ${adherenceReportData['daily_dosage']} times a day for ${adherenceReportData['duration']} days',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "${adherenceReportCommentAndImage(adherenceReportData['percentage'])['image']}",
                      fit: BoxFit.cover,
                      height: 35.r,
                      width: 35.r,
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Text(
                  '"${adherenceReportCommentAndImage(adherenceReportData['percentage'])['comment_1']}${adherenceReportData['medicine_name']}${adherenceReportCommentAndImage(0)['comment_2']}"',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> adherenceReportCommentAndImage(int percentage) {
    if (percentage >= 90) {
      return constants.adherenceComment[0];
    } else if (percentage >= 80 && percentage <= 89) {
      return constants.adherenceComment[1];
    } else if (percentage >= 70 && percentage <= 79) {
      return constants.adherenceComment[2];
    } else if (percentage >= 50 && percentage <= 69) {
      return constants.adherenceComment[3];
    } else {
      return constants.adherenceComment[4];
    }
  }
}
