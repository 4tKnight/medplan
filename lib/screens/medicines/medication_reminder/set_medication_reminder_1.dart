import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/global.dart';
import 'set_medication_reminder2.dart';

class SetMedicationReminderStepOne extends StatefulWidget {
  bool isDependent;
  String dependentId;
  dynamic medicationReminderData;
  SetMedicationReminderStepOne({
    super.key,
    this.medicationReminderData,
    required this.isDependent,
    this.dependentId = '',
  });

  @override
  State<SetMedicationReminderStepOne> createState() =>
      _SetMedicationReminderStepOneState();
}

class _SetMedicationReminderStepOneState
    extends State<SetMedicationReminderStepOne> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicationDoseValueController =
      TextEditingController();
  String? selectedMedicineForm;
  String? selectedMedicineDose;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.medicationReminderData != null) {
      setData();
    }
  }

  setData() {
    setState(() {
      _medicineNameController.text =
          widget.medicationReminderData['medicine_name'];
      _medicationDoseValueController.text =
          widget.medicationReminderData['dosage_quantity'].split(' ')[0];
      selectedMedicineDose =
          widget.medicationReminderData['dosage_quantity'].split(' ')[1];
      selectedMedicineForm = widget.medicationReminderData['dosage_form'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, "Set a Medication Reminder"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          buildHeaderArea(),
          SizedBox(height: 46.h),
          Text(
            'Medicine name eg: Paracetamol 500mg',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 42.h,

            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              controller: _medicineNameController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10.h),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Medicine form eg: Tablet, Syrup etc',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                style: TextStyle(fontSize: 15.sp, color: Colors.black),

                isDense: true,
                value: selectedMedicineForm,
                isExpanded: true,
                items:
                    constants.dosage_forms.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMedicineForm = newValue;
                    selectedMedicineDose =
                        constants.medicationDose[selectedMedicineForm]![0];
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Medication Dose (What quantity of this drug are you taking?)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextField(
                    controller: _medicationDoseValueController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 14.sp),

                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10.h),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: TextStyle(fontSize: 15.sp, color: Colors.black),

                      value: selectedMedicineDose,
                      isExpanded: true,
                      items:
                          selectedMedicineForm == null
                              ? []
                              : constants.medicationDose[selectedMedicineForm]
                                  ?.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        maxLines: 1,

                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                      onChanged:
                          selectedMedicineForm == null
                              ? null
                              : (String? newValue) {
                                setState(() {
                                  selectedMedicineDose = newValue;
                                });
                              },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 153.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_medicineNameController.text.isEmpty) {
                  helperWidget.showToast("Please enter medicine name");
                  return;
                }
                if (_medicationDoseValueController.text.isEmpty) {
                  helperWidget.showToast("Please enter medication dose");
                  return;
                }
                if (selectedMedicineForm == null) {
                  helperWidget.showToast("Please select medicine form");
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => SetMedicationReminderStepTwo(
                          isDependent: widget.isDependent,
                          dependentId: widget.dependentId,
                          medicationReminderData: widget.medicationReminderData,
                          medicineName: _medicineNameController.text.trim(),
                          dosageForm: selectedMedicineForm!,
                          dosageQuantity:
                              '${_medicationDoseValueController.text} $selectedMedicineDose',
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
              ),
              child: Text(
                'Next Step >>',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '(Medicine Details)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 4.h,
              width: 99.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(253, 170, 39, 1),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '(Intake Instructions)',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 4.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 240, 240, 1),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ],
        ),
        selectedMedicineForm != null
            ? ClipOval(
              child: Image.asset(
                "${constants.dosageImages[selectedMedicineForm]}",

                fit: BoxFit.cover,

                height: 36.r,
                width: 36.r,
              ),
            )
            : SizedBox(height: 35.r, width: 35.r),
      ],
    );
  }
}
