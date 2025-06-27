import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../api/medication_reminder_service.dart';
import '../../utils/global.dart';

class SearchMedicine extends StatefulWidget {
  const SearchMedicine({super.key});

  @override
  State<SearchMedicine> createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  @override
  dispose() {
    super.dispose();

    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(context, 'Search Medicines'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        child: Column(
          children: [
            buildSearchWidget(),
            SizedBox(height: 12.h),
            isLoading
                ? const CupertinoActivityIndicator()
                : medicineData == null
                ? Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      'No medicine found',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      // height: 566.h,
                      padding: EdgeInsets.all(13.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(
                              2,
                              2,
                            ), // Shadow only at bottom right
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //                    brand_name: brandName,
                          // generic_name: genericName,
                          // manufacturer_name: manufacturerName,
                          // purpose: purpose,
                          // active_ingredient: activeIngredient,
                          // dosage_and_administration: dosageAndAdministration,
                          // storage_and_handling: storageAndHandling,
                          // warnings: warnings,
                          // do_not_use: doNotUse,
                          // indication_and_usage: indicationAndUsage
                          for (var entry in medicineData.entries)
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${entry.key.replaceAll('_', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ')}: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${entry.value}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // const SizedBox(
                          //   height: 3,
                          // ),
                          //  Text(
                          //   'Brand Name:${medicineData['generic_name']}',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 14,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 3,
                          // ),
                          // const Text(
                          //   'Track your health vitals. Tap to get started.',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Timer? _debounce;
  dynamic medicineData;
  bool isLoading = false;
  final MedicationReminderService _medicationReminderService =
      MedicationReminderService();

  Container buildSearchWidget() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          setState(() {
            isLoading = true;
          });
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(seconds: 3), () async {
            if (value.isNotEmpty) {
              try {
                var res = await _medicationReminderService.searchMedicine(
                  drugName: value,
                );
                print(res);
                if (res['count'] == 1) {
                  medicineData = res['medication'];
                } else {
                  medicineData = null;
                }
              } catch (e) {
                helperWidget.showToast("Oops! Something went wrong.");
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            } else {
              setState(() {
                medicineData = null;

                isLoading = false;
              });
            }
          });
        },
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 15.h),
          border: InputBorder.none,
          hintText: 'Search for medicine information',
          hintStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.black54),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
