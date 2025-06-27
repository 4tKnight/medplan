import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medplan/utils/global.dart';

import '../../api/profile_service.dart';
import '../../utils/functions.dart';
import '../health_record/health_record.dart';
import '../health_tips/ht_control.dart';
import '../home/home.dart';
import '../medicines/medicine_controller.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({this.index = 0, this.ht_index = 0, super.key});
  int index;
  int ht_index;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int current_index;
  List<Widget> screens = [];

  void update_index(int value) {
    setState(() {
      current_index = value;
    });
  }

  final ProfileService _profileService = ProfileService();

  void getCurrentProfileData() async {
    try {
      var res = await _profileService.viewProfile();
      my_log(res);
      if (res['status'] == 'ok') {
        set_getX_data(context, res);
      }
    } catch (e) {
      my_log(e);
      helperWidget.showToast(
        'oOps something went wrong while fetching profile data',
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (getX.read(v.GETX_IS_LOGGED_IN) != null) {
      getCurrentProfileData();
    }
    current_index = widget.index;
    screens = [
      const HomePage(),
      MedicinesController(),
      const HealthRecord(),
      HealthTipsControl(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: current_index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 15,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: Theme.of(context).cardColor,
        // backgroundColor: darkNotifier.value ? : Color.fromRGBO(246, 247, 251, 1),
        type: BottomNavigationBarType.fixed,
        currentIndex: current_index,
        onTap: update_index,
        unselectedLabelStyle: TextStyle(
          overflow: TextOverflow.visible,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: darkNotifier.value ? Colors.white : Colors.grey,
        ),
        selectedLabelStyle: TextStyle(
          overflow: TextOverflow.visible,
          fontSize: 10,
          color: darkNotifier.value ? const Color(0x000d8ce9) : primaryColor,
        ),
        // showUnselectedLabels: false,
        // showSelectedLabels: false,
        unselectedItemColor: darkNotifier.value ? Colors.white : Colors.grey,
        selectedItemColor: primaryColor,

        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "./assets/bt1.svg",
              color: darkNotifier.value ? Colors.white : Colors.grey,
            ),
            activeIcon: buildActiveIcon("bt1c"),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "./assets/bt2.svg",
              color: darkNotifier.value ? Colors.white : Colors.black,
            ),
            activeIcon: buildActiveIcon("bt2c"),

            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "./assets/bt3.svg",
              color: darkNotifier.value ? Colors.white : Colors.black,
            ),
            activeIcon: buildActiveIcon("bt3c"),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "./assets/bt4.svg",
              color: darkNotifier.value ? Colors.white : Colors.black,
            ),
            activeIcon: buildActiveIcon("bt4c"),
            label: 'Tips',
          ),
        ],
      ),
    );
  }

  Container buildActiveIcon(String img) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset("./assets/$img.png", height: 28, width: 28),
    );
  }
}
