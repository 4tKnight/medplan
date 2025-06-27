import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/utils/custom_expandable_widget.dart';
import 'package:medplan/utils/functions.dart';

import '../../../utils/global.dart';

class Surgeries extends StatefulWidget {
  var dependentData;
  Surgeries({super.key, this.dependentData});

  @override
  State<Surgeries> createState() => _SurgeriesState();
}

class _SurgeriesState extends State<Surgeries> {
  @override
  initState() {
    super.initState();
    if (widget.dependentData == null) {
      surgeries = getX.read(v.GETX_SURGERIES) ?? [];
    } else {
      surgeries = widget.dependentData['surgeries'] ?? [];
    }
  }

  String name = 'Surgeries';
  List<dynamic> surgeries = [];
  String language = 'English';
  String content =
      "Surgery is a medical procedure in which doctors make a cut in your body to treat a disease, injury, or other health problem. Some examples of surgery are taking out a tumor, opening a blockage in your intestine, or attaching a blood vessel in a new place to help blood flow to part of your body.\n\nEmergency surgery treats a life-threatening problem right away, such as repairing a burst artery\nUrgent surgery treats a serious problem within hours, such as removing an inflamed appendix\nElective surgery treats a problem that can wait until you're ready to have it fixed, such as replacing a knee joint or removing wrinkles on your face to help your appearance (cosmetic surgery).\n\nIf your doctor recommends that you have surgery, you may first want to get a second opinion, where you tell another doctor about your health problem and ask how that doctor would treat it. This lets you compare their treatment advice to your regular doctor's advice.";

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
            image: 'surgeries',

            addButton: buildAddButton(),
            fieldName: 'surgery_name',
            dataList: surgeries,
            removeFunc: _removeSurgery,
          ),
          SizedBox(height: 55.h),
        ],
      ),
    );
  }

  void _removeSurgery(int index) async {
    List<dynamic> tempSurgeries = List.from(surgeries);
    try {
      setState(() {
        surgeries.removeAt(index);
      });
      var res = await _healthRecordServices.updateSurgeries(
        dependentId: widget.dependentData['_id'] ?? '',
        surgeries: surgeries,
      );
      my_log(res);
      if (res['status'] == 'ok') {
        if (widget.dependentData == null) {
          getX.write(v.GETX_SURGERIES, surgeries);
        }
        helperWidget.showToast("Record updated successfully");
      } else {
        setState(() {
          surgeries = tempSurgeries;
        });
        helperWidget.showToast("Failed to update record");
      }
    } catch (e) {
      my_log(e);
      setState(() {
        surgeries = tempSurgeries;
      });

      helperWidget.showToast("Failed to update record");
    }
  }

  CustomExpandableWidget buildRecordDescriptionArea() {
    return CustomExpandableWidget(
      'What Surgery?',
      Text.rich(
        TextSpan(
          text:
              "Surgery is a medical procedure in which doctors make a cut in your body to treat a disease, injury, or other health problem. Some examples of surgery are taking out a tumor, opening a blockage in your intestine, or attaching a blood vessel in a new place to help blood flow to part of your body.\n\n",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          children: [
            TextSpan(
              text: 'Emergency surgery',
              style: TextStyle(
                decoration: TextDecoration.underline,
                // decorationColor: Theme.of(context).primaryColor,
              ),
            ),
            TextSpan(
              text:
                  " treats a life-threatening problem right away, such as repairing a burst artery\n",
            ),
            TextSpan(
              text: 'Urgent surgery',
              style: TextStyle(
                decoration: TextDecoration.underline,
                // decorationColor: Theme.of(context).primaryColor,
              ),
            ),
            TextSpan(
              text:
                  " treats a serious problem within hours, such as removing an inflamed appendix\n",
            ),
            TextSpan(
              text: 'Elective surgery',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(
              text:
                  " treats a problem that can wait until you're ready to have it fixed, such as replacing a knee joint or removing wrinkles on your face to help your appearance (cosmetic surgery).\n\nIf your doctor recommends that you have surgery, you may first want to get a second opinion, where you tell another doctor about your health problem and ask how that doctor would treat it. This lets you compare their treatment advice to your regular doctor's advice.",
            ),
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
                          'Enter Surgery',
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
                      // height: 45,
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
                                      "Please enter surgery name",
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
                                      'surgery_name':
                                          recordValueController.text,
                                    };
                                    var res = await _healthRecordServices
                                        .updateSurgeries(
                                          dependentId: widget.dependentData,
                                          surgeries: [...surgeries, recordData],
                                        );
                                    my_log(res);
                                    if (res['status'] == 'ok') {
                                      surgeries.add(recordData);
                                      if (widget.dependentData == null) {
                                        getX.write(v.GETX_SURGERIES, surgeries);
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
