import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';

import 'health_record_body.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Center(
              child: Text(
                'Health Records',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(1.5),
                  child:
                      getX.read(v.GETX_USER_IMAGE) == ''
                          ? myWidgets.noProfileImage(37.r)
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: helperWidget.cachedImage(
                              url: '${getX.read(v.GETX_USER_IMAGE)}',
                              height: 37.h,
                              width: 37.w,
                            ),
                          ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            const HealthRecordBody(),
          ],
        ),
      ),
    );
  }
}
