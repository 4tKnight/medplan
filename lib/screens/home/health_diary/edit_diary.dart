// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:medplan/utils/global.dart';

// import '../../../server/health_diary_api_requests.dart';

// class EditDiary extends StatefulWidget {
//   EditDiary(this.noteID, {required this.additional_note, required this.color, required this.mood, required this.symptoms, Key? key}) : super(key: key);
//   String color;
//   String additional_note;
//   String mood;
//   List<String> symptoms;
//   String noteID;
//   @override
//   EditDiaryState createState() => EditDiaryState();
// }

// class EditDiaryState extends State<EditDiary> {
//   @override
//   void initState() {
//     selectedMood = widget.mood;
//     editted_text = widget.additional_note;
//     check_symptoms();
//     super.initState();
//   }

//   late String editted_text;

//   bool hasHeadache = false;
//   bool hasFever = false;
//   bool hasBodyPain = false;
//   bool hasItchness = false;
//   bool hasRashes = false;

//   bool hasNauseaVomiting = false;
//   bool hasConstipation = false;
//   bool hasDiarrhoea = false;
//   bool hasAbdominalPain = false;
//   bool isBleeding = false;

//   List<String> selected_symptoms = <String>[];

//   bool isLoading = false;

//   late String selectedMood;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: helperWidget.myAppBar(context, "How are you feeling today"),
//         body: ListView(
//           padding: EdgeInsets.fromLTRB(12, 12, 12, 60),
//           children: [
//             Text("MOOD"),
//             SizedBox(height: 5),
//             Container(
//               color: Theme.of(context).cardColor,
//               child: GridView.builder(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 shrinkWrap: true,
//                 itemCount: constants.smileys.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 5,
//                   mainAxisSpacing: 5,
//                   crossAxisSpacing: 5,
//                   // childAspectRatio: 0.6/0.8,
//                   // childAspectRatio: 0.65/0.8,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                       onTap: () {
//                         selectedMood = constants.smileys_text[index];
//                         setState(() {});
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             height: 60,
//                             width: 70,
//                             // color: Colors.grey,
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   "./assets/${constants.smileys[index]}",
//                                   height: 35,
//                                   width: 35,
//                                 ),
//                                 SizedBox(height: 4),
//                                 FittedBox(child: Text(constants.smileys_text[index], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300))),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: -15,
//                             right: -15,
//                             child: Radio(
//                               activeColor: primaryColor, //MaterialStateProperty.all<Color?>(Color.fromRGBO( 31, 170, 8,1)),
//                               value: "${constants.smileys_text[index]}",
//                               groupValue: selectedMood,
//                               onChanged: (value) {
//                                 // print(value);
//                                 selectedMood = value.toString();

//                                 setState(() {});
//                               },
//                             ),
//                           )
//                         ],
//                       ));
//                 },
//               ),
//             ),
//             SizedBox(height: 50),
//             Text("SYMPTOMS"),
//             SizedBox(height: 10),
//             GridView(
//               // itemCount: 14,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 10.0,
//                 crossAxisSpacing: 14.0,
//                 childAspectRatio: 2 / 0.3,
//               ),
//               children: [
//                 buildSymptomsTile(constants.symptoms[0], hasHeadache, (value) {
//                   setState(() {
//                     hasHeadache = value!;
//                   });

//                   // print("hasHeadache: $hasHeadache");
//                 }),
//                 buildSymptomsTile(constants.symptoms[1], hasNauseaVomiting, (value) {
//                   setState(() {
//                     hasNauseaVomiting = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[2], hasFever, (value) {
//                   setState(() {
//                     hasFever = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[3], hasConstipation, (value) {
//                   setState(() {
//                     hasConstipation = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[4], hasBodyPain, (value) {
//                   setState(() {
//                     hasBodyPain = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[5], hasDiarrhoea, (value) {
//                   setState(() {
//                     hasDiarrhoea = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[6], hasItchness, (value) {
//                   setState(() {
//                     hasItchness = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[7], hasAbdominalPain, (value) {
//                   setState(() {
//                     hasAbdominalPain = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[8], hasRashes, (value) {
//                   setState(() {
//                     hasRashes = value!;
//                   });
//                 }),
//                 buildSymptomsTile(constants.symptoms[9], isBleeding, (value) {
//                   setState(() {
//                     isBleeding = value!;
//                   });
//                 }),
//               ],
//             ),
//             SizedBox(height: 50),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Text(
//                     "ADDITIONAL NOTES",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w300,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 TextFormField(
//                   initialValue: editted_text,
//                   maxLines: 4,
//                   keyboardType: TextInputType.text,
//                   textCapitalization: TextCapitalization.sentences,
//                   maxLength: 200,
//                   onChanged: (val) {
//                     editted_text = val;
//                   },
//                   decoration: InputDecoration(
//                     isDense: true,
//                     fillColor: Color.fromRGBO(218, 218, 218, 0.4),
//                     filled: true,
//                     border: OutlineInputBorder(borderSide: BorderSide.none),
//                   ),
//                   textInputAction: TextInputAction.next,
//                   // enabled: otherReasonSelected,
//                 ),
//               ],
//             ),
//             SizedBox(height: 60),
//             Center(
//               child: isLoading
//                   ? helperWidget.buildLoadingButton()
//                   : SizedBox(
//                       width: 200,
//                       child: ElevatedButton(
//                         style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), backgroundColor: MaterialStateProperty.all<Color>(primaryColor)),
//                         onPressed: () {
//                           _edit_note();
//                         },
//                         child: const Text('Save to Diary'),
//                       ),
//                     ),
//             ),
//           ],
//         ));
//   }

//   check_symptoms() {
//     List<String> symp = widget.symptoms;

//     symp.forEach((element) {
//       if (element.trim() == constants.symptoms[0]) {
//         hasHeadache = true;
//       }
//       else if (element.trim() == constants.symptoms[1]) {
//         hasNauseaVomiting = true;
//       }
//       else if (element.trim() == constants.symptoms[2]) {
//         hasFever = true;
//       }
//       else if (element.trim() == constants.symptoms[3]) {
//         hasConstipation = true;
//       }
//       else if (element.trim() == constants.symptoms[4]) {
//         hasBodyPain = true;
//       }
//       else if (element.trim() == constants.symptoms[5]) {
//         hasDiarrhoea = true;
//       }
//       else if (element.trim() == constants.symptoms[6]) {
//         hasItchness = true;
//       }
//       else if (element.trim() == constants.symptoms[7]) {
//         hasAbdominalPain = true;
//       }
//       else if (element.trim() == constants.symptoms[8]) {
//         hasRashes = true;
//       }
//       else if (element.trim() == constants.symptoms[9]) {
//         isBleeding = true;
//       }
//     });
//   }

//   buildSymptomsTile(String text, bool value, Function(bool?) function) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(
//           height: 24.0,
//           width: 24.0,
//           child: Checkbox(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(3.0),
//             ),
//             side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: primaryColor)),
//             onChanged: function,
//             fillColor: MaterialStateProperty.all(Colors.white),
//             checkColor: primaryColor,
//             value: value,
//           ),
//         ),
//         SizedBox(width: 4),
//         Expanded(
//             child: GestureDetector(
//           onTap: () {
//             bool n_value;

//             if (value == true) {
//               n_value = false;
//             } else {
//               n_value = true;
//             }

//             if (text == constants.symptoms[0]) {
//               hasHeadache = n_value;
//               // print("value1: $hasHeadache");
//             } else if (text == constants.symptoms[1]) {
//               hasNauseaVomiting = n_value;
//             } else if (text == constants.symptoms[2]) {
//               hasFever = n_value;
//             } else if (text == constants.symptoms[3]) {
//               hasConstipation = n_value;
//             } else if (text == constants.symptoms[4]) {
//               hasBodyPain = n_value;
//             } else if (text == constants.symptoms[5]) {
//               hasDiarrhoea = n_value;
//             } else if (text == constants.symptoms[6]) {
//               hasItchness = n_value;
//             } else if (text == constants.symptoms[7]) {
//               hasAbdominalPain = n_value;
//             } else if (text == constants.symptoms[8]) {
//               hasRashes = n_value;
//             } else if (text == constants.symptoms[9]) {
//               isBleeding = n_value;
//             }
//             setState(() {});
//           },
//           child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
//         )),
//       ],
//     );
//   }

//   void _edit_note() {
//     FocusScope.of(context).requestFocus(FocusNode());

//     selected_symptoms.clear(); //incase for one reason or the other the operation did not work well at first, so it can clear the list first, to avoid duplicate entries
//     if (hasHeadache == true) {
//       selected_symptoms.add(constants.symptoms[0]);
//     }
//     if (hasNauseaVomiting == true) {
//       selected_symptoms.add(constants.symptoms[1]);
//     }
//     if (hasFever == true) {
//       selected_symptoms.add(constants.symptoms[2]);
//     }
//     if (hasConstipation == true) {
//       selected_symptoms.add(constants.symptoms[3]);
//     }
//     if (hasBodyPain == true) {
//       selected_symptoms.add(constants.symptoms[4]);
//     }
//     if (hasDiarrhoea == true) {
//       selected_symptoms.add(constants.symptoms[5]);
//     }
//     if (hasItchness == true) {
//       selected_symptoms.add(constants.symptoms[6]);
//     }
//     if (hasAbdominalPain == true) {
//       selected_symptoms.add(constants.symptoms[7]);
//     }
//     if (hasRashes == true) {
//       selected_symptoms.add(constants.symptoms[8]);
//     }
//     if (isBleeding == true) {
//       selected_symptoms.add(constants.symptoms[9]);
//     }

//     if (editted_text.isEmpty) {
//       helperWidget.showSnackbar(context, "Please add a note");
//     } else {
//       print(selected_symptoms);

//       setState(() {
//         isLoading = true;
//       });

//       edit_diary_note(noteID: widget.noteID, mood: selectedMood, symptoms: selected_symptoms, note: editted_text, color: widget.color).then((res) {
//         print(res);
//         if (res["msg"] == "Edit Successful") {
//           Navigator.pop(context, res["notes"][0]);
//           //TODO: ok like this, but when the user now presses back again, it should reload the list
//         } else {
//           helperWidget.showSnackbar(context, "An error occured");
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }).catchError((e) {
//         if (e is SocketException) {
//           print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
//           helperWidget.showSnackbar(context, "Check your internet connection & try again");
//         } else {
//           helperWidget.showSnackbar(context, "A server error occured");
//         }
//         setState(() {
//           isLoading = false;
//         });
//       });
//     }
//   }
// }
