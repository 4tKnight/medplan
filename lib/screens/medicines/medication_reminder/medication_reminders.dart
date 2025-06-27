import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/medication_reminder_service.dart';
import '../../../utils/global.dart';

class MedicationReminders extends StatefulWidget {
  bool isDependent;
  MedicationReminders({super.key, required this.isDependent});

  @override
  State<MedicationReminders> createState() => _MedicationRemindersState();
}

class _MedicationRemindersState extends State<MedicationReminders> {
  @override
  initState() {
    super.initState();
    futureData = _medicationReminderService.viewTodaysMedicationReminders(
      medFor: 'self',
      forId: '',
    );
  }

  late Future<dynamic> futureData;
  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  List<dynamic> medicationReminders = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        myWidgets.buildAdWidget(context, text_color: primaryColor),
        const SizedBox(height: 20),
        FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return helperWidget.noInternetScreen(() {
                setState(() {
                  futureData = _medicationReminderService
                      .viewTodaysMedicationReminders(medFor: 'self', forId: '');
                });
              });
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return myWidgets.buildNoMedicationReminderWidget(
                context,
                false,
                false,
              );
            } else {
              if (snapshot.data['count'] > 0) {
                medicationReminders = snapshot.data['medication_reminders'];
              }
              return medicationReminders.isEmpty
                  ? myWidgets.buildNoMedicationReminderWidget(
                    context,
                    false,
                    false,
                  )
                  : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        // padding: EdgeInsets.only(top),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return myWidgets.buildMedicationWidget(
                            isDependent: widget.isDependent,
                            context: context,
                            showDate: false,
                            reminderData: medicationReminders[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 14.h);
                        },
                        itemCount: medicationReminders.length,
                      ),
                      SizedBox(height: 16.h),
                      myWidgets.buildTalkToPharmacist(context),
                    ],
                  );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
