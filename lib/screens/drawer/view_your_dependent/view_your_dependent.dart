import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/screens/drawer/view_your_dependent/dependent_health_record.dart';
import 'package:medplan/screens/medicines/medication_reminder/set_medication_reminder_1.dart';

import '../../../utils/global.dart';
import '../../health_record/health_record_body.dart';
import '../app_drawer.dart';
import 'dependent_medication.dart';
import 'dependent_medication_history.dart';

class ViewYourDependent extends StatefulWidget {
  var dependentData;
  ViewYourDependent({super.key, required this.dependentData});

  @override
  State<ViewYourDependent> createState() => _ViewYourDependentState();
}

class _ViewYourDependentState extends State<ViewYourDependent> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(scaffoldKey: scaffoldKey),

      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(18.w, 23.h, 18.w, 30.h),

          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        child: const Icon(Icons.menu),
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      SizedBox(width: 9.w),
                      Text(
                        'Hi ${getX.read(v.GETX_USERNAME)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '< Back to my account',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.h),
            Text(
              'You are viewing your dependents account ${widget.dependentData['first_name']} ${widget.dependentData['last_name']}”. ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 23.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.dependentData['img_url'] == null ||
                            widget.dependentData['img_url'] == ''
                        ? myWidgets.noProfileImage(31.r)
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: helperWidget.cachedImage(
                            url: '${widget.dependentData['img_url']}',
                            height: 30.h,
                            width: 30.w,
                          ),
                        ),
                    SizedBox(width: 6.w),
                    Text(
                      '${widget.dependentData['first_name']} ${widget.dependentData['last_name']}(Dependent)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                if (selectedTab == 'Medications')
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SetMedicationReminderStepOne(
                                isDependent: true,
                                dependentId: widget.dependentData['_id'],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.r,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 18.r),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            buildSelector(),
            const SizedBox(height: 20),
            selectedTab == 'Medications'
                ? DependentMedication(dependentId: widget.dependentData['_id'])
                : selectedTab == 'Medication History'
                ? DependentMedicationHistory(
                  dependentId: widget.dependentData['_id'],
                )
                : DependentHealthRecord(dependentData: widget.dependentData,),
          ],
        ),
      ),
    );
  }

  String selectedTab = 'Medications';
  Widget buildSelector() {
    return Container(
      // height: 45,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(241, 241, 246, 1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTab = 'Medications';
                });
              },
              child: Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color:
                      selectedTab == 'Medications'
                          ? secondaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    'Medications',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color:
                          selectedTab == 'Medications'
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTab = 'Medication History';
                });
              },
              child: Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color:
                      selectedTab == 'Medication History'
                          ? secondaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    'Med. History',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color:
                          selectedTab == 'Medication History'
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTab = 'Health Records';
                });
              },
              child: Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color:
                      selectedTab == 'Health Records'
                          ? secondaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    'Health Records',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color:
                          selectedTab == 'Health Records'
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
