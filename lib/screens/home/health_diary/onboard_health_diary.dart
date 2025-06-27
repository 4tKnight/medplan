// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

// import 'add_health_diary.dart';
// import 'my_health_diary.dart';

// class OnBoardHealthDiary extends StatefulWidget {
//   const OnBoardHealthDiary({Key? key}) : super(key: key);
//   @override
//   OnBoardHealthDiaryState createState() => OnBoardHealthDiaryState();
// }

// class OnBoardHealthDiaryState extends State<OnBoardHealthDiary> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           elevation: 0,
//           title: const Text('Health Diary',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               )),
//           centerTitle: true,
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const CreateDiary()));
//                 },
//                 child: Container(
//                   height: 24,
//                   width: 24,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           )),
//       body: noHealthDiaryWidget(),
//     );
//   }

//   Widget noHealthDiaryWidget() {
//     return ListView(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         noHealthDiaryAsset(),
//         const SizedBox(
//           height: 35,
//         ),
//         const Text(
//           '''
// Control your mood and activities with medPlan Health Diary.

// Document side effects from medications, symptoms etc.

// Easily share diary records with Care givers and loved ones.
// ''',
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(
//           height: 50,
//         ),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (_) => MyHealthDiary()));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6.0),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
//             ),
//             child: const Text(
//               'Get Started',
//               style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }

//   Stack noHealthDiaryAsset() {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 9.0, left: 6),
//           child: Image.asset(
//             "assets/hd1.png",
//             fit: BoxFit.cover,
//             // height: 0,
//             // width: 0,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 55.0),
//           child: Image.asset(
//             "assets/hd2.png",
//             fit: BoxFit.cover,
//             // height: 0,
//             // width: 0,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 150.0, right: 9, left: 6),
//           child: Container(
//               height: 195,
//               width: double.maxFinite,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFFAC66F2),
//                     Color(0xFF57307E),
//                   ],
//                   stops: [0.064, 0.7489],
//                   transform: GradientRotation(123.7 * 3.1415927 / 180),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const Text(
//                     'How are you feeling today?',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         'Today, ${DateFormat('MMMM d, y').format(DateTime.now())}   ${DateFormat('h:mma').format(DateTime.now())}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Column(
//                           children: [
//                             Image.asset(
//                               "assets/smiley1.png",
//                               fit: BoxFit.cover,
//                               height: 35,
//                               width: 35,
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const Text(
//                               'Happy',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Image.asset(
//                               "assets/smiley6.png",
//                               fit: BoxFit.cover,
//                               height: 35,
//                               width: 35,
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const Text(
//                               'Unwell',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Image.asset(
//                               "assets/smiley8.png",
//                               fit: BoxFit.cover,
//                               height: 35,
//                               width: 35,
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const Text(
//                               'Feverish',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Image.asset(
//                               "assets/smiley10.png",
//                               fit: BoxFit.cover,
//                               height: 35,
//                               width: 35,
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const Text(
//                               'Nauseous',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ])
//                 ],
//               )),
//         ),
//       ],
//     );
//   }
// }
