import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../../api/profile_service.dart';
import '../auth/auth_login_signup.dart';
import '../bottom_control/bottom_nav_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController(
    text: getX.read(v.GETX_USERNAME),
  );
  TextEditingController emailController = TextEditingController(
    text: getX.read(v.GETX_EMAIL),
  );

  String? genotype =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['genotype'] == ''
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['genotype'];
  String? bloodGroup =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['blood_group'] == ''
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['blood_group'];
  int? weight =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['weight'] == 0
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['weight'];
  double? height =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['height'] == 0.0
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['height'];
  String? gender =
      getX.read(v.GETX_GENDER) == '' ? null : getX.read(v.GETX_GENDER);
  String? birthDate =
      getX.read(v.GETX_DAY_OF_BIRTH) == ''
          ? null
          : getX.read(v.GETX_DAY_OF_BIRTH);
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Edit Profile', isBack: true),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
        children: [
          // Center(
          //   child: SizedBox(
          //     width: 80,
          //     child: myWidgets.buildCoinWidget(context),
          //   ),
          // ),
          // const SizedBox(height: 25),
          Stack(
            children: [
              pickedImage == null
                  ? getX.read(v.GETX_USER_IMAGE) == ''
                      ? Center(child: myWidgets.noProfileImage(125.h))
                      : Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: helperWidget.cachedImage(
                            url: '${getX.read(v.GETX_USER_IMAGE)}',
                            height: 125.h,
                            width: 125.w,
                          ),
                        ),
                      )
                  : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.file(
                        pickedImage!,
                        fit: BoxFit.cover,
                        height: 125.h,
                        width: 125.w,
                      ),
                    ),
                  ),
              Positioned(
                bottom: 0,
                right: MediaQuery.of(context).size.width / 2 - 70,
                child: InkWell(
                  onTap: () async {
                    var tempImage = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (tempImage != null) {
                      setState(() {
                        pickedImage = File(tempImage.path);
                      });
                    }
                  },
                  child: Container(
                    height: 24.h,
                    width: 24.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/coin.png",
                fit: BoxFit.cover,
                height: 19.h,
                width: 20.w,
              ),
              SizedBox(width: 5.w),
              Text(
                'Coin Balance:',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '${getX.read(v.GETX_MEDPLAN_COINS) ?? 0}',

                style: TextStyle(
                  color: Theme.of(context).primaryColor,

                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/warning.png",
                fit: BoxFit.cover,
                height: 18.r,
                width: 18.r,
              ),
              SizedBox(width: 5.w),
              Text(
                'BMI:',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                (weight == null || height == null)
                    ? 'Nil'
                    : "${calculateBMI(weight!, height!)}",
                // : '${getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['bmi']}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,

                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 33.h),
          Text(
            'Personal Information',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
          SizedBox(height: 18.h),

          TextField(
            controller: usernameController,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Username',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          TextField(
            controller: emailController,
            readOnly: true,
            keyboardType: TextInputType.emailAddress,

            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Email',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          DropdownButtonFormField<String>(
            value: gender,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Gender',

              // hintStyle: TextStyle(
              //   color: Colors.black.withValues(alpha: 0.7),
              //   fontSize: 14.sp,
              // ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items:
                ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 15.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              gender = newValue;
            },
          ),
          SizedBox(height: 20.h),

          GestureDetector(
            onTap: () async {
              DateTime initialDate = DateTime.now();
              DateTime firstDate = DateTime(1900);
              DateTime lastDate = DateTime.now();
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate:
                    birthDate != null
                        ? DateTime.parse(birthDate!)
                        : initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
              );
              if (picked != null) {
                setState(() {
                  birthDate =
                      "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Birth date',
                  hintStyle: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 16.sp,
                  ),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                controller: TextEditingController(text: birthDate ?? ''),
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 43.h),
          Text(
            'Personal Health Data',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
          SizedBox(height: 18.h),
          DropdownButtonFormField<String>(
            value: genotype,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Genotype',

              // hintStyle: TextStyle(
              //   color: Colors.black.withValues(alpha: 0.7),
              //   fontSize: 14.sp,
              // ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items:
                constants.genotypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              genotype = newValue;
            },
          ),
          SizedBox(height: 20.h),
          DropdownButtonFormField<String>(
            value: bloodGroup,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Blood Group',

              // hintStyle: TextStyle(
              //   color: Colors.black.withValues(alpha: 0.7),
              //   fontSize: 14.sp,
              // ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items:
                constants.bloodGroups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              bloodGroup = newValue;
            },
          ),
          SizedBox(height: 20.h),
          DropdownButtonFormField<int>(
            value: weight,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Weight (Kg)',

              // hintStyle: TextStyle(
              //   color: Colors.black.withValues(alpha: 0.7),
              //   fontSize: 14.sp,
              // ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items:
                constants.weights.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      "$value",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                weight = newValue;
              });
            },
          ),
          SizedBox(height: 20.h),
          DropdownButtonFormField<double>(
            value: height,

            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              isDense: true,

              hintText: 'Height (m)',

              // hintStyle: TextStyle(
              //   color: Colors.black.withValues(alpha: 0.7),
              //   fontSize: 14.sp,
              // ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items:
                constants.heights.map<DropdownMenuItem<double>>((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(
                      "$value",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (double? newValue) {
              setState(() {
                height = newValue!;
              });
            },
          ),
          SizedBox(height: 47.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (usernameController.text.isEmpty) {
                  helperWidget.showToast("Username is required");
                  return;
                }
                if (gender == null) {
                  helperWidget.showToast("Gender is required");
                  return;
                }
                if (birthDate == null) {
                  helperWidget.showToast("Birth date is required");
                  return;
                }
                if (genotype == null || genotype == "") {
                  helperWidget.showToast("Genotype is required");
                  return;
                }
                if (bloodGroup == null || bloodGroup == "") {
                  helperWidget.showToast("Blood group is required");
                  return;
                }
                if (weight == null || weight == 0) {
                  helperWidget.showToast("Weight is required");
                  return;
                }
                if (height == null || height == 0) {
                  helperWidget.showToast("Height is required");
                  return;
                }

                _editProfileEndpoint();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Save & Update',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
          SizedBox(height: 28.h),
          if (getX.read(v.GETX_IS_LOGGED_IN) == null)
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Why risk losing your data?\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up/Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const Login(),
                                ),
                                (route) => false,
                              );
                            },
                    ),
                    TextSpan(
                      text: ' to sync your data and keep it safe.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  final ProfileService _profileService = ProfileService();

  bool isLoading = false;
  _editProfileEndpoint() async {
    setState(() {
      isLoading = true;
    });

    try {
      var formData = dio.FormData.fromMap({
        "token": getX.read(v.TOKEN),
        'email': emailController.text.trim(),
        'username': usernameController.text.trim(),
        'gender': gender,
        'date_of_birth': birthDate,
        "weight": weight,
        "height": height,
        "genotype": genotype,
        "blood_group": bloodGroup,
      });
      if (pickedImage != null) {
        var file = await dio.MultipartFile.fromFile(
          pickedImage!.path,
          contentType: MediaType("image", "jpeg"),
        );
        formData.files.add(MapEntry('image', file));
      }

      var res = await _profileService.editProfile(formData);
      if (res['status'] == 'ok') {
        helperWidget.showToast('Profile edited successfully');
        set_getX_data(context, res);

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavBar()),
          (route) => false,
        );
      } else {
        helperWidget.showToast("Oops! Something went wrong.");
      }
    } catch (e) {
      print(e);
      helperWidget.showToast("oOps something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
