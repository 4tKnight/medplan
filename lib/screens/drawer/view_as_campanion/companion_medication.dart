import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/medication_reminder_service.dart';
import '../../../utils/global.dart';

class CompanionMedication extends StatefulWidget {
  String dependentId;
  CompanionMedication({super.key, required this.dependentId});

  @override
  State<CompanionMedication> createState() => _CompanionMedicationState();
}

class _CompanionMedicationState extends State<CompanionMedication> {
  @override
  initState() {
    super.initState();
    futureData = _medicationReminderService.viewTodaysMedicationReminders(
      medFor: 'dependent',
      forId: widget.dependentId,
    );
  }

  late Future<dynamic> futureData;
  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  List<dynamic> medicationReminders = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
           return helperWidget.noInternetScreen(() {
                setState(() {
              futureData = _medicationReminderService.viewTodaysMedicationReminders(
      medFor: 'dependent',
      forId: widget.dependentId,
    );
                });
              });
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(
            'Companion has not set any medication reminder',
                textAlign: TextAlign.center,

            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          );
          // myWidgets.buildNoMedicationReminderWidget(context, false,false);
        } else {
          if (snapshot.data['count'] > 0) {
            medicationReminders = snapshot.data['medication_reminders'];
          }
          return medicationReminders.isEmpty
              // ? myWidgets.buildNoMedicationReminderWidget(context, false, false)
              ? Text(
                'Companion has not set any medication reminder',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              )
              : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return myWidgets.buildMedicationWidget(
                    context: context,
                    showDate: false,
                    isDependent: false,
                    reminderData: medicationReminders[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return  SizedBox(height: 14.h);
                },
                itemCount: medicationReminders.length,
              );
        }
      },
    );
  }
}
