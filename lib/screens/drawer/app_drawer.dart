import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medplan/screens/drawer/privacy_policy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/auth_service.dart';
import '../../api/companion_service.dart';
import '../../api/dependent_service.dart';
import '../../api/profile_service.dart';
import '../../utils/functions.dart';
import '../../utils/global.dart';
import '../auth/auth_login_signup.dart';
import '../bottom_control/bottom_nav_bar.dart';
import 'about_medplan.dart';
import 'add_campanion.dart';
import 'add_dependent.dart';
import 'bug_report.dart';
import 'edit_profile.dart';
import 'medplan_coin.dart';
import 'notifications_preference.dart';
import 'view_as_campanion/view_as_campanion.dart';
import 'view_your_dependent/view_your_dependent.dart';

class AppDrawer extends StatelessWidget {
  var scaffoldKey;
  AppDrawer({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 41.h, horizontal: 16.w),
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();
                },
                child: Container(
                  height: 22.r,
                  width: 22.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 21.r,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                getX.read(v.GETX_USER_IMAGE) == ''
                    ? myWidgets.noProfileImage(54.r)
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(360.r),
                      child: helperWidget.cachedImage(
                        url: '${getX.read(v.GETX_USER_IMAGE)}',
                        height: 54.r,
                        width: 54.r,
                      ),
                    ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getX.read(v.GETX_USERNAME) ?? "User"}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const EditProfile(),
                                ),
                              );
                            },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: Color.fromRGBO(251, 187, 86, 1),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MedplanCoin(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/coin.png",
                                  height: 19.h,
                                  width: 20.w,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${getX.read(v.GETX_MEDPLAN_COINS) ?? '0'} left',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 1.h,
              // height: 40,
            ),
            BuildDependents(),
            Divider(
              color: Colors.white,
              thickness: 0.5.h,
              // height: 40,
            ),
            const BuildCompanions(),

            Divider(color: Colors.white, thickness: 0.5.h),

            const BuildCompanionTrackee(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 21.h),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     drawerItem('Dark Mode', 'assets/dark_mode.svg'),
                //     StatefulBuilder(builder: (context, setCustomState) {
                //       return Container(
                //         height: 20,
                //         width: 30,
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.white),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: FittedBox(
                //           child: Switch(
                //             value: getX.read(v.GETX_PREFS)['dark_mode'],
                //             onChanged: (bool value) async {
                //               final ProfileService profileService =
                //                   ProfileService();

                //               setCustomState(() {
                //                 getX.read(v.GETX_PREFS)['dark_mode'] =
                //                     !getX.read(v.GETX_PREFS)['dark_mode'];
                //               });
                //               try {
                //                 var res = await profileService
                //                     .editAccountPreferences(
                //                         getX.read(v.GETX_PREFS));
                //                 print(res);
                //                 if (res['status'] != 'ok') {
                //                   helperWidget.showToast(
                //                       "Oops! Something went wrong.");
                //                 }
                //               } catch (e) {
                //                 helperWidget
                //                     .showToast("Oops! Something went wrong.");
                //               }
                //             },
                //             activeColor: Colors.white,
                //             activeTrackColor: Colors.transparent,
                //             inactiveThumbColor: Colors.white,
                //             inactiveTrackColor: Colors.transparent,
                //           ),
                //         ),
                //       );
                //     }),
                //   ],
                // ),

                // const SizedBox(
                //   height: 15,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     drawerItem(
                //       'Notification sound',
                //       'assets/notification.svg',
                //     ),
                //     Container(
                //       height: 20,
                //       width: 30,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.white),
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       child: FittedBox(
                //         child: Switch(
                //           value: true,
                //           onChanged: (bool value) {},
                //           activeColor: Colors.white,
                //           activeTrackColor: Colors.transparent,
                //           inactiveThumbColor: Colors.white,
                //           inactiveTrackColor: Colors.transparent,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationPreference(),
                      ),
                    );
                  },
                  child: drawerItem(
                    'Choose notification sound',
                    'assets/notification.svg',
                  ),
                ),
                // const SizedBox(
                //   height: 0,
                // ),
                drawerItem('Rate MedPlan App', 'assets/rate.svg'),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutMedplan()),
                    );
                  },
                  child: drawerItem('About MedPlan', 'assets/about.svg'),
                ),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrivacyPolicy()),
                    );
                  },
                  child: drawerItem('Privacy Policy', 'assets/privacy.svg'),
                ),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BugReport()),
                    );
                  },
                  child: drawerItem('Report a Bug', 'assets/bug_report.svg'),
                ),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Share.share(
                      'Your health is your greatest asset. Take charge of it today! 💪\nDownload the MedPlan app now to stay consistent with your medications and become more informed about your health ',
                    );
                  },
                  child: drawerItem(
                    'Share medPlan app with friends',
                    'assets/share_app.svg',
                  ),
                ),
                // const SizedBox(
                //   height: 0,
                // ),
                InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    launchUrl(
                      Uri(scheme: 'mailto', path: 'medplan.help@gmail.com'),
                    );
                  },
                  child: drawerItem('Contact MedPlan', 'assets/contact.svg'),
                ),
              ],
            ),
            SizedBox(height: 31.h),
            Divider(color: Colors.white, thickness: 0.5.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: Colors.white.withValues(alpha: 0.3),
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: drawerItem('Sign out', 'assets/sign_out.svg'),
                  ),
                  // const SizedBox(
                  //   height: 0,
                  // ),
                  InkWell(
                    splashColor: Colors.white.withValues(alpha: 0.3),
                    onTap: () {
                      showDeleteDialog(context);
                    },
                    child: drawerItem('Delete my account', 'assets/delete.svg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(String title, String icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 5),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DELETE ACCOUNT',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Image.asset(
                        "./assets/smiley_delete.png",
                        height: 46.h,
                        width: 48.w,
                      ),
                      SizedBox(height: 17.h),
                      Text(
                        "We really don’t want to see you go. Delete anyway?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                              onPressed: () {
                                enterPassword(context);
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

  Future<dynamic> enterPassword(BuildContext context) {
    String password = "";
    bool isLoading = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please enter your app password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 44,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (newValue) {
                          password = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: false,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.fromLTRB(
                            10,
                            0,
                            10,
                            0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              if (password.isEmpty) {
                                helperWidget.showToast("Please enter password");
                                return;
                              }
                              setCustomState(() {
                                isLoading = true;
                              });
                              try {
                                var res = await _authService.deleteAccount(
                                  password: password,
                                );

                                if (res['status'] == 'ok') {
                                  getX.erase();
                                  getX.write(v.GETX_IS_FIRST_TIME, true);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => const Login(),
                                    ),
                                    (route) => false,
                                  );
                                } else if (res['msg'] == 'incorrect password') {
                                  helperWidget.showToast('Incorrect password');
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
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Proceed",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final AuthService _authService = AuthService();

  showLogoutDialog(BuildContext context) {
    bool loading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SizedBox(
                height: 380.h,
                // width: 318.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 31.w,
                    right: 31.w,
                    top: 16.h,
                    bottom: 44.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN OUT OF ACCOUNT',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 46.h,
                          width: 48.w,
                        ),
                      ),
                      Text(
                        "Why risk losing your data? Remain signed in to sync your data and keep it safe?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 27.h),
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
                            'Yes, keep me signed in',
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
                      SizedBox(height: 21.h),
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
                                    "No, Sign me out",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                          onPressed: () async {
                            setCustomState(() {
                              loading = true;
                            });

                            try {
                              var res = await _authService.logout();
                              if (res['status'] == 'ok') {
                                getX.erase();
                                getX.write(v.GETX_IS_FIRST_TIME, true);
                                localNotificationHelper
                                    .cancelAllLocalNotifications();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const Login(),
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

class BuildCompanionTrackee extends StatefulWidget {
  const BuildCompanionTrackee({super.key});

  @override
  State<BuildCompanionTrackee> createState() => _BuildCompanionTrackeeState();
}

class _BuildCompanionTrackeeState extends State<BuildCompanionTrackee> {
  final CompanionService _companionService = CompanionService();
  List<dynamic> companions = [];
  Future<dynamic>? _futureData;
  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    _futureData = _companionService.viewUserTrackees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      loadFuture();
                    });
                  },
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        } else {
          companions = snapshot.data['companions'];

          return companions.isEmpty
              ? const SizedBox()
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Companion - Trackee',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildCompanionTrackeeTile(companions[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 14.h);
                      },
                      itemCount: companions.length,
                    ),
                    Divider(color: Colors.white, thickness: 0.5.h),
                  ],
                ),
              );
        }
      },
    );
  }

  Row _buildCompanionTrackeeTile(var companionData) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ViewAsCompanion(companionData: companionData),
                ),
              );
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/companion.svg'),
                const SizedBox(width: 5),
                Text(
                  '${companionData['user_fullname']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                showDeleteTrackeeDialog(
                  context,
                  companionData['companion_id'],
                  companionData['_id'],
                );
              },
              child: Image.asset(
                "assets/delete2.png",
                fit: BoxFit.cover,
                height: 16.h,
                width: 16.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  showDeleteTrackeeDialog(
    BuildContext context,
    String companionID,
    String companionDocID,
  ) {
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
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DELETE TRACKEE',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 52.r,
                          width: 52.r,
                        ),
                      ),
                      Text(
                        "Are you sure you want to remove & permanently delete this trackee? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 35.h),
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
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  loading = true;
                                });

                                try {
                                  var res = await _companionService
                                      .deleteCompanion(
                                        companionID: companionID,
                                        companionDocID: companionDocID,
                                      );

                                  if (res['status'] == 'ok') {
                                    helperWidget.showToast(
                                      "Trackee deleted successfully",
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

class BuildCompanions extends StatefulWidget {
  const BuildCompanions({super.key});

  @override
  State<BuildCompanions> createState() => _BuildCompanionsState();
}

class _BuildCompanionsState extends State<BuildCompanions> {
  final CompanionService _companionService = CompanionService();
  List<dynamic> companions = [];
  Future<dynamic>? _futureData;
  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    _futureData = _companionService.viewUsersCompanions();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Companion',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14.h),
          getX.read(v.GETX_COMPANIONS).length == 0
              ? Column(
                children: [
                  InkWell(
                    splashColor: Colors.white.withValues(alpha: 0.3),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => AddCompanion()));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/companion.svg',
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Add a Companion',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : FutureBuilder(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                loadFuture();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox();
                  } else {
                    companions = snapshot.data['companions'];

                    return companions.isEmpty
                        ? Column(
                          children: [
                            InkWell(
                              splashColor: Colors.white.withValues(alpha: 0.3),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddCompanion(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/companion.svg',
                                    height: 16.h,
                                    width: 16.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Add a Companion',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildCompanionTile(companions[index]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 14.h);
                          },
                          itemCount: companions.length,
                        );
                  }
                },
              ),
        ],
      ),
    );
  }

  Row _buildCompanionTile(var companionData) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => ViewAsCompanion(companionData: companionData),
              //   ),
              // );
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/companion.svg'),
                const SizedBox(width: 5),
                Text(
                  '${companionData['companion_user_name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddCompanion(companionData: companionData),
                  ),
                );
              },
              child: Image.asset(
                "assets/edit2.png",
                fit: BoxFit.cover,
                height: 16.h,
                width: 16.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 18.w),
            InkWell(
              onTap: () {
                showDeleteCompanionDialog(
                  context,
                  companionData['companion_id'],
                  companionData['_id'],
                );
              },
              child: Image.asset(
                "assets/delete2.png",
                fit: BoxFit.cover,
                height: 16.h,
                width: 16.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  showDeleteCompanionDialog(
    BuildContext context,
    String companionID,
    String companionDocID,
  ) {
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
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DELETE COMPANION',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 52.r,
                          width: 52.r,
                        ),
                      ),
                      Text(
                        "Are you sure you want to remove & permanently delete this companion? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 35.h),
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
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  loading = true;
                                });

                                try {
                                  var res = await _companionService
                                      .deleteCompanion(
                                        companionID: companionID,
                                        companionDocID: companionDocID,
                                      );

                                  if (res['status'] == 'ok') {
                                    helperWidget.showToast(
                                      "Companion deleted successfully",
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

class BuildDependents extends StatefulWidget {
  const BuildDependents({super.key});

  @override
  State<BuildDependents> createState() => _BuildDependentsState();
}

class _BuildDependentsState extends State<BuildDependents> {
  final DependentService _dependentService = DependentService();
  List<dynamic> dependents = [];
  Future<dynamic>? _futureData;
  @override
  initState() {
    super.initState();
    loadFuture();
  }

  loadFuture() {
    _futureData = _dependentService.viewUsersDependents();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profiles',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14.h),
          getX.read(v.GETX_DEPENDENTS).length == 0
              ? Column(
                children: [
                  InkWell(
                    splashColor: Colors.white.withValues(alpha: 0.3),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => AddDependent()));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/dependent.svg',
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Add a Dependent',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : FutureBuilder(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                loadFuture();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox();
                  } else {
                    dependents = snapshot.data['dependents'];

                    my_log(snapshot.data);

                    return dependents.isEmpty
                        ? InkWell(
                          splashColor: Colors.white.withValues(alpha: 0.3),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AddDependent()),
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/dependent.svg',
                                height: 16.h,
                                width: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Add a Dependent',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildDependentTile(dependents[index]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 14.h);
                          },
                          itemCount: dependents.length,
                        );
                  }
                },
              ),
        ],
      ),
    );
  }

  Row _buildDependentTile(var dependentData) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => ViewYourDependent(dependentData: dependentData),
                ),
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/dependent.svg',
                  height: 16.h,
                  width: 16.w,
                ),
                const SizedBox(width: 5),
                Text(
                  '${dependentData['first_name']} ${dependentData['last_name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddDependent(dependentData: dependentData),
                  ),
                );
              },
              child: Image.asset(
                "assets/edit2.png",
                fit: BoxFit.cover,
                height: 16.h,
                width: 16.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 18.w),
            InkWell(
              onTap: () {
                showDeleteDependentDialog(context, dependentData['_id']);
              },
              child: Image.asset(
                "assets/delete2.png",
                fit: BoxFit.cover,
                height: 16.h,
                width: 16.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  showDeleteDependentDialog(BuildContext context, String dependentID) {
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
                        'DELETE DEPENDENT',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Image.asset(
                          "./assets/smiley_delete.png",
                          height: 52.r,
                          width: 52.r,
                        ),
                      ),
                      Text(
                        "Are you sure you want to remove & permanently delete this dependent?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 35.h),
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
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              onPressed: () async {
                                setCustomState(() {
                                  loading = true;
                                });

                                try {
                                  var res = await _dependentService
                                      .deleteDependent(
                                        dependentID: dependentID,
                                      );
                                  if (res['status'] == 'ok') {
                                    helperWidget.showToast(
                                      "Dependent account's deleted successfully",
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
