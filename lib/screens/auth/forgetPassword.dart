import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/screens/auth/auth_login_signup.dart';
import 'package:medplan/utils/global.dart';

import '../../api/api_client.dart';
import '../../api/auth_service.dart';
import '../../server/auth_api_requests.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final AuthService _authService = AuthService();

  TabController? _tabController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int loadingState = 0;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Image.asset("./assets/doc.png"),
          // Image.asset("./assets/bg.png"),
          // Positioned.fill(
          //   top: 50,
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Image.asset(
          //       "./assets/medplan_full.png",
          //       // alignment: Alignment.topCenter,
          //       color: Colors.white,
          //       height: 140,
          //       width: 140,
          //     ),
          //   ),
          // ),
          Positioned(
            top: -200,
            left: -100,
            child: Image.asset(
              "./assets/bg.png",
              fit: BoxFit.cover,
              height: 500,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                SizedBox(height: 70.h),
                Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: "logo",
                    child: Image.asset(
                      "./assets/medplan_full.png",
                      color: Colors.white,
                      width: 180.w,
                    ),
                  ),
                ),
                SizedBox(height: 64.h),

                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 600,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 50.0.h,
                          ),

                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: primaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            "Enter the email associated with your account and we’ll send an email with instructions to reset your password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                              // fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: 86.h),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Enter email",
                                    hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                    ),
                                    isDense: true,
                                  ),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  enabled: loadingState == 0 ? true : false,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Back to",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          " Login",
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(height: 46.h),
                                SizedBox(
                                  // width: 250,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 100.w,
                                      ),
                                    ),
                                    onPressed:
                                        loading
                                            ? null
                                            : () {
                                              if (emailController
                                                  .text
                                                  .isNotEmpty) {
                                                fireForgotPassword();
                                              } else {
                                                helperWidget.showToast(
                                                  "Email field must be filled",
                                                );
                                              }
                                            },
                                    child:
                                        loading == true
                                            ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                            : Text(
                                              "Send",
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 106.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showForgetPasswordSuccessDialogue(String title, String description) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 250,
            width: 120,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      "./assets/smiley_reset_password.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Text(description, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const Login()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 25,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      "Back to Login",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool loading = false;

  fireForgotPassword() async {
    try {} catch (e) {
      helperWidget.showToast("Email not sent");
    } finally {
      setState(() {
        loading = false;
      });
    }
    var res = await _authService.forgotPassword(
      email: emailController.text.trim(),
    );

    if (res['status'] == 'ok') {
      showForgetPasswordSuccessDialogue(
        'RESET PASSWORD',
        'We have sent password recovery instructions to your email',
      );
    } else if (res['msg'] == 'Please enter a valid email') {
      helperWidget.showToast("Please enter a valid email");
    } else if (res['msg'] == 'There is no user account with this email') {
      helperWidget.showToast("There is no user account with this email");
    } else {
      helperWidget.showToast("Email not sent");
    }
  }
}
