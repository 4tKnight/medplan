import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/api/health_record_service.dart';
import 'package:medplan/api/profile_service.dart';
import 'package:medplan/screens/bottom_control/bottom_nav_bar.dart';
import 'package:medplan/utils/functions.dart';
import 'package:medplan/utils/global.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import 'records/a1c_test.dart';
import 'records/alcohol_consumption.dart';
import 'records/allergies.dart';
import 'records/blood_pressure.dart';
import 'records/body_fat.dart';
import 'records/body_mass_index.dart';
import 'records/c4_cell_count.dart';
import 'records/calories_consumption.dart';
import 'records/creatinine.dart';
import 'records/daily_steps.dart';
import 'records/egfr.dart';
import 'records/family_medical_conditions.dart';
import 'records/fasting_blood_glucose.dart';
import 'records/glass_of_water.dart';
import 'records/hdl.dart';
import 'records/hiv_viral_load.dart';
import 'records/ldl.dart';
import 'records/pulse_rate.dart';
import 'records/random_blood.glucose.dart';
import 'records/respiratory_rate.dart';
import 'records/sleep_hours.dart';
import 'records/surgeries.dart';
import 'records/temperature.dart';
import 'records/triglycerides.dart';
import 'records/waist_circumference.dart';
import 'records/weight.dart';

class HealthRecordBody extends StatefulWidget {
  const HealthRecordBody({super.key});

  @override
  State<HealthRecordBody> createState() => _HealthRecordBodyState();
}

class _HealthRecordBodyState extends State<HealthRecordBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.h),
      child: Column(
        children: [
          buildPSIWidget(),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
          buildHealthRecordWidget('clinical_vitals.png', 'Clinical Vitals', [
            'Pulse Rate',
            'Blood Pressure',
            'Temperature',
            'Respiratory Rate',
          ], true),
          buildHealthRecordWidget('blood_glucose.png', 'Blood Glucose', [
            'A1C Test',
            'Fasting Blood Glucose',
            'Random Blood Glucose',
          ], true),
          buildHealthRecordWidget('blood_chol.png', 'Blood Cholesterol', [
            'High Density Lipoprotein (HDL)',
            'Low Density Lipoprotein (LDL)',
            'Triglycerides',
          ], true),
          buildHealthRecordWidget('fitness.png', 'Fitness', [
            'Body Fat Percentage',
            'Calories consumption',
            'Daily Steps',
            'Weight',
            'Waist Circumference',
            'Glass of Water',
            'Alcohol Consumption',
            'Sleep Hours',
          ], true),
          buildHealthRecordWidget('lab_results.png', 'Lab Result', [
            'Creatinine',
            'Estimate Glomerular Filtration rate',
          ], true),
          buildHealthRecordWidget('hiv.png', 'HIV', [
            'CD4 Cell count',
            'HIV Viral Load',
          ], true),
          buildOtherHealthRecordWidget('Allergies', 'allergies.png'),
          buildOtherHealthRecordWidget('Surgeries', 'surgeries.png'),
          buildOtherHealthRecordWidget('Family Medical Conditions', 'fmc.png'),
        ],
      ),
    );
  }

  Widget buildOtherHealthRecordWidget(String title, String image) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print(title);
              if (title == 'Allergies') {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) =>  Allergies()));
              } else if (title == 'Surgeries') {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) =>  Surgeries()));
              } else if (title == 'Family Medical Conditions') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>  FamilyMedicalConditions(),
                  ),
                );
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/$image",
                        fit: BoxFit.cover,
                        height: 22.h,
                        width: 22.w,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
        ],
      ),
    );
  }

  Widget collapsedTileWidget(String image, String title) {
    return Row(
      children: [
        Image.asset(
          "assets/$image",
          fit: BoxFit.cover,
          height: 22.h,
          width: 22.w,
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget buildHealthRecordWidget(
    String image,
    String title,
    List<String> items,
    bool showDivider,
  ) {
    return Column(
      children: [
        ListTileTheme(
          dense: true,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(top: 0, bottom: 0),
            title: collapsedTileWidget(image, title),
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            childrenPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 15.h,
            ),
            children: <Widget>[
              ...List.generate(
                items.length,
                (index) => Column(
                  children: [
                    buildTextTile(items[index]),
                    if (items.length - 1 != index) _buildDivider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color.fromRGBO(0, 0, 0, 0.3),
      ),
    );
  }

  Widget buildTextTile(String title) {
    return InkWell(
      child: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•  $title',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        print(title);
        if (title == 'Pulse Rate') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  PulseRate()));
        } else if (title == 'Blood Pressure') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  BloodPressure()));
        } else if (title == 'Temperature') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  Temperature()));
        } else if (title == 'Respiratory Rate') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  RespiratoryRate()));
        } else if (title == 'A1C Test') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  A1CTest()));
        } else if (title == 'Fasting Blood Glucose') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  FastingBloodGlucose()),
          );
        } else if (title == 'Random Blood Glucose') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  RandomBloodGlucose()));
        } else if (title == 'High Density Lipoprotein (HDL)') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  HDL()));
        } else if (title == 'Low Density Lipoprotein (LDL)') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  LDL()));
        } else if (title == 'Triglycerides') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  Triglycerides()));
        } else if (title == 'Body Fat Percentage') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  BodyFat()));
        } else if (title == 'Calories consumption') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  CaloriesConsumption()),
          );
        } else if (title == 'Daily Steps') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  DailySteps()));
        } else if (title == 'Weight') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  Weight()));
        } else if (title == 'Waist Circumference') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  WaistCircumference()));
        } else if (title == 'Glass of Water') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  GlassOfWater()));
        } else if (title == 'Alcohol Consumption') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  AlcoholConsumption()));
        } else if (title == 'Sleep Hours') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  SleepHours()));
        } else if (title == 'Creatinine') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  Creatinine()));
        } else if (title == 'Estimate Glomerular Filtration rate') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  EGFR()));
        } else if (title == 'CD4 Cell count') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  C4CellCount()));
        } else if (title == 'HIV Viral Load') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) =>  HIVViralLoad()));
        }
      },
    );
  }

  String? genotype =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['genotype'] == ''
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['genotype'];
  String? bloodGroup =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['blood_group'] == ''
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['blood_group'];
  int? weight =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['weight'] == 0
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['weight'];
  double? height =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['height'] == 0.0
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['height'];
  double? bmi =
      getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['bmi'] == 0.0
          ? null
          : getX.read(v.GETX_PERSONAL_HEALTH_INFORMATION)['bmi'];

  final HealthRecordServices _healthRecordServices = HealthRecordServices();

  _updatePersonalHealthInfo({required Function onError}) async {
    if (weight == null || height == null) {
      helperWidget.showToast(
        "Please set your weight and height before updating genotype.",
      );

      return;
    }
    try {
      var healthInfo = {
        "genotype": genotype,
        "blood_group": bloodGroup,
        "weight": weight,
        "height": height,
        "bmi": calculateBMI(weight!, height!),
      };

      final res = await _healthRecordServices.setPersonalHealthInfo(healthInfo:healthInfo,dependentId: '');
      my_log(res);

      if (res['status'] == 'ok') {
        set_getX_data(context, res);

        setState(() {
          genotype = res['personal_health_information']['genotype'];
          bloodGroup = res['personal_health_information']['blood_group'];
          weight = res['personal_health_information']['weight'];
          height = res['personal_health_information']['height'];
          bmi = res['personal_health_information']['bmi'];
        });
      } else {
        onError();
        helperWidget.showToast(
          "oOps something went wrong while updating personal health information",
        );
      }
    } catch (e) {
      onError();
      my_log(e);
      helperWidget.showToast(
        "oOps something went wrong while updating personal health information",
      );
    }
  }

  Widget buildPSIWidget() {
    return ListTileTheme(
      dense: true,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(top: 0, bottom: 0),
        title: collapsedTileWidget(
          'personal_health_information.png',
          'Personal Health Information',
        ),
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        childrenPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•   Genotype',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              // const SizedBox(width: 10),
              DropdownButton<String>(
                value: genotype,
                icon: const Icon(Icons.arrow_drop_down),
                isDense: true,
                // iconSize: 24,
                elevation: 0,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                underline: Container(height: 0, color: Colors.transparent),
                onChanged: (String? newValue) async {
                  var previousValue = genotype;
                  setState(() {
                    genotype = newValue;
                  });
                  _updatePersonalHealthInfo(
                    onError: () {
                      setState(() {
                        genotype = previousValue;
                      });
                    },
                  );
                },
                items:
                    constants.genotypes.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          _buildDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•   Blood Group',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              // const SizedBox(width: 10),
              DropdownButton<String>(
                value: bloodGroup,
                icon: const Icon(Icons.arrow_drop_down),
                isDense: true,
                // iconSize: 24,
                elevation: 0,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                underline: Container(height: 0, color: Colors.transparent),
                onChanged: (String? newValue) {
                   var previousValue = bloodGroup;
                  setState(() {
                    bloodGroup = newValue;
                  });
                  _updatePersonalHealthInfo(
                    onError: () {
                      setState(() {
                        bloodGroup = previousValue;
                      });
                    },
                  );
                },
                items:
                    constants.bloodGroups.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          _buildDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•   Weight',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              // const SizedBox(width: 10),
              DropdownButton<int>(
                value: weight,
                icon: const Icon(Icons.arrow_drop_down),
                isDense: true,
                // iconSize: 24,
                elevation: 0,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                underline: Container(height: 0, color: Colors.transparent),
                onChanged: (int? newValue) {
                  var previousValue = weight;
                  setState(() {
                    weight = newValue;
                  });
                  _updatePersonalHealthInfo(
                    onError: () {
                      setState(() {
                        weight = previousValue;
                      });
                    },
                  );
                },
                items:
                    constants.weights.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          "$value",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          _buildDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•   Height',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              // const SizedBox(width: 10),
              DropdownButton<double>(
                value: height,
                icon: const Icon(Icons.arrow_drop_down),
                isDense: true,
                // iconSize: 24,
                elevation: 0,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                underline: Container(height: 0, color: Colors.transparent),
                onChanged: (double? newValue) {
                 var previousValue = height;
                  setState(() {
                    height = newValue;
                  });
                  _updatePersonalHealthInfo(
                    onError: () {
                      setState(() {
                        height = previousValue;
                      });
                    },
                  );
                },
                items:
                    constants.heights.map<DropdownMenuItem<double>>((
                      double value,
                    ) {
                      return DropdownMenuItem<double>(
                        value: value,
                        child: Text(
                          "$value",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          _buildDivider(),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '•   Body Mass Index (BMI)',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BodyMassIndex(),
                          ),
                        );
                      },
                      child: Container(
                        width: 18.r,
                        height: 18.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'i',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 24.w),
                child: Text(
                  '24.45',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
