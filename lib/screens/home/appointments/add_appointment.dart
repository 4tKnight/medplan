import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import '../../../api/appointment_service.dart';
import '../../auth/auth_login_signup.dart';
import '../../bottom_control/bottom_nav_bar.dart';

class AddAppointment extends StatefulWidget {
  dynamic appointmentData;
  AddAppointment({super.key, this.appointmentData});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final TextEditingController _appointmentNameController =
      TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _doctorsNameController = TextEditingController();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _appointmentTimeController =
      TextEditingController();
  final TextEditingController _appointmentInfoController =
      TextEditingController();
  String? _reminderTime;

  @override
  initState() {
    super.initState();
    if (widget.appointmentData != null) {
      _appointmentNameController.text =
          widget.appointmentData['appointment_name'];
      _hospitalNameController.text = widget.appointmentData['hospital_name'];
      _doctorsNameController.text = widget.appointmentData['doctors_name'];
      _appointmentDateController.text =
          widget.appointmentData['appointment_date'];
      _appointmentTimeController.text =
          widget.appointmentData['appointment_time'];
      _appointmentInfoController.text =
          widget.appointmentData['additional_information'];
      _reminderTime = widget.appointmentData['reminder_time'];

      _appointmentTimestamp = widget.appointmentData['appointment_timestamp'];
      convertTimestampToTimeAndDate(_appointmentTimestamp);
    }
  }

  void convertTimestampToTimeAndDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    pickedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    pickedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Set New Appointments',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        children: [
          TextField(
            controller: _appointmentNameController,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Enter appointment name eg Eye Check up',
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          TextField(
            controller: _hospitalNameController,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Enter hospital name',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          TextField(
            controller: _doctorsNameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Enter Doctors name (optional)',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _appointmentDateController,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Appmt. Date:',
                    hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 16),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _appointmentDateController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate!);
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 30.w),
              Expanded(
                child: TextFormField(
                  controller: _appointmentTimeController,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Appmt. Time:',
                    hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 16),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _appointmentTimeController.text = pickedTime!.format(
                          context,
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 29.h),
          Text(
            'Please enter any additional information regarding this appointment',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          TextField(
            maxLines: 10,
            controller: _appointmentInfoController,

            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(fontSize: 14.sp),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(236, 236, 236, 1),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Remind me of this appointment',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: DropdownButtonFormField<String>(
                value: _reminderTime,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                items:
                    [
                      '10 mins before',
                      '30 mins before',
                      '1 hour before',
                      '2 hours before',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.7),

                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  _reminderTime = newValue!;
                },
              ),
            ),
          ),
          SizedBox(height: 55.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_appointmentNameController.text.isEmpty) {
                  helperWidget.showToast("Appointment name is required");
                  return;
                }

                if (_hospitalNameController.text.isEmpty) {
                  helperWidget.showToast("Hospital name is required");
                  return;
                }

                if (_appointmentDateController.text.isEmpty) {
                  helperWidget.showToast("Appointment date is required");
                  return;
                }

                if (_appointmentTimeController.text.isEmpty) {
                  helperWidget.showToast("Appointment time is required");
                  return;
                }

                if (_reminderTime == null) {
                  helperWidget.showToast("Reminder time is required");
                  return;
                }

                _triggerAppointmentEndpoint();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 60.w),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 20.r,
                        width: 20.r,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
          SizedBox(height: 29.h),
          if (getX.read(v.GETX_IS_LOGGED_IN) == null)
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Why risk losing your data?\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up/Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const Login(),
                                ),
                              );
                            },
                    ),
                    TextSpan(
                      text: ' to sync your data and keep it safe.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 41.h),
        ],
      ),
    );
  }

  TimeOfDay? pickedTime;
  DateTime? pickedDate;

  int _appointmentTimestamp = 0;

  mergeTimeAndDate() {
    if (pickedTime == null || pickedDate == null) {
      return;
    }

    DateTime mergedDateTime = DateTime(
      pickedDate!.year,
      pickedDate!.month,
      pickedDate!.day,
      pickedTime!.hour,
      pickedTime!.minute,
    );

    _appointmentTimestamp = mergedDateTime.millisecondsSinceEpoch;
  }

  final AppointmentService _appointmentService = AppointmentService();

  bool isLoading = false;
  _triggerAppointmentEndpoint() async {
    mergeTimeAndDate();
    setState(() {
      isLoading = true;
    });
    try {
      var res =
          widget.appointmentData == null
              ? await _appointmentService.createAppointment(
                appointmentTimestamp: _appointmentTimestamp,
                reminderTime: _reminderTime!,
                additionalInformation: _appointmentInfoController.text.trim(),
                appointmentTime: _appointmentTimeController.text.trim(),
                appointmentDate: _appointmentDateController.text.trim(),
                appointmentName: _appointmentNameController.text.trim(),
                hospitalName: _hospitalNameController.text.trim(),
                doctorName: _doctorsNameController.text.trim(),
              )
              : await _appointmentService.editAppointment(
                appointmentID: widget.appointmentData['_id'],
                appointmentTimestamp: _appointmentTimestamp,
                reminderTime: _reminderTime!,
                additionalInformation: _appointmentInfoController.text.trim(),
                appointmentTime: _appointmentTimeController.text.trim(),
                appointmentDate: _appointmentDateController.text.trim(),
                appointmentName: _appointmentNameController.text.trim(),
                hospitalName: _hospitalNameController.text.trim(),
                doctorName: _doctorsNameController.text.trim(),
              );
      my_log(res);
      if (res['status'] == 'ok') {
        helperWidget.showToast(
          widget.appointmentData == null
              ? "Appointment added successfully"
              : "Appointment edited successfully",
        );
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavBar()),
          (route) => false,
        );
      } else {
        helperWidget.showToast(
          "oOps something went wrong when creating appointment.",
        );
      }
    } catch (e) {
      helperWidget.showToast(
        "oOps something went wrong when creating appointment.",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
