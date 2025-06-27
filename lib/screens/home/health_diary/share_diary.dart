import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medplan/utils/global.dart';

class ShareDiary extends StatefulWidget {
  const ShareDiary({super.key});

  @override
  State<ShareDiary> createState() => _ShareDiaryState();
}

class _ShareDiaryState extends State<ShareDiary> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  List<String> healthReportOptions = [
    'My Health Diary',
    'My Medication History',
    'My Health Record',
  ];
  List<String> selectedHealthReportOptions = ['My Health Diary'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: helperWidget.myAppBar(
        context,
        'Share Health Report',
        isBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          const Text(
            'Select a MedPlan companion to share to: ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text(
              'Select',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
                // fontSize: 14,
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
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            items: null,
            // ['Male', 'Female'].map((String value) {
            //   return DropdownMenuItem<String>(
            //     value: value,
            //     child: Text(
            //       value,
            //       style: TextStyle(
            //         color: Colors.black87,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   );
            // }).toList(),
            onChanged: (String? newValue) {
              // Handle change
            },
          ),
          const SizedBox(height: 25),
          const Text(
            'OR Share to new recipient mail',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Enter Email',
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 15,
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
          const SizedBox(height: 25),
          const Text(
            'Choose which Health Reports to Share:',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(healthReportOptions.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: Checkbox(
                      side: BorderSide.none,
                      value: selectedHealthReportOptions.contains(
                        healthReportOptions[index],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onChanged: (value) {
                        if (value == true) {
                          selectedHealthReportOptions.add(
                            healthReportOptions[index],
                          );
                        } else {
                          selectedHealthReportOptions.remove(
                            healthReportOptions[index],
                          );
                        }
                        setState(() {});
                      },
                      fillColor: WidgetStateProperty.all(Colors.grey[300]),
                      checkColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    healthReportOptions[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 30),
          const Text(
            'Reports',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'From Date:',
                    hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 16),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _startDateController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 80),
              Expanded(
                child: TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'To Date:',
                    hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 16),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _endDateController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: Checkbox(
                  value: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  fillColor: WidgetStateProperty.all(Colors.grey[300]),
                  checkColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 10),
               Expanded(
                child: Text(
                  "By tapping “Send Report”, you agree to have your health data sent to the above stated individual and or  email.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 55),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle save
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 60,
                ),
              ),
              child:  Text(
                'Send Report',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  bool isChecked = false;
}
