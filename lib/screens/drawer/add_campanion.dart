import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/screens/bottom_control/bottom_nav_bar.dart';
import 'package:medplan/utils/global.dart';

import '../../api/companion_service.dart';
import '../../utils/functions.dart';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

class AddCompanion extends StatefulWidget {
  dynamic companionData;
  AddCompanion({super.key, this.companionData});

  @override
  State<AddCompanion> createState() => _AddCompanionState();
}

class _AddCompanionState extends State<AddCompanion> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _activeLineController = TextEditingController();
  String? _relationship;
  @override
  initState() {
    super.initState();
    fetchAllUsers();
    if (widget.companionData != null) {
      _nameController.text = widget.companionData['first_name'];
      _phoneNoController.text = widget.companionData['phone_no'];
      _activeLineController.text = widget.companionData['active_call_line'];
      _relationship = widget.companionData['relationship'];
      selectedUser = {'username': '', '_id': '', 'email': ''};
      selectedUser['email'] = widget.companionData['email'];
      selectedUser['username'] = widget.companionData['companion_user_name'];
      selectedUser['_id'] = widget.companionData['companion_id'];
    }
  }

  List<dynamic> users = [];
  var selectedUser;
  final CompanionService _companionService = CompanionService();

  fetchAllUsers() async {
    try {
      var res = await _companionService.viewAllUsers();
      if (res['status'] == 'ok') {
        setState(() {
          users = res['users'] ?? [];
        });
      }
    } catch (e) {
      helperWidget.showToast('oOps an error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Add Companion', isBack: true),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset(
            "assets/companion_image.png",
            fit: BoxFit.cover,
            height: 242.h,
            // width: 0,
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'A MedPlan companion is any ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: 'family member',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' or ',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: 'care giver',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text:
                            ' chosen by you that helps you remember to take your medications in case you forget.',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35.h),
                Autocomplete<String>(
                  initialValue: TextEditingValue(
                    text: selectedUser != null ? selectedUser['email'] : '',
                  ),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return users
                        .where(
                          (user) => user['email'].toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        )
                        .map((user) => user['email']);
                  },
                  onSelected: (String selection) {
                    selectedUser = users.firstWhere(
                      (user) => user['email'] == selection,
                    );
                    setState(() {});
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(top: 16),
                        hintText: 'Search companion’s email',
                        hintStyle: TextStyle(
                          color: Colors.black.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: const Icon(Icons.arrow_forward_ios),
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
                    );
                  },
                ),
                SizedBox(height: 5.h),

                Text(
                  selectedUser == null
                      ? 'Username: John Doe'
                      : 'Username: ${selectedUser['username']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: secondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Enter Companions Full name',
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
                SizedBox(height: 28.h),
                TextField(
                  controller: _phoneNoController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Companion’s Phone number',
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
                SizedBox(height: 28.h),
                DropdownButtonFormField<String>(
                  value: _relationship,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 16.sp,
                  ),
                  hint: Text(
                    'Relationship with Companion',
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
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  items:
                      [
                        'Sibling',
                        'Uncle',
                        'Aunt',
                        'Grandparent',
                        'Child',
                        'Care Giver',
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
                    _relationship = newValue;
                  },
                ),

                SizedBox(height: 42.h),
                Text(
                  'Your Active Call line',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                TextField(
                  controller: _activeLineController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText:
                        'Enter your phone number to be called by your companion',
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
                SizedBox(height: 32.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color:
                              isChecked
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'I consent to share my medications with my MedPlan Companion.',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 31.h),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (isChecked == false) {
                                helperWidget.showToast(
                                  'You can only proceed if you consent to sharing your medications with this companion',
                                );
                                return;
                              }
                              if (selectedUser['username'] == null) {
                                helperWidget.showToast(
                                  'Select companion\'s username',
                                );
                                return;
                              }
                              if (_nameController.text.isEmpty) {
                                helperWidget.showToast(
                                  'Enter companion\'s fullname',
                                );
                                return;
                              }
                              if (_phoneNoController.text.isEmpty) {
                                helperWidget.showToast(
                                  'Enter companion\'s phone number',
                                );
                                return;
                              }
                              // if (_emailController.text.isEmpty) {
                              //   helperWidget.showToast(
                              //     'Enter companion\'s email',
                              //   );
                              //   return;
                              // }
                              if (_activeLineController.text.isEmpty) {
                                helperWidget.showToast(
                                  'Enter your active call line',
                                );
                                return;
                              }
                              companionEndpoint();
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isChecked
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
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
                              widget.companionData == null
                                  ? 'Add Companion'
                                  : 'Edit Companion',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isChecked = false;
  bool isLoading = false;

  void companionEndpoint() async {
    setState(() {
      isLoading = true;
    });
    try {
      // token, companion_id, fullname, phone_no, relationship, companion_user_name, active_call_line, user_fullname
      var data = {
        "token": getX.read(v.TOKEN),
        'companion_id': selectedUser['_id'],
        'companion_user_name': selectedUser['username'],
        'companion_doc_id':
            widget.companionData == null ? '' : widget.companionData['_id'],
        'fullname': _nameController.text.trim(),
        'user_fullname': getX.read(v.GETX_USERNAME),
        'phone_no': _phoneNoController.text.trim(),
        'relationship': _relationship,
        'email': selectedUser['email'],
        'active_call_line': _activeLineController.text.trim(),
      };

      var res =
          widget.companionData == null
              ? await _companionService.addCompanion(data)
              : await _companionService.editCompanion(data);
      my_log(res);
      if (res['message'] == 'success') {
        if (widget.companionData == null) {
          helperWidget.showToast('Companion added successfully');
        } else {
          helperWidget.showToast('Companion details edited successfully');
        }
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavBar()),
          (route) => false,
        );
        showCompanionRequestSentDialog();
      } else {
        helperWidget.showToast("Oops! Something went wrong.");
      }
    } catch (e) {
      print(e);
      helperWidget.showToast("Oops! Something went wrong.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  showCompanionRequestSentDialog() {
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
                height: 250,
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'COMPANION REQUEST SENT',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 23.h),
                      Text.rich(
                        TextSpan(
                          text: 'Your Companion request has been sent to ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: '@${selectedUser['username'] ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: ' (',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,

                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: '${selectedUser["email"] ?? ''}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: secondaryColor,

                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: ')',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,

                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),
                      Text(
                        'They will need to accept the request before they can start reminding you to take your medications.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),

                      SizedBox(height: 26.h),

                      ElevatedButton(
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
                          'Okay',
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
