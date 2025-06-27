import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';

import '../../../api/health_diary_service.dart';
import '../../bottom_control/bottom_nav_bar.dart';
import 'my_health_diary.dart';

class CreateDiary extends StatefulWidget {
  dynamic diaryData;
  CreateDiary({super.key, this.diaryData});

  @override
  CreateDiaryState createState() => CreateDiaryState();
}

class CreateDiaryState extends State<CreateDiary> {
  @override
  void initState() {
    super.initState();

    if (widget.diaryData != null) {
      setValueForEdit();
    }
  }

  setValueForEdit() {
    selectedMood = widget.diaryData['mood'];
    selected_symptoms =
        widget.diaryData['symptom'].whereType<String>().toList();
    for (var item in selected_symptoms) {
      if (item == constants.symptoms[0]) {
        hasHeadache = true;
      } else if (item == constants.symptoms[1]) {
        hasNauseaVomiting = true;
      } else if (item == constants.symptoms[2]) {
        hasFever = true;
      } else if (item == constants.symptoms[3]) {
        hasConstipation = true;
      } else if (item == constants.symptoms[4]) {
        hasBodyPain = true;
      } else if (item == constants.symptoms[5]) {
        hasDiarrhoea = true;
      } else if (item == constants.symptoms[6]) {
        hasItchness = true;
      } else if (item == constants.symptoms[7]) {
        hasAbdominalPain = true;
      } else if (item == constants.symptoms[8]) {
        hasRashes = true;
      } else if (item == constants.symptoms[9]) {
        isBleeding = true;
      }
    }
    addController.text = widget.diaryData['note'];

    setState(() {});
  }

  bool hasHeadache = false;
  bool hasFever = false;
  bool hasBodyPain = false;
  bool hasItchness = false;
  bool hasRashes = false;

  bool hasNauseaVomiting = false;
  bool hasConstipation = false;
  bool hasDiarrhoea = false;
  bool hasAbdominalPain = false;
  bool isBleeding = false;

  List<String> selected_symptoms = [];

  bool isLoading = false;

  String selectedMood = constants.smileys_text[0];
  String selectedSymptoms = constants.smileys_text[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "How are you feeling today"),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 13.h, 16.w, 60.h),
        children: [
          Text(
            'How are you feeling today?',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
          SizedBox(height: 13.h),
          Container(
            color: Theme.of(context).cardColor,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 0),
              shrinkWrap: true,
              itemCount: constants.smileys.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.6 / 0.7,
                // childAspectRatio: 0.65/0.8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedMood = constants.smileys_text[index];
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 64.h,
                            width: 67.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color.fromRGBO(232, 240, 255, 1),
                            ),
                            child: Center(
                              child: Image.asset(
                                "./assets/${constants.smileys[index]}",
                                height: 35.h,
                                width: 35.w,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Radio(
                              activeColor:
                                  primaryColor, //MaterialStateProperty.all<Color?>(Color.fromRGBO( 31, 170, 8,1)),
                              value: constants.smileys_text[index],
                              groupValue: selectedMood,
                              onChanged: (value) {
                                // print(value);
                                selectedMood = value.toString();

                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        constants.smileys_text[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Have any of the following Signs or Symptoms?',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          ),
          SizedBox(height: 17.h),
          GridView(
            // itemCount: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 14.0,
              childAspectRatio: 2 / 0.3,
            ),
            children: [
              buildSymptomsTile(constants.symptoms[0], hasHeadache, (value) {
                setState(() {
                  hasHeadache = value!;
                });

                // print("hasHeadache: $hasHeadache");
              }),
              buildSymptomsTile(constants.symptoms[1], hasNauseaVomiting, (
                value,
              ) {
                setState(() {
                  hasNauseaVomiting = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[2], hasFever, (value) {
                setState(() {
                  hasFever = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[3], hasConstipation, (
                value,
              ) {
                setState(() {
                  hasConstipation = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[4], hasBodyPain, (value) {
                setState(() {
                  hasBodyPain = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[5], hasDiarrhoea, (value) {
                setState(() {
                  hasDiarrhoea = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[6], hasItchness, (value) {
                setState(() {
                  hasItchness = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[7], hasAbdominalPain, (
                value,
              ) {
                setState(() {
                  hasAbdominalPain = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[8], hasRashes, (value) {
                setState(() {
                  hasRashes = value!;
                });
              }),
              buildSymptomsTile(constants.symptoms[9], isBleeding, (value) {
                setState(() {
                  isBleeding = value!;
                });
              }),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  "Would you like to take additional notes?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              TextField(
                maxLines: 5,
                controller: addController,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Color.fromRGBO(218, 218, 218, 0.4),
                  filled: true,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: "Type note here",
                  labelStyle: TextStyle(color: Colors.black45, fontSize: 14.sp),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                textInputAction: TextInputAction.next,
                // enabled: otherReasonSelected,
              ),
            ],
          ),
          SizedBox(height: 21.h),
          Center(
            child:
                isLoading
                    ? helperWidget.buildLoadingButton()
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 40.w,
                        ),
                      ),
                      onPressed: () {
                        _saveNote();
                      },
                      child: Text(
                        widget.diaryData == null
                            ? 'Save to Health Diary'
                            : 'Edit Health Diary',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  TextEditingController addController = TextEditingController();

  buildSymptomsTile(String text, bool value, Function(bool?) function) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24.r,
          width: 24.r,
          child: Checkbox(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            onChanged: function,
            fillColor: WidgetStateProperty.all(Colors.grey[300]),
            checkColor: primaryColor,
            value: value,
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              bool nValue;

              if (value == true) {
                nValue = false;
              } else {
                nValue = true;
              }

              if (text == constants.symptoms[0]) {
                hasHeadache = nValue;
                // print("value1: $hasHeadache");
              } else if (text == constants.symptoms[1]) {
                hasNauseaVomiting = nValue;
              } else if (text == constants.symptoms[2]) {
                hasFever = nValue;
              } else if (text == constants.symptoms[3]) {
                hasConstipation = nValue;
              } else if (text == constants.symptoms[4]) {
                hasBodyPain = nValue;
              } else if (text == constants.symptoms[5]) {
                hasDiarrhoea = nValue;
              } else if (text == constants.symptoms[6]) {
                hasItchness = nValue;
              } else if (text == constants.symptoms[7]) {
                hasAbdominalPain = nValue;
              } else if (text == constants.symptoms[8]) {
                hasRashes = nValue;
              } else if (text == constants.symptoms[9]) {
                isBleeding = nValue;
              }
              setState(() {});
            },
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
      ],
    );
  }

  final HealthDiaryService _healthDiaryService = HealthDiaryService();

  void _saveNote() async {
    FocusScope.of(context).requestFocus(FocusNode());

    selected_symptoms
        .clear(); //incase for one reason or the other the operation did not work well at first, so it can clear the list first, to avoid duplicate entries
    if (hasHeadache == true) {
      selected_symptoms.add(constants.symptoms[0]);
    }
    if (hasNauseaVomiting == true) {
      selected_symptoms.add(constants.symptoms[1]);
    }
    if (hasFever == true) {
      selected_symptoms.add(constants.symptoms[2]);
    }
    if (hasConstipation == true) {
      selected_symptoms.add(constants.symptoms[3]);
    }
    if (hasBodyPain == true) {
      selected_symptoms.add(constants.symptoms[4]);
    }
    if (hasDiarrhoea == true) {
      selected_symptoms.add(constants.symptoms[5]);
    }
    if (hasItchness == true) {
      selected_symptoms.add(constants.symptoms[6]);
    }
    if (hasAbdominalPain == true) {
      selected_symptoms.add(constants.symptoms[7]);
    }
    if (hasRashes == true) {
      selected_symptoms.add(constants.symptoms[8]);
    }
    if (isBleeding == true) {
      selected_symptoms.add(constants.symptoms[9]);
    }

    if (addController.text.isEmpty) {
      helperWidget.showSnackbar(context, "Please add a note");
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      var res =
          widget.diaryData == null
              ? await _healthDiaryService.addHealthDiary(
                note: addController.text,
                mood: selectedMood,
                symptom: selected_symptoms,
              )
              : await _healthDiaryService.editHealthDiary(
                healthDiaryId: widget.diaryData['_id'],
                note: addController.text,
                mood: selectedMood,
                symptom: selected_symptoms,
              );
      if (res["status"] == "ok") {
        double coinAmount = 1;
        await increaseMedplanCoin(coinAmount);

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavBar()),
          (route) => false,
        );

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MyHealthDiary()));

        helperWidget.showToast(
          widget.diaryData == null
              ? "Your information is now safe and secure in your health diary."
              : "Note edited successfully",
        );
      } else {
        helperWidget.showToast("oOps something went wrong");
      }
    } catch (e) {
      print(e);
      if (e is SocketException) {
        print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
        helperWidget.showToast("Check your internet connection & try again");
      } else {
        helperWidget.showToast("A server error occured");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
