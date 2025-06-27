import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/screens/bottom_control/bottom_nav_bar.dart';

import '../../../api/appointment_service.dart';
import '../../../utils/global.dart';
import 'add_appointment.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late Future<dynamic> futureData;
  @override
  initState() {
    super.initState();
    futureData = _appointmentService.viewUpcomingAppointment();
  }

  final AppointmentService _appointmentService = AppointmentService();
  List<dynamic> appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Appointments',
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
        actions: [
          InkResponse(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => AddAppointment()));
            },
            child: Image.asset("assets/add.png", height: 30.r, width: 30.r),
          ),
          SizedBox(width: 16.sp),
        ],
      ),
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return helperWidget.noInternetScreen(() {
              setState(() {
                futureData = _appointmentService.viewUpcomingAppointment();
              });
            });
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return buildNoAppointmentWidget();
          } else {
            if (snapshot.data['count'] > 0) {
              appointments = snapshot.data['appointments'];
            }
            return appointments.isEmpty
                ? buildNoAppointmentWidget()
                : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buildUpcomingAppointmentWidget(appointments[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20.h);
                  },
                  itemCount: appointments.length,
                );
          }
        },
      ),
    );
  }

  Widget buildUpcomingAppointmentWidget(var appointmentData) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            // height: 121.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 241, 219, 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('d').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      (appointmentData['appointment_timestamp']),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('MMM').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      (appointmentData['appointment_timestamp']),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Container(
              // height: 121,
              padding: EdgeInsets.only(
                left: 14.w,
                right: 12.w,
                top: 9.h,
                bottom: 13.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.grey, width: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${appointmentData['hospital_name']}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            ),
                            InkWell(
                              onTapDown: (TapDownDetails details) {
                                _showPopupMenu(
                                  context,
                                  details.globalPosition,
                                  appointmentData,
                                );
                              },
                              child: const Icon(
                                Icons.more_vert,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          '${appointmentData['appointment_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.8),
                            fontSize: 16.sp,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          '${appointmentData['appointment_time']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.7),

                            fontSize: 15.sp,
                            height: 1.3,
                          ),
                        ),
                        if (appointmentData['doctors_name'] != '')
                          const Divider(color: Colors.grey, thickness: 0.8),
                        if (appointmentData['doctors_name'] != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${appointmentData['doctors_name']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 0.7),

                                  fontSize: 15.sp,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPopupMenu(
    BuildContext context,
    Offset offset,
    var appointmentData,
  ) async {
    final result = await showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx,
        offset.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Image.asset(
                "assets/button_edit_outline.png",
                fit: BoxFit.cover,
                height: 16.r,
                width: 16.r,
                color: Colors.black,
              ),
              const SizedBox(width: 5),
              const Text(
                'Edit Appointment',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Image.asset(
                "assets/button_delete_outlined.png",
                fit: BoxFit.cover,
                height: 18.r,
                width: 18.r,
              ),
              const SizedBox(width: 5),
              const Text(
                'Delete Appointment',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
      elevation: 2.0,
      color: Colors.white,
    );

    // Handle the menu item selection
    switch (result) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddAppointment(appointmentData: appointmentData),
          ),
        );

        break;
      case 'delete':
        showDeleteAppointmentDialog(context, appointmentData['_id']);
        break;

      default:
        break;
    }
  }

  showDeleteAppointmentDialog(BuildContext context, String appointmentID) {
    bool loading = false;
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Delete Apppointment',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const Text(
                        "Are you sure you want to delete this appointment?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: OutlinedButton(
                              child:
                                  loading
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
                                          fontSize: 16,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  loading = true;
                                });

                                try {
                                  var res = await _appointmentService
                                      .deleteAppointment(
                                        appointmentID: appointmentID,
                                      );
                                  if (res['status'] == 'ok') {
                                    helperWidget.showToast(
                                      "Appointment deleted successfully",
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => BottomNavBar(),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    helperWidget.showToast(
                                      "Oops! Something went wrong.",
                                    );
                                  }
                                } catch (e) {
                                  helperWidget.showToast(
                                    "Oops! Something went wrong.",
                                  );
                                } finally {
                                  setCustomState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: ElevatedButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
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

  Padding buildNoAppointmentWidget() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
      child: Column(
        children: [
          Image.asset(
            "assets/no_appointment.png",
            fit: BoxFit.cover,
            height: 165.h,
            width: 195.w,
          ),
          SizedBox(height: 10.h),
          Text(
            'You have not set any appointment reminder.',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 21.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => AddAppointment()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              ),
              child: Text(
                '+ Set New Appointments',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
