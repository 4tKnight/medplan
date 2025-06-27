import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/global.dart';
import '../app_drawer.dart';
import 'companion_medication.dart';
import 'companion_medication_history.dart';

class ViewAsCompanion extends StatefulWidget {
  var companionData;
  ViewAsCompanion({super.key, required this.companionData});

  @override
  State<ViewAsCompanion> createState() => _ViewAsCompanionState();
}

class _ViewAsCompanionState extends State<ViewAsCompanion> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  _launchDialer(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
              'You are viewing ${widget.companionData['first_name']}’s medication list as a Companion.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.companionData['first_name']}’s Medications (Trackee)',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _launchDialer(widget.companionData['active_call_line']);
                  },
                  child: Container(
                    width: 35.r,
                    height: 35.r,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(234, 242, 253, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.phone, size: 20.r, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const SizedBox(), Expanded(child: buildSelector())],
            ),
            SizedBox(height: 17.h),
            selectedTab == 'Medications'
                ? CompanionMedication(dependentId: widget.companionData['_id'])
                : CompanionMedicationHistory(
                  dependentId: widget.companionData['_id'],
                ),
          ],
        ),
      ),
    );
  }

  String selectedTab = 'Medications';
  Widget buildSelector() {
    return Container(
      // height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(241, 241, 246, 1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
                    maxLines: 1,
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
          const SizedBox(width: 10),
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
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'Medication History',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
        ],
      ),
    );
  }
}
