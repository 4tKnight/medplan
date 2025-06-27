import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/medplan_story_service.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../../api/bug_report_service.dart';

class ShareMedplanStory extends StatefulWidget {
  const ShareMedplanStory({super.key});

  @override
  State<ShareMedplanStory> createState() => _ShareMedplanStoryState();
}

class _ShareMedplanStoryState extends State<ShareMedplanStory> {
  TextEditingController storyTitleController = TextEditingController();
  TextEditingController storyDetailsController = TextEditingController();

  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Share your MedPlan Story',
        isBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        children: [
          Image.asset(
            "assets/medplan_story.png",
            fit: BoxFit.cover,
            height: 242.h,
            width: double.maxFinite,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${getX.read(v.GETX_USERNAME)}, we would like to know how MedPlan has impacted your health journey',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 35.h),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: storyTitleController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Please enter Story Title',
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
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 23.h),
                Text(
                  'Please type details of your experience',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 9.h),
                TextField(
                  controller: storyDetailsController,
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
                SizedBox(height: 42.h),
                Text(
                  '(Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
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
                                'Add Image',
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
                SizedBox(height: 38.h),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              if (storyTitleController.text.isEmpty) {
                                helperWidget.showToast(
                                  "Story title is required.",
                                );
                                return;
                              }
                              if (storyDetailsController.text.isEmpty) {
                                helperWidget.showToast(
                                  "Story details is required.",
                                );
                                return;
                              }
                              submitStory();
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 13.h,
                        horizontal: 60.w,
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              'Submit Story',
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
          ),
        ],
      ),
    );
  }

  bool isLoading = false;

  final MedplanStoryService _medplanStoryService = MedplanStoryService();

  void submitStory() async {
    setState(() {
      isLoading = true;
    });

    try {
      var formData = dio.FormData.fromMap({
        "token": getX.read(v.TOKEN),
        'story': storyDetailsController.text,
        'title': storyTitleController.text,
      });

      if (pickedImage != null) {
        var file = await dio.MultipartFile.fromFile(
          pickedImage!.path,
          contentType: MediaType("image", "jpeg"),
        );
        formData.files.add(MapEntry('image', file));
      }

      var res = await _medplanStoryService.createMedplanStory(formData);
      print(res);
      if (res['status'] == 'ok') {
        helperWidget.showToast("Medplan story submitted successfully");
        setState(() {
          storyTitleController.clear();
          storyDetailsController.clear();
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
