import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/medication_reminder_service.dart';
import '../../../utils/functions.dart';
import '../../../utils/global.dart';
import '../../bottom_control/bottom_nav_bar.dart';

class SetMedicationReminderStepTwo extends StatefulWidget {
  bool isDependent;
  String dependentId;
  dynamic medicationReminderData;
  String medicineName;
  String dosageForm;
  String dosageQuantity;
  SetMedicationReminderStepTwo({
    super.key,
    this.medicationReminderData,
    required this.isDependent,
    required this.dependentId,
    required this.medicineName,
    required this.dosageForm,
    required this.dosageQuantity,
  });

  @override
  State<SetMedicationReminderStepTwo> createState() =>
      _SetMedicationReminderStepTwoState();
}

class _SetMedicationReminderStepTwoState
    extends State<SetMedicationReminderStepTwo> {
  // TimeOfDay selectedTime = TimeOfDay.now();

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => Container(
            height: 280.h,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 210.h,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    // initialDateTime: DateTime(
                    //   2024,
                    //   1,
                    //   1,
                    //   selectedTime.hour,
                    //   selectedTime.minute,
                    // ),
                    use24hFormat: false, // set true for 24-hour format
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        startReminderTime = TimeOfDay.fromDateTime(
                          newDateTime,
                        ).format(context);
                        startReminderDateTime = newDateTime;
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
    );
  }

  TextEditingController durationController = TextEditingController();
  TextEditingController additionalInstructionsController =
      TextEditingController();
  String? dailyDosage;
  String? startReminderTime;
  DateTime? startReminderDateTime;

  List<String> mealTime = ["Before Meal", "During Meal", "After Meal"];
  String selectedMealTime = 'After Meal';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.medicationReminderData != null) {
      setData();
    }
  }

  setData() {
    setState(() {
      dailyDosage = constants.frequenciesWordToNumber.keys.firstWhere(
        (key) =>
            constants.frequenciesWordToNumber[key] ==
            widget.medicationReminderData['daily_dosage'],
        orElse: () => 'Once a day',
      );
      durationController.text =
          widget.medicationReminderData['duration'].toString();
      selectedMealTime = widget.medicationReminderData['meal_time'];
      additionalInstructionsController.text =
          widget.medicationReminderData['additional_instructions'];
      selectedMealTime = widget.medicationReminderData['meal_time'];
      startReminderTime = widget.medicationReminderData['reminder_time'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Set a Medication Reminder"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          buildHeaderArea(),
          SizedBox(height: 46.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How many times a day?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dailyDosage,
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),

                          items:
                              constants.frequencies.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dailyDosage = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'For how many days (Duration)?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextField(
                        style: TextStyle(fontSize: 14.sp),
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 10.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            'Take this medicine',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 5.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(mealTime.length, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedMealTime = mealTime[index];
                    });
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: index == 0 ? 0 : 8.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: selectedMealTime == mealTime[index] ? 2 : 1,
                        color:
                            selectedMealTime == mealTime[index]
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      mealTime[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color:
                            selectedMealTime == mealTime[index]
                                ? Colors.black87
                                : greyTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 29.h),
          Text(
            'Additional Intake instructions (Optional)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 7.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              controller: additionalInstructionsController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),

              maxLength: 100,
              maxLines: 6,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Set Reminder Start Time',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              _showTimePicker();

              // TimeOfDay? pickedTime = await showTimePicker(
              //   context: context,
              //   initialTime: TimeOfDay.now(),
              // );
              // if (pickedTime != null) {
              //   final now = DateTime.now();
              //   startReminderDateTime = DateTime(
              //     now.year,
              //     now.month,
              //     now.day,
              //     pickedTime.hour,
              //     pickedTime.minute,
              //   );
              //   setState(() {
              //     startReminderTime = pickedTime.format(context);
              //   });
              // }
            },
            child: Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              alignment: Alignment.centerLeft,
              child: Text(
                startReminderTime ?? 'Select Time',
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      startReminderTime == null
                          ? Colors.grey[600]
                          : Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(height: 56.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());

                if (dailyDosage == null) {
                  helperWidget.showToast("Please select how many times a day");
                  return;
                }
                if (durationController.text.isEmpty) {
                  helperWidget.showToast("Please select how many days");
                  return;
                }
                if (startReminderTime == null) {
                  helperWidget.showToast("Please select reminder time");
                  return;
                }
                addMedicationReminder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Finish',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = false;
  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();

  addMedicationReminder() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res =
          widget.medicationReminderData == null
              ? await _medicationReminderService.addMedicationReminder(
                medicineName: widget.medicineName,
                dosageForm: widget.dosageForm,
                dosageQuantity: widget.dosageQuantity,
                dailyDosage: constants.frequenciesWordToNumber[dailyDosage]!,
                duration: int.parse(durationController.text),
                mealTime: selectedMealTime,
                additionalInstructions: additionalInstructionsController.text,
                reminderTime: startReminderTime!,
                isDependent: widget.isDependent,
                dependentId: widget.isDependent ? widget.dependentId : '',
              )
              : await _medicationReminderService.editMedicationReminder(
                medicationReminderID: widget.medicationReminderData['_id'],
                medicineName: widget.medicineName,
                dosageForm: widget.dosageForm,
                dosageQuantity: widget.dosageQuantity,
                dailyDosage: constants.frequenciesWordToNumber[dailyDosage]!,
                duration: int.parse(durationController.text),
                mealTime: selectedMealTime,
                additionalInstructions: additionalInstructionsController.text,
                reminderTime: startReminderTime!,
              );
      my_log(res);
      if (res['status'] == 'ok') {
        int intervalCount = fetchInterval(dailyDosage!);

        List<int> localNotificationIDs = localNotificationHelper.makeIDs(
          24 / intervalCount,
        );

        Map<String, dynamic> localReminderData = {
          "_id": res['medication_reminder']['_id'],
          "notification_ids": localNotificationIDs,
          "interval_count": intervalCount,
          'medicine_name': widget.medicineName,
          'start_reminder_date_time': startReminderDateTime,
          'dosage_form': widget.dosageForm,
          'is_dependent': widget.isDependent,
          'dosage_quantity': widget.dosageQuantity,
          'daily_dosage': dailyDosage,
          'duration': int.parse(durationController.text),
          'meal_time': selectedMealTime,
          'additional_instructions': additionalInstructionsController.text,
        };

        await localNotificationHelper.setNewPillReminder(localReminderData);

        getX.read(v.GETX_SERVER_ID_TO_LOCAL_IDS)[res['_id']] =
            localNotificationIDs;

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (_) => BottomNavBar(index: widget.isDependent ? 0 : 1),
          ),
          (route) => false,
        );

        showSuccessfullyReminderDialog(context);
      } else {
        helperWidget.showToast("oOps something went wrong");
      }
    } catch (e) {
      my_log(e);
      helperWidget.showToast("oOps something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int fetchInterval(String freq) {
    int intervalCount = 0;

    if (constants.frequencies[0] == freq) {
      intervalCount = 24;
    } else if (constants.frequencies[1] == freq) {
      intervalCount = 12;
    } else if (constants.frequencies[2] == freq) {
      intervalCount = 8;
    } else if (constants.frequencies[3] == freq) {
      intervalCount = 6;
    } else {
      intervalCount = 4;
    }
    return intervalCount;
  }

  void showSuccessfullyReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'SUCCESSFUL',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/smiley_success.png', height: 75),
              const SizedBox(height: 10),
              Text(
                widget.medicationReminderData == null
                    ? 'Medication Reminder added\nsuccessfully'
                    : 'Medication Reminder edited\nsuccessfully',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildHeaderArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '(Medicine Details)',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 4.h,
              width: 99.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: const Color.fromRGBO(240, 240, 240, 1),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '(Intake Instructions)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 4.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(253, 170, 39, 1),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ],
        ),
        ClipOval(
          child: Image.asset(
            "${constants.dosageImages[widget.dosageForm]}",
            fit: BoxFit.cover,
            height: 36.r,
            width: 36.r,
          ),
        ),
      ],
    );
  }
}
