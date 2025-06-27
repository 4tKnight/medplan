import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:share_plus/share_plus.dart';

class ShareAdherenceReport extends StatefulWidget {
  List<dynamic> adherenceReportList;
  String selectedDate;

  ShareAdherenceReport({
    super.key,
    required this.adherenceReportList,
    required this.selectedDate,
  });

  @override
  State<ShareAdherenceReport> createState() => _ShareAdherenceReportState();
}

class _ShareAdherenceReportState extends State<ShareAdherenceReport> {
  late ExportOptions options;
  late ExportDelegate exportDelegate;

  @override
  initState() {
    super.initState();
    options = ExportOptions(
      pageFormatOptions: PageFormatOptions.custom(width: 394.w, height: 722.h),
    );
    exportDelegate = ExportDelegate(
      options: options,
      ttfFonts: {
        'poppins-normal': 'assets/fonts/Poppins-Regular.ttf',
        'poppins-bold': 'assets/fonts/Poppins-Bold.ttf',
      },
    );
  }

  Future<void> shareReport() async {
    setState(() {
      isSharing = true;
    });

    try {
      final pdf = await exportDelegate.exportToPdfDocument(currentFrameId);

      final Directory dir = await getApplicationDocumentsDirectory();
      final File file = File(
        '${dir.path}/AdherenceReport-${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      await file.writeAsBytes(await pdf.save());
      await Share.shareXFiles([XFile(file.path)]);
      // debugPrint('Saved exported PDF at: ${file.path}');
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isSharing = false;
      });
    }
  }

  String currentFrameId = 'shareAdherenceReport';

  bool isSharing = false;

  String message = '''
Subject: Medication Adherence Report
Dear MedCompanion,
We hope this message finds you well.
Attached is the latest Medication Adherence Report for [Users’s Name], whom you support through MedPlan. This report covers their medication activity over the past month, giving you insight into how consistently they’ve been following their prescribed routine.

We appreciate your continued role as a Companion, helping [Users’s Name] stay consistent with their treatment and health goals. Your reminders and encouragement truly make a difference.
You can view the full report in the attached PDF. If you have any questions or need help interpreting the report, feel free to reach out.

Thank you for being a part of their care journey.

Warm regards, The MedPlan App Team medPlan.help@gmail.com Fostering Medication adherence and Health literacy.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Share Adherence Report"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
        children: [
          ExportFrame(
            frameId: currentFrameId,
            exportDelegate: exportDelegate,
            child: Container(
              padding: EdgeInsets.only(
                top: 26.h,
                bottom: 18.h,
                left: 7.w,
                right: 7.w,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(242, 242, 242, 1),
                border: Border.all(color: Color.fromRGBO(0, 0, 0, 1), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 12.w,
                      bottom: 10.h,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icon/icon.png",
                          fit: BoxFit.cover,
                          height: 28.h,
                          width: 31.w,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MedPlan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                'Your 24/7 Health Companion',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                  color: Color.fromRGBO(0, 0, 0, 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/app_store.png",
                          fit: BoxFit.cover,
                          height: 25.h,
                          width: 25.w,
                        ),
                        SizedBox(width: 15.w),
                        Image.asset(
                          "assets/play_store.png",
                          fit: BoxFit.cover,
                          height: 25.h,
                          width: 25.w,
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 2),
                  SizedBox(height: 4.h),
                  Center(
                    child: Text(
                      'Medication Adherence Report',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  buildTextTile('Name', getX.read(v.GETX_USERNAME)),
                  buildTextTile('Email', getX.read(v.GETX_EMAIL)),
                  buildTextTile('Month', widget.selectedDate),
                  SizedBox(height: 17.h),

                  ...List.generate(widget.adherenceReportList.length, (index) {
                    return buildMedicationReport(
                      widget.adherenceReportList[index],
                    );
                  }),

                  SizedBox(height: 232.h),
                  Divider(height: 1),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/www.png",
                              fit: BoxFit.cover,
                              height: 12.r,
                              width: 12.r,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'www.medPlansolutions.org',
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/gmail.png",
                              fit: BoxFit.cover,
                              height: 12.r,
                              width: 12.r,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'medplan.help@gmail.com',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/linkedin.png",
                              fit: BoxFit.cover,
                              height: 12.r,
                              width: 12.r,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'MedPlan Solutions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Send to Companion',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              InkWell(
                onTap:
                    isSharing
                        ? null
                        : () {
                          shareReport();
                        },
                child:
                    isSharing
                        ? CupertinoActivityIndicator()
                        : Image.asset(
                          "assets/button_share2.png",
                          fit: BoxFit.cover,
                          height: 24.r,
                          width: 24.r,
                        ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Center(
            child: Text(
              'By tapping “Send to Companion”, you agree to have your Medication data sent to your companions email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMedicationReport(var adherenceReportData) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: '1. ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
              children: [
                TextSpan(
                  text: '${adherenceReportData['medicine_name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      '\n   Take ${adherenceReportData['dosage_quantity']}, ${adherenceReportData['daily_dosage']} times a day for ${adherenceReportData['duration']} days',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            '    Total number of Doses: 30',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
          ),
          Row(
            children: [
              Image.asset(
                "assets/button_check.png",
                fit: BoxFit.cover,
                height: 14.r,
                width: 14.r,
              ),
              SizedBox(width: 2.w),
              Text(
                'Doses taken:    25',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/button_cancel.png",
                fit: BoxFit.cover,
                height: 14.r,
                width: 14.r,
              ),
              SizedBox(width: 2.w),
              Text(
                'Doses missed:   5',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
              ),
            ],
          ),

          Row(
            children: [
              Image.asset(
                "assets/score.png",
                fit: BoxFit.cover,
                height: 14.r,
                width: 14.r,
              ),
              SizedBox(width: 2.w),
              Text.rich(
                TextSpan(
                  text: 'Adherence Score: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  children: [
                    TextSpan(
                      text: '${adherenceReportData['percentage']}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text buildTextTile(String label, String text) {
    return Text.rich(
      TextSpan(
        text: '$label: ',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
