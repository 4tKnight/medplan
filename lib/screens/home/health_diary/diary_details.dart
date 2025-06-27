import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../api/health_diary_service.dart';
import '../../../utils/global.dart';
import '../../bottom_control/bottom_nav_bar.dart';
import 'add_health_diary.dart';
import 'my_health_diary.dart';

class DiaryDetails extends StatefulWidget {
  var healthDiaryData;
  int randNumber;
  DiaryDetails({super.key, required this.randNumber, this.healthDiaryData});

  @override
  State<DiaryDetails> createState() => _DiaryDetailsState();
}

class _DiaryDetailsState extends State<DiaryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.diaryColors[widget.randNumber],
      appBar: AppBar(
        backgroundColor: constants.diaryColors[widget.randNumber],
        elevation: 0,
        title: Text(
          DateFormat('MMM. d, h:mma').format(
            DateTime.fromMillisecondsSinceEpoch(
              widget.healthDiaryData['timestamp'],
            ),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        children: [
          Text.rich(
            TextSpan(
              text: 'MOOD: ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.healthDiaryData['mood']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const SizedBox(width: 60),
              // ...List.generate(widget.healthDiaryData['symptom'].length, (index){
              //   return  Padding(
              //     padding: const EdgeInsets.only(left:30.0),
              //     child:
              Image.asset(
                './assets/${constants.smileys[constants.smileys_text.indexOf(widget.healthDiaryData['mood'])]}',
                // "assets/smiley6.png",
                fit: BoxFit.cover,
                height: 28.r,
                width: 28.r,
              ),
              // );
              // })
            ],
          ),
          SizedBox(height: 24.h),
          Text.rich(
            TextSpan(
              text: 'SIGNS/SYMPTOM: ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              children: <TextSpan>[
                TextSpan(
                  text: (widget.healthDiaryData['symptom'] as List<dynamic>)
                      .join(', '),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 27.h),
          Text.rich(
            TextSpan(
              text: 'ADDITIONAL NOTE: ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.healthDiaryData['note']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 45.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => CreateDiary(diaryData: widget.healthDiaryData),
                    ),
                  );
                },
                child: Image.asset(
                  "assets/button_edit.png",
                  fit: BoxFit.cover,
                  height: 17.r,
                  width: 17.r,
                ),
              ),
              SizedBox(width: 24.w),
              InkWell(
                onTap: () {
                  showDeleteDialog(context);
                },
                child: Image.asset(
                  "assets/button_delete.png",
                  fit: BoxFit.cover,
                  height: 23.h,
                  width: 22.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final HealthDiaryService _healthDiaryService = HealthDiaryService();

  bool isLoading = false;
  showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 250,
                width: 120,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DELETE HEALTH NOTE',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Image.asset(
                          "./assets/smiley_shocked.png",
                          height: 52.r,
                          width: 52.r,
                        ),
                      ),
                      Text(
                        "Are you sure you want to delete this health note? Once deleted, it cannot be retrieved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            // width: 80,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 36.w,
                                  vertical: 8.h,
                                ),
                              ),
                              child:
                                  isLoading
                                      ? Center(
                                        child: SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  isLoading = true;
                                });
                                try {
                                  var res = await _healthDiaryService
                                      .deleteHealthDiary(
                                        healthDiaryId:
                                            widget.healthDiaryData['_id'],
                                      );

                                  if (res['status'] == 'ok') {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => BottomNavBar(),
                                      ),
                                      (route) => false,
                                    );

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const MyHealthDiary(),
                                      ),
                                    );

                                    helperWidget.showToast(
                                      "Note deleted successfully",
                                    );
                                  } else {
                                    helperWidget.showToast(
                                      'oOps something went wrong.\n Please try again later',
                                    );
                                  }
                                } catch (e) {
                                  helperWidget.showToast(
                                    "Oops! Something went wrong.",
                                  );
                                } finally {
                                  setCustomState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            // width: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 36.w,
                                  vertical: 8.h,
                                ),
                              ),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
