import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/profile_service.dart';
import 'package:medplan/screens/auth/forgetPassword.dart';
import 'package:medplan/utils/global.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../api/auth_service.dart';
import '../../utils/functions.dart';
import '../bottom_control/bottom_nav_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // TabController? _tabController;

  final AuthService _authService = AuthService();

  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  // int loading = false;
  // bool obscureText2 = true;
  bool obscureLoginPassword = true;
  bool obscureSignUpPassword = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: CupertinoButton(
          //     child: Text("Skip", style: TextStyle(color: primaryColor)),
          //     onPressed: () {
          //         // Navigator.push(
          //         //                                   context,
          //         //                                   CupertinoPageRoute(
          //         //                                       builder: (_) =>
          //         //                                           InterestPage()));
          //     },
          //   ),
          // ),
          // Image.asset("./assets/doc.png"),
          Positioned(
            top: -200,
            left: -100,
            child: Image.asset(
              "./assets/bg.png",
              fit: BoxFit.cover,
              height: 500,
            ),
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                Hero(
                  tag: "logo",
                  child: Image.asset(
                    "./assets/medplan_full.png",
                    // color: Colors.white,
                    width: 180.w,
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
                    height: 600.h,
                    width: double.infinity,
                    child: Column(
                      children: [
                        // build_tab_bar(),
                        _buildTabBar(),
                        Expanded(
                          child:
                              _selectedIndex == 0
                                  ?
                                  //*LOGIN IN
                                  buildLoginWidget(context)
                                  :
                                  //*SIGN UP
                                  buildSignUpWidget(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  style: TextButton.styleFrom(
                    // padding: const EdgeInsets.symmetric(horizontal: 50),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (_) => BottomNavBar()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // SizedBox(height: 50.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildSignUpWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment:
                //     CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter a Username",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                    ),
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    enabled: !loading,
                  ),
                  SizedBox(height: 35.h),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !loading,
                  ),

                  SizedBox(height: 35.h),

                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter Phone number",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                    ),
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(11)],
                    textInputAction: TextInputAction.next,
                    enabled: !loading,
                  ),
                  SizedBox(height: 25.h),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 16),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureSignUpPassword = !obscureSignUpPassword;
                            });
                          },
                          child: Icon(
                            obscureSignUpPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    obscureText: obscureSignUpPassword,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    enabled: !loading,
                  ),
                  SizedBox(height: 70.h),
                  SizedBox(
                    // height: 44.h,
                    // width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 100.w,
                        ),
                      ),
                      child:
                          loading == true
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (usernameController.text.isEmpty) {
                          helperWidget.showToast(
                            "Username is required.",
                            isError: true,
                          );
                          return;
                        }
                        if (phoneController.text.isEmpty) {
                          helperWidget.showToast(
                            "Phone number is required.",
                            isError: true,
                          );
                          return;
                        }
                        if (emailController.text.isEmpty) {
                          helperWidget.showToast(
                            "Email is required.",
                            isError: true,
                          );
                          return;
                        }
                        if (passwordController.text.isEmpty) {
                          helperWidget.showToast(
                            "Password is required.",
                            isError: true,
                          );
                          return;
                        }
                        if (loading == false) {
                          setState(() {
                            loading = true;
                          });

                          try {
                            String phoneNumber = phoneController.text.trim();

                            if (phoneNumber.startsWith('0')) {
                              phoneNumber = '+234${phoneNumber.substring(1)}';
                            }
                            var res = await _authService.signup(
                              phoneNo: phoneNumber,
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              username: usernameController.text.trim(),
                            );

                            if (res["status"] == "ok" &&
                                res["msg"] == "success") {
                              helperWidget.showToast(
                                "Account created succcessfully. Proceed to login",
                              );
                              setState(() {
                                _selectedIndex = 0;
                              });
                            } else if (res["msg"] ==
                                "an account with this email already exists") {
                              showLoginFailedDialogue(
                                'SIGNUP FAILED',
                                "An account with this email already exists",
                              );
                            } else if (res["msg"] ==
                                "an account with this phone number already exists") {
                              showLoginFailedDialogue(
                                'SIGNUP FAILED',
                                "An account with this phone number already exists",
                              );
                            } else {
                              showLoginFailedDialogue(
                                'SIGNUP FAILED',
                                "An error occurred. Please try again",
                              );
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                  ),

                  // const Spacer(),
                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                // style: Theme.of(context)
                //     .textTheme
                //     .headline2,
                style: TextStyle(color: Colors.black87, fontSize: 14.h),
              ),
              GestureDetector(
                child: Text(
                  "Login",
                  style: TextStyle(color: primaryColor, fontSize: 14.h),
                ),
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 26.h),
        ],
      ),
    );
  }

  Padding buildLoginWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment:
                //     CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !loading,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                      // contentPadding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ),
                  SizedBox(height: 35.h),

                  TextField(
                    obscureText: obscureLoginPassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 16),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureLoginPassword = !obscureLoginPassword;
                          });
                        },
                        child: Icon(
                          obscureLoginPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    enabled: !loading,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ForgetPassword(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    // width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 100.w,
                        ),
                      ),
                      child:
                          loading == true
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Log in",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (emailController.text.isEmpty) {
                          helperWidget.showToast(
                            "Email is required.",
                            isError: true,
                          );
                          return;
                        }
                        if (passwordController.text.isEmpty) {
                          helperWidget.showToast(
                            "Password is required.",
                            isError: true,
                          );
                          return;
                        }

                        if (loading == false) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            var res = await _authService.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (res["status"] == "ok") {
                              // helperWidget.showToast(
                              //   "Login successful",
                              // );

                              _setDeviceToken(res);
                            } else if (res["msg"] == "user not found") {
                              showLoginFailedDialogue(
                                'LOGIN FAILED',
                                "User not found",
                              );
                              setState(() {
                                loading = false;
                              });
                            } else if (res["msg"] == "account blocked") {
                              showLoginFailedDialogue(
                                'LOGIN FAILED',
                                "Account blocked",
                              );
                              setState(() {
                                loading = false;
                              });
                            } else if (res["msg"] == "account deleted") {
                              showLoginFailedDialogue(
                                'LOGIN FAILED',
                                "Account deleted",
                              );
                              setState(() {
                                loading = false;
                              });
                            } else if (res["msg"] == "incorrect password") {
                              showLoginFailedDialogue(
                                'LOGIN FAILED',
                                'The login details you entered do not match our records. Please double-check and try again',
                              );
                              setState(() {
                                loading = false;
                              });
                            } else {
                              helperWidget.showToast("An error occured");
                              setState(() {
                                loading = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              loading = false;
                            });
                          }
                        } else {
                          helperWidget.showToast("Logging in, please wait...");
                        }
                      },
                    ),
                  ),

                  // const Spacer(),
                  // const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Are you new to medPlan? ",
                // style: Theme.of(context)
                //     .textTheme
                //     .headline2,
                style: TextStyle(color: Colors.black87, fontSize: 14.sp),
              ),
              GestureDetector(
                child: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 14.sp, color: primaryColor),
                ),
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  // _tabController!.index = 1;
                },
              ),
            ],
          ),
          SizedBox(height: 26.h),
        ],
      ),
    );
  }

  _setDeviceToken(dynamic userData) async {
    String? deviceToken = OneSignal.User.pushSubscription.id;
    print('>>>>>>>>>>>>>>>>>>>>>>> $deviceToken ');
    if (deviceToken != null) {
      try {
        var res = await ProfileService().setDeviceToken(
          token: userData['token'],
          deviceToken: deviceToken,
        );
        my_log(res);

        if (res["status"] == "ok") {
          print("Device token set successfully");
          // helperWidget.showToast("Device token set successfully");
          set_getX_data(context, userData);
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (_) => BottomNavBar()),
            (route) => false,
          );
        } else {
          print("Failed to set device token");
          helperWidget.showToast("Failed to set device token");
        }
      } catch (e) {
        print(e);
        helperWidget.showToast(
          "Oops! Something went wrong while trying to log you in. Please try again",
        );
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
      print("Device token is null");
      helperWidget.showToast(
        "Oops! Something went wrong while fectching device token",
      );
    }
  }

  int _selectedIndex = 0;

  Widget _buildTabBar() {
    return Container(
      height: 40,

      margin: EdgeInsets.symmetric(horizontal: 35.w, vertical: 35.0.h),

      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,

          width: 1,
          style: BorderStyle.solid,
        ),

        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildTab(0, "Log in")),
          Expanded(child: _buildTab(1, "Sign Up")),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String text) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: index == 0 ? Radius.circular(6) : Radius.zero,
            right: index == 1 ? Radius.circular(6) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // Padding build_tab_bar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 25.0),
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 40),
  //       padding: EdgeInsets.zero,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           width: 1,
  //           style: BorderStyle.solid,
  //           color: primaryColor,
  //         ),
  //         borderRadius: BorderRadius.circular(6),
  //         color: Colors.white,
  //       ),
  //       child: TabBar(
  //         dividerColor: Colors.transparent,
  //         indicator: BubbleTabIndicator(
  //           indicatorHeight: 30.0,
  //           indicatorRadius: 6,
  //           indicatorColor: primaryColor,
  //           // tabBarIndicatorSize: TabBarIndicatorSize.tab,
  //           // padding: EdgeInsets.zero,
  //           // insets: EdgeInsets.zero,
  //         ),
  //         labelColor: Colors.white,
  //         unselectedLabelColor: primaryColor,
  //         indicatorColor: primaryColor,
  //         controller: _tabController,
  //         tabs: const <Widget>[
  //           Center(
  //             child: Text(
  //               'Log in',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ),
  //           Text(
  //             'Sign up',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  showLoginFailedDialogue(String title, String description) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            // height: 250,
            width: 120,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      "./assets/smiley_login_failed.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Text(description, textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Try Again",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const ForgetPassword(),
                        ),
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
                    child: const Text("Forgot Password"),
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
}
