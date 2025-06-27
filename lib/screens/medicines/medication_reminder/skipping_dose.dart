// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/medication_reminder_service.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

class SkippingDose extends StatefulWidget {
  var reminderData;

  SkippingDose({super.key, required this.reminderData});

  @override
  _SkippingDoseState createState() => _SkippingDoseState();
}

class _SkippingDoseState extends State<SkippingDose> {
  List<Map<String, dynamic>> items = [
    {"option": "My medication is not near me", "selected": true},
    {"option": "Busy/asleep", "selected": false},
    {"option": "I have run out of this medication", "selected": false},
    {"option": "I don't need to take this dose", "selected": false},
    {"option": "I am experiencing side effects", "selected": false},
    {"option": "I am worried about the cost", "selected": false},
    {"option": "Other health concerns", "selected": false},
  ];

  String checkItemsValue = 'My medication is not near me';

  bool selected = false;
  bool isLoading = false;

  TextEditingController reasonController = TextEditingController();

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
      appBar: helperWidget.myAppBar(context, 'Skip Medication Dose'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        children: [
          Text(
            "Please tell use why you are skipping this dose",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 27.h),
          ...List.generate(items.length, (int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 19.h),
              child: InkWell(
                onTap: () {
                  if (items[index]['selected'] == false) {
                    items[index]['selected'] = true;
                    checkItemsValue = items[index]['option'];
                  } else {
                    items[index]['selected'] = false;
                    checkItemsValue = "";
                  }
                  clearOthers(index);
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15.r,
                      width: 15.r,
                      child: CheckboxTheme(
                        data: CheckboxThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          side: BorderSide.none, // No border for unchecked
                          visualDensity:
                              VisualDensity
                                  .compact, // Optional: tighter spacing
                        ),
                        child: Checkbox(
                          value: items[index]['selected'],

                          onChanged: (value) {
                            clearOthers(index);

                            if (value == true) {
                              items[index]['selected'] = true;
                              checkItemsValue = items[index]['option'];
                            } else {
                              items[index]['selected'] = false;
                              checkItemsValue = "";
                            }

                            setState(() {});
                          },
                          fillColor: WidgetStateProperty.all(Colors.grey[300]),
                          checkColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "${items[index]['option']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 5.h),
          otherReasonSelected
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Text(
                      "Please give more details",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  TextField(
                    maxLines: 6,
                    controller: reasonController,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: Color.fromRGBO(218, 218, 218, 0.4),
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    textInputAction: TextInputAction.next,
                    // enabled: otherReasonSelected,
                  ),
                ],
              )
              : const SizedBox(),
          const SizedBox(height: 90),
          Center(
            child: ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (checkItemsValue == 'Other health concerns') {
                          checkItemsValue +=
                              ' :${reasonController.text.trim()}';
                        }

                        try {
                          var res = await _medicationReminderService
                              .skipMedication(
                                medicationReminderId:
                                    widget.reminderData["_id"],
                                duration: '$currentDay',
                                dose: 1,
                                skipReason: checkItemsValue,
                              );
                          my_log(res);
                          if (res['status'] == 'ok') {
                            helperWidget.showToast(
                              'You have successfully skipped your medication dose. Please ensure to take care of your health.',
                            );
                            Navigator.pop(context);
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 60.w),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  bool otherReasonSelected = false;
  clearOthers(int index) {
    if (index == 0) {
      otherReasonSelected = false;
      items[1]['selected'] = false;
      items[2]['selected'] = false;
      items[3]['selected'] = false;
      items[4]['selected'] = false;
      items[5]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else if (index == 1) {
      otherReasonSelected = false;
      items[0]['selected'] = false;
      items[2]['selected'] = false;
      items[3]['selected'] = false;
      items[4]['selected'] = false;
      items[5]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else if (index == 2) {
      otherReasonSelected = false;
      items[0]['selected'] = false;
      items[1]['selected'] = false;
      items[3]['selected'] = false;
      items[4]['selected'] = false;
      items[5]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else if (index == 3) {
      otherReasonSelected = false;
      items[0]['selected'] = false;
      items[1]['selected'] = false;
      items[2]['selected'] = false;
      items[4]['selected'] = false;
      items[5]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else if (index == 4) {
      otherReasonSelected = false;
      items[0]['selected'] = false;
      items[1]['selected'] = false;
      items[2]['selected'] = false;
      items[3]['selected'] = false;
      items[5]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else if (index == 5) {
      otherReasonSelected = false;
      items[0]['selected'] = false;
      items[1]['selected'] = false;
      items[2]['selected'] = false;
      items[3]['selected'] = false;
      items[4]['selected'] = false;
      items[6]['selected'] = false;
      reasonController.clear();
    } else {
      otherReasonSelected = true;
      items[0]['selected'] = false;
      items[1]['selected'] = false;
      items[2]['selected'] = false;
      items[3]['selected'] = false;
      items[4]['selected'] = false;
      items[5]['selected'] = false;
    }

    print('>>>>>>>>>>>>>>>>>>>>>>> $otherReasonSelected ');
  }
}
