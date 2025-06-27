import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class FamilyMedicalConditions extends StatefulWidget {
  var dependentData;

   FamilyMedicalConditions({super.key,this.dependentData});

  @override
  State<FamilyMedicalConditions> createState() =>
      _FamilyMedicalConditionsState();
}

class _FamilyMedicalConditionsState extends State<FamilyMedicalConditions> {
   @override
  initState() {
    super.initState();
    if (widget.dependentData == null) {
      familyMedicalConditions = getX.read(v.GETX_FAMILY_CONDITIONS) ?? [];
    } else {
      familyMedicalConditions = widget.dependentData['family_conditions'] ?? [];
    }
  }
  String name = 'Family Medical Conditions';
  List<dynamic> familyMedicalConditions = [];
  String language = 'English';
  String content =
      "Family medical conditions are health conditions that run in families, such as: \nasthma, cancer, diabetes, heart disease, high blood pressure, high cholesterol, mental illness, osteoporosis, and stroke.\nA family medical history is a record of the medical histories of family members, including current and past illnesses. It can show patterns of certain diseases in a family. \nA close relative having a certain condition doesn't necessarily mean you'll get it, but your chances may be higher than other people's. \n\nA family health history can help your provider recommend screening tests or start them earlier than generally recommended.";

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
       title:      name,
        image:     'fmc',
       addButton:      buildAddButton(),
            fieldName: 'condition_name',
            dataList: familyMedicalConditions,
            removeFunc: _removeFamilyMedicalCondition,
          ),
          SizedBox(height: 55.h),
        ],
      ),
    );
  }

   void _removeFamilyMedicalCondition(int index) async {
    List<dynamic> tempFamilyMedicalConditions = List.from(familyMedicalConditions);
    try {
      setState(() {
        familyMedicalConditions.removeAt(index);
      });
      var res = await _healthRecordServices.updateFamilyConditions(
        dependentId: widget.dependentData['_id']??'',
        familyConditions: 
        familyMedicalConditions);
      my_log(res);
      if (res['status'] == 'ok') {
        if(widget.dependentData==null){

        getX.write(v.GETX_FAMILY_CONDITIONS, familyMedicalConditions);
        }
        helperWidget.showToast("Record updated successfully");
      } else {
        setState(() {
          familyMedicalConditions = tempFamilyMedicalConditions;
        });
        helperWidget.showToast("Failed to update record");
      }
    } catch (e) {
      my_log(e);
      setState(() {
        familyMedicalConditions = tempFamilyMedicalConditions;
      });

      helperWidget.showToast("Failed to update record");
    }
  }

  CustomExpandableWidget buildRecordDescriptionArea() {
    return CustomExpandableWidget(
      'What is are Family Medical Conditions?',

      Text.rich(
        TextSpan(
          text:
              "Family medical conditions are health conditions that run in families, such as: \nasthma, cancer, diabetes, heart disease, high blood pressure, high cholesterol, mental illness, osteoporosis, and stroke.\nA family medical history is a record of the medical histories of family members, including current and past illnesses. It can show patterns of certain diseases in a family. \nA close relative having a certain condition doesn't necessarily mean you'll get it, but your chances may be higher than other people's. \n\nA family health history can help your provider recommend screening tests or start them earlier than generally recommended.",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp.sp),
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

  TextEditingController recordValueController = TextEditingController();
  final HealthRecordServices _healthRecordServices = HealthRecordServices();
  Future<dynamic> buildAddBottomSheet() {
    bool isLoading = false;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Family Medical Conditions',
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
                      height: 45,
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
                    const SizedBox(height: 42),
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
                                      "Please enter family medical condition name",
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
                                      'condition_name':
                                          recordValueController.text,
                                    };
                                    var res = await _healthRecordServices
                                        .updateFamilyConditions(
                                          familyConditions: [...familyMedicalConditions,recordData],
                                          dependentId: widget.dependentData['_id']??'',
                                        );
                                    my_log(res);
                                    if (res['status'] == 'ok') {
                                      familyMedicalConditions.add(recordData);
                                      if(widget.dependentData== null){

                                      getX.write(
                                        v.GETX_FAMILY_CONDITIONS,
                                        familyMedicalConditions,
                                      );
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
