import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class HealthRecordWidgets {
  Container buildRecordValueAreaV2({
    required String title,
    required String image,
    required Widget addButton,
    required Function(int) removeFunc,
    required String fieldName,
    required List<dynamic> dataList,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: myWidgets.commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/$image.png',
                fit: BoxFit.cover,
                height: 25.h,
                width: 24.w,
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(
                  'My $title',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(),
              // const InkWell(child: Icon(Icons.edit, size: 20)),
            ],
          ),
          SizedBox(height: 23.h),
          dataList.isEmpty
              ? Column(
                children: [
                  Image.asset(
                    "assets/no_record.png",
                    fit: BoxFit.cover,
                    height: 108.h,
                    width: 156.w,
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    'No data entered. Tap the icon to add your $title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(dataList.length, (index) {
                  return healthRecordWidgets.buildTileV2(
                    dataList[index][fieldName],
                    dataList[index]['timestamp'],
                    () {
                      removeFunc(index);
                    },
                  );
                }),
              ),
          SizedBox(height: 30.h),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [addButton]),
        ],
      ),
    );
  }

  Widget buildTileV2(String value, int timestamp, Function() removeFunc) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '•  $value ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    '(${time.timestamp(timestamp)})',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 244, 255, 1),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  child: const Icon(Icons.close, color: Colors.black, size: 10),
                  onTap: () {
                    removeFunc();
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Divider(height: 1.h, color: Color.fromRGBO(0, 0, 0, 0.2)),
        SizedBox(height: 14.h),
      ],
    );
  }

  Container buildRecordValueArea(
    String title,
    String image,
    String value,
    String unit,
    Widget addButton, {
    String fieldName = '',
    var minReading,
    var maxReading,
    var avgReading,
    List<dynamic> readings = const [],
    int month = 0,
    int year = 2021,
    Function(int month, int year)? setDateFunc,
  }) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: myWidgets.commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'My $title Values',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              myWidgets.buildRecordDateWidget(
                month: month,
                year: year,
                setDateFunc: setDateFunc!,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Image.asset(
                "assets/$image.png",
                fit: BoxFit.cover,
                height: 53.h,
                width: 76.w,
              ),
              SizedBox(width: 38.w),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    healthRecordWidgets.buildMinWidget(minReading),
                    healthRecordWidgets.buildAvgWidget(avgReading),
                    healthRecordWidgets.buildMaxWidget(maxReading),
                  ],
                ),
              ),
              SizedBox(width: 25.w),
            ],
          ),
          SizedBox(height: 27.h),
          readings.isEmpty
              ? Column(
                children: [
                  Image.asset(
                    "assets/no_record.png",
                    fit: BoxFit.cover,
                    height: 108.h,
                    width: 156.w,
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    'No data entered. Tap the icon to add your health data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(readings.length, (index) {
                  return healthRecordWidgets.buildTile(
                    '${readings[index][fieldName]}$unit',
                    readings[index]['timestamp'],
                  );
                }),
              ),
          SizedBox(height: 7.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              healthRecordWidgets.buildshareButton(),
              SizedBox(width: 20.w),
              addButton,
            ],
          ),
        ],
      ),
    );
  }

  Container buildshareButton() {
    return Container(
      height: 25,
      width: 25,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(253, 170, 39, 1),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        child: const Icon(Icons.share_outlined, color: Colors.white, size: 15),
        onTap: () {},
      ),
    );
  }

  Widget buildChartArea(
    String yAxisName,
    double yAxisMax,
    double yAxisMin,
    double yAxisInterval, {
    String fieldName = '',
    int month = 1,
    List<dynamic> readings = const [],
  }) {
    return Container(
      decoration: myWidgets.commonContainerDecoration(),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            '${time.getMonthString(month)} Stats.',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                // lineTouchData: LineTouchData(enabled: true),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,

                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    axisNameSize: 20,
                    axisNameWidget: Text(
                      yAxisName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: yAxisInterval,
                      // getTitlesWidget: leftTitleWidgets,
                      // reservedSize: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value % 1 == 0
                              ? value.toInt().toString()
                              : value.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 15,
                    axisNameWidget: Text(
                      'Days',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3, // Show every day
                      // reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        if (value >= 1 && value <= 30) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 1,
                maxX: 31,
                minY: yAxisMin,
                maxY: yAxisMax,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(31, (index) {
                      final day = (index + 1).toDouble();
                      // Find reading for this day
                      final reading = readings.firstWhere((e) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                          e['timestamp'],
                        );
                        return date.day == (index + 1);
                      }, orElse: () => null);
                      final pulseRate =
                          reading != null
                              ? (reading[fieldName]?.toDouble() ?? 0.0)
                              : 0.0;

                      return FlSpot(day, pulseRate);
                    }),

                    isCurved: true,
                    // colors: [Colors.blue],
                    barWidth: 1,
                    // isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(String value, int timestamp) {
    return Column(
      children: [
        SizedBox(height: 13.h),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•  $value',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              Text(
                time.formatTimestampWithSuffix(timestamp),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black45,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        helperWidget.build_divider(),
      ],
    );
  }

  Widget buildMinWidget(var min) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 5.h,
              width: 4.w,
              color: const Color.fromRGBO(253, 170, 39, 1),
              margin: EdgeInsets.only(bottom: 5.h),
            ),
            SizedBox(width: 4.w),
            Text(
              'Min',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 8.w),
            Text(
              '$min',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAvgWidget(var avg) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 10.h,
              width: 4.w,
              color: const Color.fromRGBO(71, 198, 68, 1),
              margin: EdgeInsets.only(bottom: 5.h),
            ),
            SizedBox(width: 3.w),
            Text(
              'Avg',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 8.w),
            Text(
              '$avg',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMaxWidget(var max) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 15.h,
              width: 4.w,
              color: const Color.fromRGBO(242, 10, 10, 1),
              margin: const EdgeInsets.only(bottom: 5),
            ),
            SizedBox(width: 3.w),
            Text(
              'Max',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 8.w),
            Text(
              "$max",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }
}
