import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/medication_reminder_service.dart';
import '../../../utils/global.dart';

class DependentMedicationHistory extends StatefulWidget {
  String dependentId;
  DependentMedicationHistory({super.key, required this.dependentId});

  @override
  State<DependentMedicationHistory> createState() =>
      _DependentMedicationHistoryState();
}

class _DependentMedicationHistoryState
    extends State<DependentMedicationHistory> {
  int day = DateTime.now().day;
  int month = DateTime.now().day;
  int year = DateTime.now().day;

  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    futureData = _medicationReminderService.viewMedicationHistory(
      medFor: 'dependent',
      dependentId: widget.dependentId,
      day: day,
      month: month - 1,
      year: year,
    );
  }

  late Future<dynamic> futureData;
  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();
  List<dynamic> medicationHistories = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myWidgets.buildCalenderWidget(context, (day, month, year) {
          setState(() {
            this.day = day;
            this.month = month;
            this.year = year;
            loadFuture();
          });
        }),
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
              return myWidgets.buildNoMedicationReminderWidget(
                context,
                true,
                true,
                dependentId: widget.dependentId,
              );
            } else {
              if (snapshot.data['count'] > 0) {
                medicationHistories = snapshot.data['medication_reminders'];
              }
              return medicationHistories.isEmpty
                  ? myWidgets.buildNoMedicationReminderWidget(
                    context,
                    true,
                    true,
                    dependentId: widget.dependentId,
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return myWidgets.buildMedicationHistoryWidget(
                        context,
                        medicationHistories,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 14.h);
                    },
                    itemCount: medicationHistories.length,
                  );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
