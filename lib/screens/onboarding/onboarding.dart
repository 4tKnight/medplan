import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';

import '../auth/auth_login_signup.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  PageController pageController = PageController();

  List<String> title = [
    "Experience Complete Care",
    "24/7  Free Access to your Pharmacist",
    "Never Miss a Pill",
  ];
  List<String> details = [
    "We provide tools and resources which empower you to better manage your own health",
    "From counseling to medication therapy review, your Pharmacist is always there to support you.",
    "Stay on top of your health with our medication reminders. You never need to miss a pill again.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            children: [
              Image.asset("./assets/onboarding1.png", fit: BoxFit.cover),
              Image.asset("./assets/onboarding2.png", fit: BoxFit.cover),
              Image.asset("./assets/onboarding3.png", fit: BoxFit.cover),
            ],
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.61,
            left: 18.w,
            right: 18.w,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/medplan.png", scale: 4.5),
                  SizedBox(height: 23.h),
                  Text(
                    title[currentIndex],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 17.h),
                  Text(
                    details[currentIndex],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    title.length,
                    (index) => buildDot(index, context),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: currentIndex == 2 ? 40.w : 60.0.w,
                      vertical: 10.h,
                    ),
                  ),
                  child: Text(
                    currentIndex == 2 ? "Get Started" : "Next",
                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                  ),
                  onPressed: () async {
                    currentIndex == 2
                        ? skip()
                        : pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void skip() {
    getX.write(v.GETX_IS_FIRST_TIME, true);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => Login()),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 8.h,
      width: currentIndex == index ? 30.w : 8.w,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: currentIndex == index ? primaryColor : Colors.white,
      ),
    );
  }
}
