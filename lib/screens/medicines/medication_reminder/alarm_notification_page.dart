import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/api/medication_reminder_service.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import 'skipping_dose.dart';

class AlarmNotificationPage extends StatefulWidget {
  var reminderData;
  AlarmNotificationPage({super.key, required this.reminderData});

  @override
  State<AlarmNotificationPage> createState() => _AlarmNotificationPageState();
}

class _AlarmNotificationPageState extends State<AlarmNotificationPage> {
  bool isLoading = false;
  int currentDay = 0;
  @override
  initState() {
    super.initState();
    currentDay =
        DateTime.now()
            .difference(
              DateTime.parse(widget.reminderData['start_reminder_date_time']),
            )
            .inDays +
        1;
  }

  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              Text(
                'Day $currentDay',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Color.fromRGBO(255, 188, 81, 1),
                ),
              ),
              SizedBox(height: 21.h),
              Image.asset("./assets/alarm.png", height: 60.h, width: 61.w),
              SizedBox(height: 22.h),
              Text(
                "${widget.reminderData['medicine_name']} ${widget.reminderData['dosage_quantity']}",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  "Take ${widget.reminderData["dosage_quantity"]} ${widget.reminderData["dosage_form"].toLowerCase()}, ${widget.reminderData["meal_time"]}, For ${widget.reminderData["duration"]} Days",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 52.h, bottom: 40.h),
                child: Image.asset(
                  "${constants.dosageImages[widget.reminderData['dosage_form']]}",
                  height: 136.h,
                  width: 156.w,
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 85.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => SkippingDose(
                        reminderData:widget.reminderData,
                      )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 17.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "./assets/button_cancel.png",
                            height: 48.r,
                            width: 48.r,
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            "SKIP",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 52.w),
                  InkWell(
                    onTap:
                        isLoading
                            ? null
                            : () async {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                var res = await _medicationReminderService
                                    .takeMedication(
                                      medicationReminderId:
                                          widget.reminderData["_id"],
                                      duration: '$currentDay',
                                      dose: 1,
                                    );
                                my_log(res);
                                if (res['status'] == 'ok') {
                                  helperWidget.showToast(
                                    'Great job! You have successfully taken your medication.',
                                  );
                                  Navigator.pop(context);
                                } else {
                                  helperWidget.showToast(
                                    'oOps! Something went wrong, try again',
                                  );
                                }
                              } catch (e) {
                                my_log(e);
                                helperWidget.showToast(
                                  'oOps! Something went wrong, try again',
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 17.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
                              ? SizedBox(
                                height: 48.r,
                                width: 48.r,
                                child: const CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              )
                              : Image.asset(
                                "./assets/button_check.png",
                                height: 48.r,
                                width: 48.r,
                              ),
                          SizedBox(height: 14.h),
                          Text(
                            "TAKE",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
