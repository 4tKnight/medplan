import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/global.dart';
import '../../api/medication_reminder_service.dart';

class MedicationHistory extends StatefulWidget {
  bool isDependent;
  MedicationHistory({super.key, required this.isDependent});

  @override
  State<MedicationHistory> createState() => _MedicationHistoryState();
}

class _MedicationHistoryState extends State<MedicationHistory> {
  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    futureData = _medicationReminderService.viewMedicationHistory(
      medFor: 'self',
      dependentId: 'a',
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                false,
              );
            } else {
              if (snapshot.data['count'] > 0) {
                medicationHistories = snapshot.data['medication_reminders'];
              }
              return medicationHistories.isEmpty
                  ? myWidgets.buildNoMedicationReminderWidget(
                    context,
                    true,
                    false,
                  )
                  : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 31.h),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return myWidgets.buildMedicationHistoryWidget(
                            context,
                            medicationHistories[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 14);
                        },
                        itemCount: medicationHistories.length,
                      ),
                      SizedBox(height: 14.h),
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
