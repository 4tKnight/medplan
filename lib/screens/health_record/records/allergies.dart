import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class Allergies extends StatefulWidget {
  var dependentData;

  Allergies({super.key, this.dependentData});

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {
  @override
  initState() {
    super.initState();
    if (widget.dependentData == null) {
      allergies = getX.read(v.GETX_ALLERGIES) ?? [];
    } else {
      allergies = widget.dependentData['allergies'] ?? [];
    }
  }

  List<dynamic> allergies = [];
  String name = 'Allergies';
  String language = 'English';
  String content =
      "An allergy is an immune system reaction to a substance that is usually harmless to most people. These substances are called allergens and can be found in dust, mold, pollen, pets, insects, ticks, foods, and drugs. \nWhen someone with allergies comes into contact with an allergen, their immune system overreacts by releasing chemicals like histamines, leukotrienes, and prostaglandins. This can cause a range of symptoms, including:\nItchy, watery eyes, Runny nose, Sneezing, Coughing, Itchy skin, Hives, Stomach cramps, Vomiting, Diarrhea, and Wheezing. \nThe severity of an allergic reaction can vary from person to person and can range from minor irritation to a life-threatening emergency called anaphylaxis.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, name),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        children: [
          myWidgets.buildChangeLanguageWidget(content, language, (language) {
            setState(() {
              this.language = language;
            });
          }),
          SizedBox(height: 10.h),
          buildRecordDescriptionArea(),
          SizedBox(height: 14.h),
          healthRecordWidgets.buildRecordValueAreaV2(
            title: name,
            image: 'allergies',
            addButton: buildAddButton(),
            fieldName: 'allergy_name',
            dataList: allergies,
            removeFunc: _removeAllergy,
          ),
          SizedBox(height: 55.h),
        ],
      ),
    );
  }

  CustomExpandableWidget buildRecordDescriptionArea() {
    return CustomExpandableWidget(
      'What is Allergy?',

      Text.rich(
        TextSpan(
          text: content,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            // TextSpan(
            //   text: "99 mg/dL",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14.sp,
            //   ),
            // ),
            // TextSpan(
            //   text: " or slightly lower. 100–125 mg/dL typically indicates prediabetes. 126 mg/dL or above indicates high blood sugar, the main sign of diabetes.",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     fontSize: 14.sp,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  InkWell buildAddButton() {
    return InkWell(
      onTap: () {
        buildAddBottomSheet();
      },
      child: Container(
        height: 24.r,
        width: 24.r,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 15),
        ),
      ),
    );
  }

  void _removeAllergy(int index) async {
    List<dynamic> tempAllergies = List.from(allergies);
    try {
      setState(() {
        allergies.removeAt(index);
      });
      var res = await _healthRecordServices.updateAllergies(
        allergies: allergies,
        dependentId: widget.dependentData['_id'] ?? '',
      );
      my_log(res);
      if (res['status'] == 'ok') {
        if (widget.dependentData == null) {
          getX.write(v.GETX_ALLERGIES, allergies);
        }
        helperWidget.showToast("Record updated successfully");
      } else {
        setState(() {
          allergies = tempAllergies;
        });
        helperWidget.showToast("Failed to update record");
      }
    } catch (e) {
      my_log(e);
      setState(() {
        allergies = tempAllergies;
      });

      helperWidget.showToast("Failed to update record");
    }
  }

  TextEditingController recordValueController = TextEditingController();
  final HealthRecordServices _healthRecordServices = HealthRecordServices();
  Future<dynamic> buildAddBottomSheet() {
    bool isLoading = false;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Allergy',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          time.dateFromTimestamp(
                            DateTime.now().millisecondsSinceEpoch,
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      // height: 42.h,
                      child: TextField(
                        controller: recordValueController,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          isDense: true,

                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              width: 1.h,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.r),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 42.h),
                    Center(
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());

                                  if (recordValueController.text.isEmpty) {
                                    helperWidget.showToast(
                                      "Please enter allergy name",
                                    );
                                    return;
                                  }
                                  setCustomState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    var recordData = {
                                      'timestamp':
                                          DateTime.now().millisecondsSinceEpoch,
                                      'allergy_name':
                                          recordValueController.text,
                                    };
                                    List<dynamic> tempAllergies = List.from(
                                      allergies,
                                    );
                                    tempAllergies.add(recordData);
                                    var res = await _healthRecordServices
                                        .updateAllergies(
                                          allergies: tempAllergies,
                                          dependentId:
                                              widget.dependentData['_id'] ??
                                              '',
                                        );

                                    my_log(res);
                                    if (res['status'] == 'ok') {
                                      allergies.add(recordData);
                                      if (widget.dependentData == null) {
                                        getX.write(v.GETX_ALLERGIES, allergies);
                                      }
                                      helperWidget.showToast(
                                        "Record updated successfully",
                                      );
                                      recordValueController.clear();
                                      setState(() {});
                                      Navigator.pop(context);
                                    } else {
                                      helperWidget.showToast(
                                        "Failed to update record",
                                      );
                                    }
                                  } catch (e) {
                                    my_log(e);

                                    helperWidget.showToast(
                                      "Failed to update record",
                                    );
                                  } finally {
                                    setCustomState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 30.w,
                          ),
                        ),
                        child:
                            isLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                  'Save Record',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
