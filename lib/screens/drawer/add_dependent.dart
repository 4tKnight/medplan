import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import '../../api/dependent_service.dart';
import '../bottom_control/bottom_nav_bar.dart';

class AddDependent extends StatefulWidget {
  dynamic dependentData;
  AddDependent({super.key, this.dependentData});

  @override
  State<AddDependent> createState() => _AddDependentState();
}

class _AddDependentState extends State<AddDependent> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String? relationship;
  String? gender;
  String? birthDate;
  File? pickedImage;

  String dependentImgUrl = '';

  @override
  initState() {
    super.initState();
    if (widget.dependentData != null) {
      my_log(widget.dependentData);
      firstNameController.text = widget.dependentData['first_name'];
      lastNameController.text = widget.dependentData['last_name'];
      relationship = widget.dependentData['relationship'];
      gender = capitalizeFirstLetter(widget.dependentData['gender']);
      birthDate = widget.dependentData['date_of_birth'];
      dependentImgUrl = widget.dependentData['img_url'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        widget.dependentData == null ? 'Add Dependent' : 'Edit Dependent',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        children: [
          Text(
            'Manage Family members medications in one app',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
          SizedBox(height: 38.h),
          Stack(
            children: [
              dependentImgUrl.isNotEmpty
                  ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: helperWidget.cachedImage(
                        url: dependentImgUrl,
                        height: 152.h,
                        width: 152.w,
                      ),
                    ),
                  )
                  : pickedImage == null
                  ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.asset(
                        "assets/no_image_d.png",
                        fit: BoxFit.cover,
                        height: 152.h,
                        width: 152.w,
                      ),
                    ),
                  )
                  : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.file(
                        pickedImage!,
                        fit: BoxFit.cover,
                        height: 150.h,
                        width: 150.w,
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
                    child: Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 54.h),
          TextField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'First Name',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              isDense: true,
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
          SizedBox(height: 30.h),
          TextField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Last Name',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
              isDense: true,
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
          SizedBox(height: 30.h),
          DropdownButtonFormField<String>(
            value: relationship,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            hint: Text(
              'Relationship',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 16.sp,
              ),
            ),
            decoration: InputDecoration(
              isDense: true,
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
                [
                  'Sibling',
                  'Uncle',
                  'Aunt',
                  'Grandparent',
                  'Child',
                  'Other',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              relationship = newValue;
            },
          ),
          SizedBox(height: 30.h),
          DropdownButtonFormField<String>(
            value: gender,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            hint: Text(
              'Gender',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 16.sp,
              ),
            ),
            decoration: InputDecoration(
              isDense: true,
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
                        fontSize: 16.sp,
                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              gender = newValue;
            },
          ),
          SizedBox(height: 30.h),
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
          SizedBox(height: 50.h),
          Text.rich(
            TextSpan(
              text: 'By clicking the “',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.black.withValues(alpha: 0.7),
              ),
              children: [
                TextSpan(
                  text: 'Add Profile',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text:
                      '” button you confirm that you have received the consent of the dependent (when applicable) to the association of the dependent\'s personal information with their health information and confirm that you have read and agreed to our ',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: 'terms and privacy policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black.withValues(alpha: 0.7),
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 61.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (firstNameController.text.isEmpty) {
                  helperWidget.showToast("First name is required");
                  return;
                }
                if (lastNameController.text.isEmpty) {
                  helperWidget.showToast("Last name is required");
                  return;
                }
                if (relationship == null) {
                  helperWidget.showToast("Gender is required");
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
                _addDependentEndpoint();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 60.w),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        widget.dependentData == null
                            ? 'Add Profile'
                            : 'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  final DependentService _dependentService = DependentService();

  bool isLoading = false;
  _addDependentEndpoint() async {
    setState(() {
      isLoading = true;
    });

    try {
      var formData = dio.FormData.fromMap({
        //
        "token": getX.read(v.TOKEN),
        'dependent_id':
            widget.dependentData == null ? '' : widget.dependentData['_id'],
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'relationship': relationship,
        'gender': gender!.toLowerCase(),
        'date_of_birth': birthDate,
      });
      if (pickedImage != null) {
        var file = await dio.MultipartFile.fromFile(
          pickedImage!.path,
          contentType: MediaType("image", "jpeg"),
        );
        formData.files.add(MapEntry('image', file));
      }

      var res =
          widget.dependentData == null
              ? await _dependentService.addDependent(formData)
              : await _dependentService.editDependent(formData);
      if (res['message'] == 'Dependent added successfully' ||
          res['message'] == 'success') {
        if (widget.dependentData == null) {
          helperWidget.showToast('Dependent added successfully');
        } else {
          helperWidget.showToast('Dependent edited successfully');
        }
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
