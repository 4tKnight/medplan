import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/screens/medicines/medication_reminder/adherence_report.dart';
import 'package:medplan/utils/global.dart';

import 'medication_history.dart';
import 'medication_reminder/medication_reminders.dart';
import 'medication_reminder/set_medication_reminder_1.dart';

class MedicinesController extends StatefulWidget {
  MedicinesController({super.key, this.index = 0});
  int index = 0;

  @override
  State<MedicinesController> createState() => MedicinesControllerState();
}

class MedicinesControllerState extends State<MedicinesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: BackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Medicines",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          InkResponse(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => SetMedicationReminderStepOne(isDependent: false),
                ),
              );
            },
            child: Image.asset("assets/add.png", height: 27.h, width: 27.w),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          _build_choice_selector(),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (int idx) {
                setState(() {
                  index = idx;
                });
              },
              children: [
                MedicationReminders(isDependent: false),
                MedicationHistory(isDependent: false),
                AdherenceReport(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int? index;
  PageController? pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    index = widget.index;
    pageController = PageController(initialPage: widget.index);

    super.initState();
  }

  Widget _build_choice_selector() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 7.h, 30.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // width: 185,
            // height: 38,
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    // setState(() {
                    // index = 0;
                    pageController!.jumpToPage(0);
                    // });
                  },
                  child: Container(
                    // width: 140,
                    // height: 28,
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: index == 0 ? secondaryColor : Colors.transparent,
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          'Med. Reminders',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: index == 0 ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // index = 1;
                      pageController!.jumpToPage(1);
                    });
                  },
                  child: Container(
                    // width: 140,
                    // height: 28,
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: index == 1 ? secondaryColor : Colors.transparent,
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          'Med. History',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: index == 1 ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // index = 2;
                      pageController!.jumpToPage(2);
                    });
                  },
                  child: Container(
                    // width: 140,
                    // height: 28,
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: index == 2 ? secondaryColor : Colors.transparent,
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          'Adh. Report',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: index == 2 ? Colors.white : Colors.black54,
                          ),
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
  }
}
