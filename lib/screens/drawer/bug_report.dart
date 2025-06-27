import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../../api/bug_report_service.dart';

class BugReport extends StatefulWidget {
  const BugReport({super.key});

  @override
  State<BugReport> createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  TextEditingController nameController = TextEditingController(
    text: getX.read(v.GETX_USERNAME),
  );
  TextEditingController emailController = TextEditingController(
    text: getX.read(v.GETX_EMAIL),
  );
  TextEditingController bugTitleController = TextEditingController();
  TextEditingController bugDetailsController = TextEditingController();

  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Report a Bug', isBack: true),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Name',
              isDense: true,
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
          SizedBox(height: 30.h),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Email',
              isDense: true,
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
          SizedBox(height: 30.h),
          TextField(
            keyboardType: TextInputType.text,
            controller: bugTitleController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Bug Title',
              isDense: true,
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
          SizedBox(height: 30.h),
          Text(
            'Please type details of the bug experienced.',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
          SizedBox(height: 9.h),
          TextField(
            controller: bugDetailsController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 10,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(236, 236, 236, 1),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            '(Optional)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          ),
          SizedBox(height: 5.h),
          pickedImage == null
              ? Align(
                alignment: Alignment.centerLeft,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Screenshot',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Image.asset(
                          "assets/no_image.png",
                          fit: BoxFit.cover,
                          height: 20.h,
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : InkWell(
                onTap: () {
                  setState(() {
                    pickedImage = null;
                  });
                },
                child: Image.file(pickedImage!, fit: BoxFit.cover),
              ),
          SizedBox(height: 79.h),
          Center(
            child: ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (nameController.text.isEmpty) {
                          helperWidget.showToast("Name is required.");
                          return;
                        }
                        if (bugTitleController.text.isEmpty) {
                          helperWidget.showToast("Bug title is required.");
                          return;
                        }
                        if (bugDetailsController.text.isEmpty) {
                          helperWidget.showToast("Bug details is required.");
                          return;
                        }
                        submitReport();
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
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Submit Report',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  bool isLoading = false;

  final BugReportService _bugReportService = BugReportService();

  void submitReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      var formData = dio.FormData.fromMap({
        "token": getX.read(v.TOKEN),
        'email': emailController.text.trim(),
        'username': nameController.text.trim(),
        'report': bugDetailsController.text,
        'bug_title': bugTitleController.text,
      });
      if (pickedImage != null) {
        var file = await dio.MultipartFile.fromFile(
          pickedImage!.path,
          contentType: MediaType("image", "jpeg"),
        );
        formData.files.add(MapEntry('image', file));
      }

      var res = await _bugReportService.createBugReport(formData);
      print(res);
      if (res['status'] == 'ok') {
        helperWidget.showToast("Bug reported successfully");
        setState(() {
          bugTitleController.clear();
          bugDetailsController.clear();
          pickedImage = null;
        });
      } else {
        helperWidget.showToast("Oops! Something went wrong.");
      }
    } catch (e) {
      print(e);
      if (e is dio.DioException) {
        print("${e.response}");
      }
      helperWidget.showToast("Oops! Something went wrong.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
