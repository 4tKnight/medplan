import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/screens/medicines/medication_reminder/alarm_notification_page.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/text_to_speech.dart';

import '../api/medication_reminder_service.dart';
import '../screens/auth/auth_login_signup.dart';
import '../screens/bottom_control/bottom_nav_bar.dart';
import '../screens/drawer/chat_your_pharmacist.dart';
import '../screens/drawer/medplan_coin.dart';
import '../screens/medicines/medication_reminder/set_medication_reminder_1.dart';
import 'global.dart';
import 'dart:math';

class CustomWidgets {
  Future<dynamic> buildAddBottomSheet({
    required BuildContext context,
    required String title,
    required String recordName,
    required String fieldName,
    required int month,
    required int year,
    required Function(dynamic, dynamic) onSuccess,
    required Future<dynamic> Function(dynamic) apiCall,
  }) {
    TextEditingController recordValueController = TextEditingController();
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
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
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
                                      "Please enter $recordName value",
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
                                      fieldName:
                                          recordValueController.text.contains(
                                                '.',
                                              )
                                              ? double.parse(
                                                recordValueController.text,
                                              )
                                              : int.parse(
                                                recordValueController.text,
                                              ),
                                    };
                                    final HealthRecordServices
                                    healthRecordServices =
                                        HealthRecordServices();

                                    var res = await apiCall(recordData);

                                    my_log(res);
                                    if (res['status'] == 'ok') {
                                      recordValueController.clear();

                                      onSuccess(recordData, res);
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

  Widget noProfileImage(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 241, 219, 1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_outline, size: size / 1.5, color: Colors.black),
    );
  }

  Widget buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•', style: TextStyle(fontSize: 14.sp)),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget buildAdWidget(BuildContext ctx, {Color text_color = Colors.black54}) {
    Random random = Random();
    int randIdx = random.nextInt(2);
    return Container(
      // margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 242, 222, 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child:
          randIdx == 0
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Do you know that taking your medications as prescribed by your doctor earns you ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'FREE COINS',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' which can be used for FREE consultations with your Pharmacist.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 13),
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: Image.asset(
                      "assets/talk_to_pharmacist.png",
                      fit: BoxFit.cover,
                      height: 40.r,
                      width: 40.r,
                    ),
                  ),
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Unsure of your medicines? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'Talk to your Pharmacist today for FREE!',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: text_color,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      ctx,
                                      MaterialPageRoute(
                                        builder: (_) => ChatWithPharmacist(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 11.sp),
                  Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 13),
                  ),
                ],
              ),
    );
  }

  Widget buildTalkToPharmacist(BuildContext context) {
    bool showTalkToPharmacist = true;
    return StatefulBuilder(
      builder: (context, setCustomState) {
        return showTalkToPharmacist == false
            ? const SizedBox()
            : Container(
              // height: 100,
              padding: EdgeInsets.all(10.r),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey, width: 0.2.w),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: Image.asset(
                      "assets/talk_to_pharmacist.png",
                      fit: BoxFit.contain,
                      height: 79.h,
                      width: 124.w,
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    // flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unsure of your medicines?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Talk to your Pharmacist today for FREE!',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            // height: 28.h,
                            child: ElevatedButton(
                              onPressed: () {
                                if (getX.read(v.GETX_IS_LOGGED_IN) == true) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const ChatWithPharmacist(),
                                    ),
                                  );
                                } else {
                                  helperWidget.showToast(
                                    "Please log in to continue",
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => const Login(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 5.h,
                                ),
                              ),
                              child: Text(
                                'Start Chat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }

  Widget buildRecordDateWidget({
    required int month,
    required int year,
    required Function(int, int) setDateFunc,
  }) {
    DateTime selectedDate = DateTime(year, month);

    String formattedDate =
        "${time.getMonthString(selectedDate.month)} ${selectedDate.year}";

    return StatefulBuilder(
      builder: (context, setCustomState) {
        formattedDate =
            "${time.getMonthString(selectedDate.month)} ${selectedDate.year}";

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                setCustomState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month - 1,
                  );
                  setDateFunc(selectedDate.month, selectedDate.year);
                });
              },
            ),
            Text(
              formattedDate,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                setCustomState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month + 1,
                  );
                  setDateFunc(selectedDate.month, selectedDate.year);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildYearOnlyWidget(int selectedYear, Function(int) setYear) {
    DateTime selectedDate = DateTime(selectedYear);

    String formattedDate = "${selectedDate.year}";

    return StatefulBuilder(
      builder: (context, setCustomState) {
        formattedDate = "${selectedDate.year}";

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                setCustomState(() {
                  selectedDate = DateTime(selectedDate.year - 1);
                  setYear(selectedDate.year);
                });
              },
            ),
            Text(
              formattedDate,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                setCustomState(() {
                  selectedDate = DateTime(selectedDate.year + 1);
                  setYear(selectedDate.year);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Row buildChangeLanguageWidget([
    String? content,
    String? lang,
    Function(String)? onChanged,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            if (content != null) {
              configureTts();
              speakText(content);
            }
          },
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: myWidgets.commonContainerDecoration(),
            child: const Icon(
              Icons.volume_up,
              color: Color.fromRGBO(50, 50, 50, 1),
            ),
          ),
        ),
        SizedBox(width: 7.w),
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: myWidgets.commonContainerDecoration(),
          child: Row(
            children: [
              const Icon(Icons.language, color: Color.fromRGBO(50, 50, 50, 1)),
              SizedBox(height: 22.h, child: VerticalDivider()),
              DropdownButton<String>(
                value: lang,
                isDense: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
                items:
                    <String>[
                      'English',
                      'Pidgin',
                      'Hausa',
                      'Igbo',
                      'Yoruba',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) {
                  onChanged!(value!);
                },
                underline: const SizedBox(), // Makes the dropdown borderless
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration commonContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          spreadRadius: 0.5,
          blurRadius: 2,
          offset: const Offset(0, 2), // changes position of shadow
        ),
      ],
    );
  }

  Container buildCalenderWidget(
    BuildContext context,
    Function(int, int, int) setDateFunc,
  ) {
    return Container(
      color: Colors.transparent,
      height: 142.h,
      child: Calendar(
        hideTodayIcon: true,
        startOnMonday: false,
        eventDoneColor: Colors.green,
        selectedColor: Theme.of(context).primaryColor,
        selectedTodayColor: Theme.of(context).primaryColor,
        todayColor: primaryColor,
        eventColor: null,
        isExpanded: false,
        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
        datePickerType: DatePickerType.hidden,
        defaultDayColor: Colors.black,
        displayMonthTextStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),

        dayOfWeekStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 13.sp,
        ),
        onDateSelected: (DateTime dateSelected) {
          // get_reminders(dateSelected, true);
          // int s = timeManager.getWeekNumber(DateTime.now());
          // month = timeManager.getMonthString(dateSelected.month);
          // year = dateSelected.year;
          // week = timeManager.getWeekNumber(dateSelected);
          int day = dateSelected.day;
          int month = dateSelected.month;
          int year = dateSelected.year;

          setDateFunc(day, month, year);
        },

        locale: 'en_US',
      ),
    );
  }

  Widget buildMedicationHistoryWidget(BuildContext context, var reminderData) {
    return Container(
      // height: 140,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey, width: 0.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${reminderData['medicine_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text(
                      time.dateFromTimestamp(reminderData['timestamp']),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Take ${reminderData['dosage_quantity']}, ${reminderData['daily_dosage']} times a day for ${reminderData['duration']} Days',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 9.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        runSpacing: 5.h,
                        spacing: 24.w,
                        children: List.generate(
                          reminderData['doses'].length,
                          (index) => buildMedicationActionWidget(
                            reminderData['doses'][index]['is_skipped'],
                            reminderData['doses'][index]['timestamp'],
                          ),
                        ),
                      ),
                    ),
                    if (reminderData['doses'].any(
                      (dose) => dose['is_skipped'] == true,
                    ))
                      InkWell(
                        onTap: () {
                          showSkipDetailsDialog(context, reminderData);
                        },
                        child: Text(
                          'View Skip Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: Color.fromRGBO(242, 10, 10, 1),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSkipDetailsDialog(BuildContext context, var reminderData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'SKIP DETAILS',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                '${reminderData['medicine_name']}\n${reminderData['dosage_quantity']}, ${reminderData['daily_dosage']} times a day for ${reminderData['duration']} Days',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),

              ...List.generate(reminderData['doses'].length, (idx) {
                return reminderData['doses'][idx]['is_skipped']
                    ? Text(
                      '\nSkipped ${convertToOrdinal(idx + 1)} dose\nDay ${reminderData['doses'][idx]['duration']} of ${reminderData['duration']} ${time.dateFromTimestamp(reminderData['doses'][idx]['timestamp'])})\n\nReason\n${reminderData['doses'][idx]['skip_reason']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    )
                    : SizedBox();
              }),
            ],
          ),
        );
      },
    );
  }

  String convertToOrdinal(int number) {
    if (number <= 0) return number.toString();
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  Widget buildMedicationActionWidget(bool isSkipped, int timestamp) {
    return Column(
      children: [
        Text(
          time.timeFromTimestamp(timestamp),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
        ),
        SizedBox(height: 6.h),
        Image.asset(
          isSkipped ? "assets/button_cancel.png" : "assets/button_check.png",
          fit: BoxFit.cover,
          height: 18.r,
          width: 18.r,
        ),
      ],
    );
  }

  Padding buildNoMedicationReminderWidget(
    BuildContext context,
    bool isHistory,
    bool isDependent, {
    String dependentId = '',
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Image.asset(
            "assets/no_medicines.png",
            fit: BoxFit.cover,
            height: 248.h,
            width: 245.w,
          ),
          SizedBox(height: 4.h),
          Center(
            child: Text(
              isHistory
                  ? 'You have not set any medication reminder for this selected date'
                  : 'You have not set any medication reminder.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
            ),
          ),
          SizedBox(height: 21.h),
          if (isHistory == false)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SetMedicationReminderStepOne(
                            isDependent: isDependent,
                            dependentId: dependentId,
                          ),
                    ),
                  );
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
                child: Text(
                  '+ Set New Reminder',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.h),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int currentDay = DateTime.now().day;
  String monthAbbreviation =
      DateFormat('MMM').format(DateTime.now()).toUpperCase();
  Widget buildMedicationWidget({
    required BuildContext context,
    dynamic reminderData,
    required bool showDate,
    required bool isDependent,
    bool showViewAll = false,
  }) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => AlarmNotificationPage(reminderData: reminderData),
        //   ),
        // );
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (showDate)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentDay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$monthAbbreviation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            if (showDate) SizedBox(width: 9.w),
            Expanded(
              child: Container(
                // height: 150,
                padding: EdgeInsets.only(
                  left: 14.w,
                  right: 11.w,
                  top: 9.h,
                  bottom: 15.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.grey, width: 0.2.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${reminderData['current_day']} of ${reminderData['duration']}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              height: 1.3.h,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            '${reminderData['medicine_name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              height: 1.3.h,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            'Take ${reminderData['dosage_quantity']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              height: 1.3.h,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            '${reminderData['daily_dosage']} times a day for ${reminderData['duration']} days',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              height: 1.3.h,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            '${reminderData['meal_time']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.7),

                              height: 1.3.h,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            '${reminderData['additional_instructions']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.7),

                              height: 1.3.h,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200.r),
                          child: Image.asset(
                            "${constants.dosageImages[reminderData['dosage_form']]}",
                            fit: BoxFit.cover,
                            height: 50.h,
                            width: 56.w,
                          ),
                        ),
                        if (showViewAll)
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => BottomNavBar(index: 1),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'view all',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        if (showDate == false)
                          InkWell(
                            onTapDown: (TapDownDetails details) {
                              _showMedicationReminderPopupMenu(
                                context,
                                details.globalPosition,
                                reminderData,
                                isDependent,
                              );
                            },
                            child: const Icon(
                              Icons.more_vert,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicationReminderPopupMenu(
    BuildContext context,
    Offset offset,
    var reminderData,
    bool isDependent,
  ) async {
    final result = await showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx,
        offset.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Image.asset(
                "assets/button_edit_outline.png",
                fit: BoxFit.contain,
                height: 12.r,
                width: 12.r,
                color: Colors.black,
              ),
              SizedBox(width: 8.w),
              Text(
                'Edit Reminder',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Image.asset(
                "assets/button_delete_outlined.png",
                fit: BoxFit.contain,
                height: 12.r,
                width: 12.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delete Reminder',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
      elevation: 2.0,
      color: Colors.white,
    );

    // Handle the menu item selection
    switch (result) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => SetMedicationReminderStepOne(
                  isDependent: isDependent,
                  medicationReminderData: reminderData,
                ),
          ),
        );
        break;
      case 'delete':
        showDeleteReminderDialog(context, reminderData['_id']);
        break;

      default:
        break;
    }
  }

  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  showDeleteReminderDialog(BuildContext context, String medicationReminderID) {
    bool loading = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 250,
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DELETE REMINDER',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.r),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 52.r,
                          width: 52.r,
                        ),
                      ),
                      Text(
                        "Are you sure you want to delete this reminder? Once deleted, it cannot be retrieved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 35.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            // width: 80,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 36.w,
                                  vertical: 8.h,
                                ),
                              ),
                              child:
                                  loading
                                      ? Center(
                                        child: SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  loading = true;
                                });

                                try {
                                  var res = await _medicationReminderService
                                      .deleteMedicationReminder(
                                        medicationReminderID:
                                            medicationReminderID,
                                      );
                                  if (res['status'] == 'ok') {
                                    List<int> localNotificationIDs =
                                        getX.read(
                                                      v.GETX_SERVER_ID_TO_LOCAL_IDS,
                                                    ) ==
                                                    null ||
                                                getX
                                                    .read(
                                                      v.GETX_SERVER_ID_TO_LOCAL_IDS,
                                                    )
                                                    .isEmpty
                                            ? []
                                            : getX.read(
                                              v.GETX_SERVER_ID_TO_LOCAL_IDS,
                                            )[medicationReminderID];
                                    for (int x in localNotificationIDs) {
                                      localNotificationHelper
                                          .cancelNotification(x);
                                      my_log('-----------------> cancelled $x');
                                    }
                                    helperWidget.showToast(
                                      "Medication reminder deleted successfully",
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => BottomNavBar(index: 1),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    helperWidget.showToast(
                                      "Oops! Something went wrong.",
                                    );
                                  }
                                } catch (e) {
                                  my_log(e);
                                  helperWidget.showToast(
                                    "Oops! Something went wrong.",
                                  );
                                } finally {
                                  setCustomState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            // width: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 36.w,
                                  vertical: 8.h,
                                ),
                              ),
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCoinWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MedplanCoin()));
      },
      child: Container(
        // height: 30,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 237, 255, 1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            Image.asset("assets/coin.png", height: 20.r, width: 20.r),
            const SizedBox(width: 2),
            Text(
              '${getX.read(v.GETX_MEDPLAN_COINS) ?? '0'} left',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  showSmileyDialog({
    required BuildContext context,
    required String title,
    required String smiley,
    required Function() function,
    bool loading = false,
    String left_button_text = "Yes",
    String right_button_text = "No",
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 250,
            width: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    left_button_text,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      "./assets/smiley_delete.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Text(title, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 80,
                        child: OutlinedButton(
                          child: Text(
                            right_button_text,
                            style: TextStyle(color: primaryColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child:
                            loading
                                ? TextButton(
                                  child: Center(
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                                : ElevatedButton(
                                  onPressed: function,
                                  child: const Text("YES"),
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
