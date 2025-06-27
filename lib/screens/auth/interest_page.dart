// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:medplan/screens/bottom_control/bottom_nav_bar.dart';
// import 'package:medplan/utils/global.dart';

// import '../../server/follow_api_requests.dart';

// class InterestPage extends StatefulWidget {
//   const InterestPage({super.key});

//   @override
//   _InterestPageState createState() => _InterestPageState();
// }

// class _InterestPageState extends State<InterestPage> {
//   List<String> interests = [];
//   bool loading = false;
//   Color selectedInterestColor = Color.fromRGBO(10, 255, 211, 1);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: ListView(
//         shrinkWrap: true,
//         // mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 40),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               "Choose your health interests?",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               "This will help us give you a better experience by tailoring information for you",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w300,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           SizedBox(
//             height: 700,
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 30,
//                   left: 20,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[0],
//                       picture_name: "eye",
//                       size: 100,
//                       first_text: "Eye",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[4],
//                       picture_name: "digestive",
//                       size: 140,
//                       first_text: "Digestive",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 268,
//                   left: 0,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[1],
//                       picture_name: "heart",
//                       size: 170,
//                       first_text: "Heart",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 255,
//                   right: 0,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[6],
//                       picture_name: "reproductive",
//                       size: 170,
//                       first_text: "Reproductive",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 400,
//                   right: 80,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[7],
//                       picture_name: "skel",
//                       size: 170,
//                       first_text: "Skeletomuscular",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 530,
//                   left: 0,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[2],
//                       picture_name: "immune",
//                       size: 140,
//                       first_text: "Immune",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 530,
//                   right: 10,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[3],
//                       picture_name: "urinary",
//                       size: 100,
//                       first_text: "Urinary",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 100,
//                   right: 90,
//                   child: draggableInterestWidget(
//                     interestWidget(
//                       interest: constants.interests[5],
//                       picture_name: "enth2",
//                       size: 190,
//                       first_text: "Ear, Nose & Throat",
//                       second_text: "Health",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 40),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: 48,
//                 // width: 110,
//                 child: ElevatedButton(
//                   onPressed:
//                       loading
//                           ? null
//                           : () {
//                             if (interests.length > 1) {
//                               setState(() {
//                                 loading = true;
//                               });
//                               fire_follow_interests();
//                             } else {
//                               helperWidget.showSnackbar(
//                                 context,
//                                 "Select at least two interests",
//                               );
//                             }
//                           },
//                   style: ButtonStyle(
//                     padding: WidgetStateProperty.all<EdgeInsets>(
//                       EdgeInsets.zero,
//                     ),
//                     backgroundColor: WidgetStateProperty.all<Color>(
//                       Colors.white,
//                     ),
//                     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child:
//                         loading == true
//                             ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 color: primaryColor,
//                               ),
//                             )
//                             : Text(
//                               "Done",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: primaryColor,
//                               ),
//                             ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget draggableInterestWidget(Widget child) {
//     return LongPressDraggable(
//       childWhenDragging: Container(),
//       feedback: child,
//       child: child,
//     );
//   }

//   Widget interestWidget({
//     required String interest,
//     required String picture_name,
//     required double size,
//     required String first_text,
//     required String second_text,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         if (interests.contains(interest)) {
//           setState(() {
//             interests.remove(interest);
//           });
//         } else {
//           setState(() {
//             interests.add(interest);
//           });
//         }
//       },
//       child: Container(
//         height: size,
//         width: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2),
//           ],
//           border:
//               interests.contains(interest)
//                   ? Border.all(
//                     color: selectedInterestColor,
//                     width: 5,
//                     style: BorderStyle.solid,
//                   )
//                   : null,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   top: 0,
//                   left: 20,
//                   right: 20,
//                   bottom: 0,
//                 ),
//                 child: Image.asset("assets/$picture_name.png"),
//               ),
//             ),
//             Text(
//               first_text,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: primaryColor,
//               ),
//             ),
//             Text(
//               second_text,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: primaryColor,
//               ),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   fire_follow_interests() {
//     follow_interests(interest: interests)
//         .then((res) {
//           if (res['status'] == 'ok') {
//             getX.write(v.GETX_INTERESTS, res[db.DB_USER][db.DB_INTERESTS]);
//             Navigator.pushAndRemoveUntil(
//               context,
//               CupertinoPageRoute(builder: (_) => BottomNavBar()),
//               (route) => false,
//             );
//           } else {
//             helperWidget.showSnackbar(context, "An error occured");
//           }
//           setState(() {
//             loading = false;
//           });
//         })
//         .catchError((e) {
//           if (e is SocketException) {
//             helperWidget.showSnackbar(
//               context,
//               "Check your internet connection & try again",
//             );
//           } else {
//             helperWidget.showSnackbar(
//               context,
//               "A server error occured. Please try again",
//             );
//           }
//           setState(() {
//             loading = false;
//           });
//         });
//   }
// }
