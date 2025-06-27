import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:medplan/utils/global.dart';

import '../../../api/health_diary_service.dart';
import '../../../utils/functions.dart';
import 'add_health_diary.dart';
import 'diary_details.dart';
import 'share_diary.dart';

class MyHealthDiary extends StatefulWidget {
  const MyHealthDiary({super.key});
  @override
  MyHealthDiaryState createState() => MyHealthDiaryState();
}

class MyHealthDiaryState extends State<MyHealthDiary> {
  int year = DateTime.now().year;

  late Future<dynamic> futureData;
  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    futureData = _healthDiaryService.viewHealthDiaries(year);
  }

  final HealthDiaryService _healthDiaryService = HealthDiaryService();
  List<dynamic> _healthDiaries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Health Diary',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => CreateDiary()));
              },
              child: Container(
                height: 27.r,
                width: 27.r,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 18.r),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
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
            return noHealthDiaryWidget();
          } else {
            my_log(snapshot.data);
            _healthDiaries = snapshot.data['health_diaries'];

            return Column(
              children: [
                if (snapshot.data['msg'] != 'no health_diaries at the moment')
                  Center(
                    child: myWidgets.buildYearOnlyWidget(year, (year) {
                      setState(() {
                        this.year = year;
                        loadFuture();
                      });
                    }),
                  ),
                if (snapshot.data['msg'] != 'no health_diaries at the moment')
                  SizedBox(height: 5.h),
                snapshot.data['msg'] == 'no health_diaries at the moment'
                    ? Expanded(child: noHealthDiaryWidget())
                    : _healthDiaries.isEmpty
                    ? Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: Center(
                        child: Text(
                          'No health diary records for $year',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                    : Expanded(
                      child: MasonryGridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                            ),
                        itemCount: _healthDiaries.length,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 22.w,
                        itemBuilder: (context, index) {
                          return buildDiaryWidget(_healthDiaries[index]);
                        },
                      ),
                    ),
              ],
            );
          }
        },
      ),
    );
  }

  // bool isEmptyState = true;

  Widget noHealthDiaryWidget() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      children: [
        // const SizedBox(height: 20),
        noHealthDiaryAsset(),
        SizedBox(height: 28.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 10.h),

          child: Text(
            "Control your mood and activities with medPlan Health Diary.",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 10.h),

          child: Text(
            "Document side effects from medications, symptoms etc.",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 10.h),

          child: Text(
            "Easily share diary records with Care givers and loved ones.",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
        ),
        SizedBox(height: 89.h),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => CreateDiary()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 40.w),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Stack noHealthDiaryAsset() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 9.0, left: 6),
          child: Image.asset(
            "assets/hd1.png",
            fit: BoxFit.cover,
            // height: 0,
            // width: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 55.0),
          child: Image.asset(
            "assets/hd2.png",
            fit: BoxFit.cover,
            // height: 0,
            // width: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0, right: 9, left: 6),
          child: Container(
            height: 195,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFAC66F2), Color(0xFF57307E)],
                stops: [0.064, 0.7489],
                transform: GradientRotation(123.7 * 3.1415927 / 180),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 21.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 16.r),
                    SizedBox(width: 8.w),
                    Text(
                      'Today, ${DateFormat('MMMM d, y').format(DateTime.now())}   ${DateFormat('h:mma').format(DateTime.now())}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "assets/smiley1.png",
                          fit: BoxFit.cover,
                          height: 39.r,
                          width: 39.r,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Happy',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/smiley6.png",
                          fit: BoxFit.cover,
                          height: 39.r,
                          width: 39.r,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Unwell',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/smiley8.png",
                          fit: BoxFit.cover,
                          height: 39.r,
                          width: 39.r,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Feverish',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/smiley10.png",
                          fit: BoxFit.cover,
                          height: 39.r,
                          width: 39.r,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Nauseous',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDiaryWidget(var healthDiaryData) {
    int randomNumber = Random().nextInt(5);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => DiaryDetails(
                  randNumber: randomNumber,
                  healthDiaryData: healthDiaryData,
                ),
          ),
        );
      },
      child: Container(
        width: 180.w,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: constants.diaryColors[randomNumber],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMM. d, h:mma').format(
                DateTime.fromMillisecondsSinceEpoch(
                  healthDiaryData['timestamp'],
                ),
              ),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
            SizedBox(height: 12.h.h),
            Text.rich(
              TextSpan(
                text: 'MOOD: ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
                children: <TextSpan>[
                  TextSpan(
                    text: '${healthDiaryData['mood']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h.h),
            Text.rich(
              TextSpan(
                text: 'SYMPTOM: ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
                children: <TextSpan>[
                  TextSpan(
                    text: (healthDiaryData['symptom'] as List<dynamic>).join(
                      ', ',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text.rich(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                text: 'NOTE: ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
                children: <TextSpan>[
                  TextSpan(
                    text: '${healthDiaryData['note']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget buildDiaryWidget(Map<String, dynamic> note) {
  //   // String date = time.dateFromTimestamp(note[db.DB_LAST_EDITED]);
  //   // String time12 = time.timeFromTimestamp(note[db.DB_LAST_EDITED]);
  //   // Color color = constants.decide_color(note[db.DB_COLOR]);

  //   // String moodLowerCaps = note[db.DB_MOOD][0];
  //   // String mood =
  //   //     "${moodLowerCaps[0].toUpperCase()}${moodLowerCaps.substring(1)}";

  //   // String addNote = note[db.DB_NOTE];

  //   // String symptoms = note[db.DB_SYMPTOMS].length == 0
  //   //     ? "None"
  //   //     : note[db.DB_SYMPTOMS].join(", ");

  //   return GestureDetector(
  //     onTap: () {
  //       // print(note.toString());
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (_) => DiaryDetails(
  //       //       note,
  //       //       color: color,
  //       //       date: date,
  //       //       time: time12,
  //       //       mood: moodLowerCaps,
  //       //       additional_note: addNote,
  //       //       symptoms: symptoms,
  //       //     ),
  //       //   ),
  //       // ).then((deletedNote) {
  //       //   if (deletedNote != null) {
  //       //     returnedHealthList
  //       //         .removeAt(returnedHealthList.indexOf(deletedNote));
  //       //     setState(() {});
  //       //   }
  //       // });
  //     },
  //     child: Material(
  //       elevation: 0.5,
  //       shadowColor: Theme.of(context).shadowColor,
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Center(
  //             child: Container(
  //               height: 40,
  //               width: 100,
  //               color: color,
  //               child: FittedBox(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Text(date),
  //                       Text(time12),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 6),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("MOOD: $mood"),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     "SYMPTOM: $symptoms",
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 2,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Expanded(
  //                     child: Text(
  //                       "NOTE: $addNote",
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 2,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
