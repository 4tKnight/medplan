import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/medication_reminder_service.dart';
import '../../../utils/global.dart';

class DependentMedication extends StatefulWidget {
  String dependentId;
  DependentMedication({super.key,required this.dependentId});

  @override
  State<DependentMedication> createState() => _DependentMedicationState();
}

class _DependentMedicationState extends State<DependentMedication> {
  @override
  initState() {
    super.initState();
    futureData = _medicationReminderService.viewTodaysMedicationReminders(
        medFor: 'dependent',
        forId:widget.dependentId, 
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
        forId:widget.dependentId, 
    );
                });
              });
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return myWidgets.buildNoMedicationReminderWidget(context, false,true,
          dependentId: widget.dependentId);
        } else {
          if (snapshot.data['count'] > 0) {
            medicationReminders = snapshot.data['medication_reminders'];
          }
          return medicationReminders.isEmpty
              ? myWidgets.buildNoMedicationReminderWidget(context, false,true, dependentId: widget.dependentId)
              : ListView.separated(
                  shrinkWrap: true,
                  padding:  EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return myWidgets.buildMedicationWidget(
                        context: context,
                        showDate: false,
                        isDependent: true,
                        reminderData: medicationReminders[index]);
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
