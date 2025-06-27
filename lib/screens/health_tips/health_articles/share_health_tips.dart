// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:medplan/utils/color.dart';
// import 'package:medplan/utils/global.dart';
// import 'package:dio/dio.dart' as dio;

// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

// import '../../../server/posts_api_requests.dart';

// class ShareHealthTips extends StatefulWidget {
//   dynamic health_tips_data;
//   ShareHealthTips({Key? key, required this.health_tips_data}) : super(key: key);

//   @override
//   ShareHealthTipsState createState() => ShareHealthTipsState();
// }

// class ShareHealthTipsState extends State<ShareHealthTips> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     messageController.text =
//         "${widget.health_tips_data[db.DB_TITLE]}\n${widget.health_tips_data["body"]}";
//     _fileFromImageUrl("${widget.health_tips_data["img"]}").then((value) {
//       readyUploadImages.add(value);
//       setState(() {});
//     });
//   }

//   String selection = constants.category[0];
//   String post_selection = constants.post_category[0];
//   // List<String> selected_tags = <String>[];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: helperWidget.myAppBar(context, ""),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.only(bottom: 40.0),
//               physics: BouncingScrollPhysics(),
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
//                   child: Row(
//                     // crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       helperWidget.buildProfilePicture(
//                           "${getX.read(v.GETX_USER_IMAGE)}", 20),
//                       // helperWidget.buildProfilePicture(getX.read(constants.GETX_USER_IMAGE), 20),
//                       const SizedBox(width: 10),

//                       Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               color: primaryColor),
//                           child: Padding(
//                             padding: const EdgeInsets.all(1.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color:
//                                     Theme.of(context).scaffoldBackgroundColor,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(8, 1, 3, 1),
//                                 child: DropdownButton(
//                                   icon: Icon(Icons.arrow_drop_down,
//                                       size: 20, color: primaryColor),
//                                   isDense: true,
//                                   underline: const SizedBox(),
//                                   // isExpanded: true,
//                                   value: selection,
//                                   items:
//                                       constants.category.map((dynamic value) {
//                                     return DropdownMenuItem<dynamic>(
//                                       value: value,
//                                       child: Text(
//                                         "$value",
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
                                
//                                       ),
//                                     );
//                                   }).toList(),
//                                   onChanged: (dynamic val) {
//                                     FocusScope.of(context)
//                                         .requestFocus(FocusNode());
//                                     setState(() {
//                                       selection = val;
//                                     });
//                                     print(selection);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       Spacer(),

//                       sendingPost
//                           ? Padding(
//                               padding: const EdgeInsets.only(right: 15),
//                               child: SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                     color: MyColor.myColor),
//                               ),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.only(right: 15),
//                               child: TextButton(
//                                 child: Text(
//                                   "SHARE",
//                                   style: TextStyle(
//                                    ),
//                                 ),
//                                 // style: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.black))),
//                                 onPressed: () async {
//                                   // if (selected_tags.length<1) {
//                                   //   helperWidget.showSnackbar(context, "You must select at least one post tag");
//                                   //   // helperWidget.showSnackbar(context, "You must select at least one picture");
//                                   // } else {
//                                   setState(() {
//                                     sendingPost = true;
//                                   });

//                                   var formData = dio.FormData.fromMap({
//                                     db.TOKEN: getX.read(v.TOKEN),
//                                     db.DB_POST_OWNER_NAME:
//                                         getX.read(v.GETX_FULLNAME),
//                                     db.DB_POST_OWNER_IMG:
//                                         getX.read(v.GETX_USER_IMAGE),
//                                     db.DB_POST_OWNER_IMG_ID:
//                                         getX.read(v.GETX_USER_IMAGE_ID),
//                                     // "owner_img_id": getX.read(v.GETX_USER_IMAGE_ID),
//                                     db.DB_SHOW_OWNER:
//                                         selection == constants.category[0]
//                                             ? true
//                                             : false,
//                                     db.DB_MESSAGE: messageController.text,
//                                     db.DB_POST_TAGS: ['healthtip'],
//                                     db.DB_POST_TYPE: "post",
//                                   });

//                                   print(formData.fields);

//                                   sendFormData(formData, context);
//                                   // }
//                                 },
//                               ),
//                             )

//                       // SizedBox(
//                       //     height: 50,
//                       //     child: ListView.builder(
//                       //       itemCount: category.length,
//                       //       scrollDirection: Axis.horizontal,
//                       //       itemBuilder: (BuildContext context, int index) {
//                       //         return filterWidget(index, category[index], () {
//                       //           setState(() {
//                       //             selectedIndex = index;
//                       //           });
//                       //         });
//                       //       },
//                       //     ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                   child: TextField(
//                     controller: messageController,
//                     // onChanged: (val) {
//                     //   message = val;
//                     // },
//                     textInputAction: TextInputAction.newline,
//                     textCapitalization: TextCapitalization.sentences,
//                     maxLines: 15,
//                     maxLength: 5000,
//                     // style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w400, fontSize: 14),
//                     // enabled: loadingState == 0 ? true : false,
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       fillColor: Color.fromRGBO(196, 196, 196, 0.2),
//                       filled: true,
//                       hintText: 'Start typing here...',
//                       hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                       border: OutlineInputBorder(borderSide: BorderSide.none),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 build_grid_local_images(context, readyUploadImagesCount),

//                 // Wrap(
//                 //   alignment: WrapAlignment.center,
//                 //   children: [
//                 //     showImage(1, 0),
//                 //     showImage(2, 1),
//                 //     showImage(3, 2),
//                 //     showImage(4, 3),
//                 //     showImage(5, 4),
//                 //     showImage(6, 5),
//                 //     showImage(7, 6),
//                 //     showImage(8, 7),
//                 //     showImage(9, 8),
//                 //     showImage(10, 9),
//                 //     readyUploadImagesCount == 10
//                 //         ? const Padding(
//                 //             padding: EdgeInsets.all(6.0),
//                 //             child: SizedBox(
//                 //               width: 80.0,
//                 //               height: 80.0,
//                 //               child: Icon(Icons.check_circle, color: Colors.green),
//                 //               // color: Colors.grey[300],
//                 //             ))
//                 //         : SizedBox()
//                 //   ],
//                 // ),
//                 const SizedBox(height: 20),
//                 Column(
//                   children: [
//                     // GestureDetector(
//                     //   onTap:(){
//                     //     getImage();
//                     //   },
//                     //   child: Row(
//                     //     children: [
//                     //       Container(height: 25, width: 25, child: Image.asset("./assets/image.png")),
//                     //       SizedBox(width: 10),
//                     //       Text("Camera",style: TextStyle(color: Colors.black87 ,fontFamily: "Poppins", fontWeight: FontWeight.w300, fontSize: 14),)
//                     //     ],
//                     //   ),
//                     // ),

//                     // SizedBox(height: 12),
//                     // GestureDetector(
//                     //   onTap:(){

//                     //   },
//                     //   child: Row(
//                     //     children: [
//                     //       Container(height: 25, width: 25, child: Image.asset("./assets/vc.png")),
//                     //       SizedBox(width: 10),
//                     //       Text("Add Video",style: TextStyle(color: Colors.black87 ,fontFamily: "Poppins", fontWeight: FontWeight.w300, fontSize: 14),)
//                     //     ],
//                     //   ),
//                     // ),
//                     // SizedBox(height: 12),
//                     // GestureDetector(
//                     //   onTap:(){

//                     //   },
//                     //   child: Row(
//                     //     children: [
//                     //       Container(height: 25, width: 25, child: Image.asset("./assets/document.png")),
//                     //       SizedBox(width: 10),
//                     //       Text("Add Document",style: TextStyle(color: Colors.black87 ,fontFamily: "Poppins", fontWeight: FontWeight.w300, fontSize: 14),)
//                     //     ],
//                     //   ),
//                     // ),
//                     SizedBox(height: 12),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 6.0, top: 5),
//             child: GestureDetector(
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset("./assets/add_image.png",
//                         height: 25, width: 25),
//                     Text(
//                       "Add Photo/Image",
//                       style:
//                           TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//               onTap: () {
//                 getImage();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<File> _fileFromImageUrl(String url) async {
//     final response = await http.get(Uri.parse(url));

//     final tempDirectory = await getTemporaryDirectory();

//     final String imageName = url.split('/').last;

//     final file = File(join(tempDirectory.path, imageName));
//     file.writeAsBytesSync(response.bodyBytes);
//     return file;
//   }

//   TextEditingController messageController = TextEditingController();

//   sendFormData(var formData, BuildContext context) async {
//     // ADD IMAGE TO UPLOAD
//     // print('>>>>>>>>>>>>>>>>>>>>>>> GOTTEN $imagesToUpload ');

//     for (int i = 0; i < readyUploadImages.length; i++) {
//       String fileName = readyUploadImages[i].path.split("/").last;
//       String image_ext = fileName.split(".").last;

//       var file = await dio.MultipartFile.fromFile(
//         readyUploadImages[i].path,
//         filename: fileName,
//         contentType: MediaType("image", image_ext),
//       );
//       formData.files.add(MapEntry('post_imgs', file));
//     }

//     print(readyUploadImages);
//     print("making post now");

//     makePost(formData).then((res) {
//       print('>>>>>>>>>>>>>>>>>>>>>>FINISHED POST RETURNED: $res ');

//       if (res["msg"] == "Post successful") {
//         helperWidget.showSnackbar(context, "Your post has been made");

//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => BottomAppBar()));
//       } else {
//         helperWidget.showSnackbar(context, "An error occured");
//         setState(() {
//           sendingPost = false;
//         });
//       }
//     }).catchError((e) {
//       if (e is SocketException) {
//         print('>>>>>>>>>>>>>>>>>>>>>>> NO INTERNET CONNECTION ');
//         helperWidget.showSnackbar(
//             context, "Check your internet connection & try again");
//       } else {
//         helperWidget.showSnackbar(context, "A server error occured");
//       }
//       print('>>>>>>>>>>>>>>>>>>>>>>> TRY-CATCH ERROR: $e');
//       setState(() {
//         sendingPost = false;
//       });
//     });
//   }

//   int readyUploadImagesCount = 0;
//   List<File> readyUploadImages = [];

//   getImage() {
//     ImagePicker().pickMultiImage().then((selectedImages) {
//       if (selectedImages == null) {
//         print('>>>>>>>>>>>>>>>>>>>>>>> NOTHING PICKED ');
//       } else if (selectedImages.isNotEmpty) {
//         int temp =
//             readyUploadImagesCount; //this temp variable will help to hold the previous value of readyUploadImagesCount, so that in case the images exceed 10, you can still keep checking with a valid number of the actual number of items in the list
//         readyUploadImagesCount += selectedImages.length;

//         if (readyUploadImagesCount > 10) {
//           readyUploadImagesCount = temp;
//           // print("$readyUploadImagesCount HIGHER THAN THE NUMBER");

//           // helperWidget.showSnackbar(context, "Max of 10 images allowed");
//         } else {
//           // readyUploadImages.addAll(selectedImages);
//           selectedImages.forEach((file) {
//             setState(() {
//               readyUploadImages.add(File(file.path));
//               print(readyUploadImages);
//             });
//           });
//           // print(readyUploadImages.length);
//         }
//       } else {
//         print("nothing was selected");
//       }
//     });
//   }

//   build_grid_local_images(BuildContext context, int listLength) {
//     if (readyUploadImages.isEmpty) {
//       return SizedBox();
//     } else {
//       return Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               color: Colors.grey[200],
//               child: Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           //! fix the xfile issue on this page
//                           //was having a class whilst fixing this, so there was no time to spend on it
//                           // Navigator.push(context, MaterialPageRoute(builder: (_) => View_Local_Post_Images(readyUploadImages)));
//                         },
//                         child: build_grid(context, readyUploadImages),
//                       ),
//                       Positioned(
//                         top: 2,
//                         right: 2,
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               readyUploadImagesCount = 0;
//                               readyUploadImages.clear();
//                             });
//                           },
//                           child: CircleAvatar(
//                             radius: 15,
//                             child: Icon(Icons.clear, color: Colors.white),
//                             backgroundColor: Colors.black45,
//                           ),
//                         ),
//                       ),
//                       readyUploadImages.length < 5
//                           ? SizedBox()
//                           : Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 color: Colors.black45,
//                                 height: 50,
//                                 width: 50,
//                                 alignment: Alignment.center,
//                                 child: Text("+${readyUploadImages.length - 4}",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 16)),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }

//   Widget build_grid(BuildContext context, List<File> selectedImages) {
//     return FlutterLogo();
//     // if (selectedImages.length == 1) {
//     //   return AspectRatio(
//     //     aspectRatio: 16.0 / 9.0,
//     //     // aspectRatio: 4.0 / 3.0,
//     //     child: build_local_image(context, selectedImages[0]),
//     //   );
//     // } else if (selectedImages.length == 2) {
//     //   return GridView.custom(
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     gridDelegate: SliverQuiltedGridDelegate(
//     //       crossAxisCount: 4,
//     //       mainAxisSpacing: 4,
//     //       crossAxisSpacing: 6,
//     //       pattern: const [
//     //         QuiltedGridTile(2, 2),
//     //         QuiltedGridTile(2, 2),
//     //       ],
//     //     ),
//     //     childrenDelegate: SliverChildBuilderDelegate(
//     //       (context, index) {
//     //         return build_local_image(context, selectedImages[index]);
//     //       },
//     //       childCount: 2,
//     //     ),
//     //   );
//     // } else if (selectedImages.length == 3) {
//     //   return GridView.custom(
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     gridDelegate: SliverQuiltedGridDelegate(
//     //       crossAxisCount: 4,
//     //       mainAxisSpacing: 6,
//     //       crossAxisSpacing: 6,
//     //       repeatPattern: QuiltedGridRepeatPattern.inverted,
//     //       pattern: const [
//     //         QuiltedGridTile(2, 2),
//     //         QuiltedGridTile(1, 2),
//     //         QuiltedGridTile(1, 2),
//     //       ],
//     //     ),
//     //     childrenDelegate: SliverChildBuilderDelegate(
//     //       (context, index) {
//     //         return build_local_image(context, selectedImages[index]);
//     //       },
//     //       childCount: 3,
//     //     ),
//     //   );
//     // } else if (selectedImages.length == 4) {
//     //   return GridView.custom(
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     gridDelegate: SliverQuiltedGridDelegate(
//     //       crossAxisCount: 4,
//     //       mainAxisSpacing: 6,
//     //       crossAxisSpacing: 6,
//     //       repeatPattern: QuiltedGridRepeatPattern.inverted,
//     //       pattern: const [
//     //         QuiltedGridTile(2, 2),
//     //         QuiltedGridTile(1, 1),
//     //         QuiltedGridTile(1, 1),
//     //         QuiltedGridTile(1, 2),
//     //       ],
//     //     ),
//     //     childrenDelegate: SliverChildBuilderDelegate(
//     //       (context, index) {
//     //         return build_local_image(context, selectedImages[index]);
//     //       },
//     //       childCount: 4,
//     //     ),
//     //   );
//     // } else {
//     //   return GridView.custom(
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     gridDelegate: SliverQuiltedGridDelegate(
//     //       crossAxisCount: 4,
//     //       mainAxisSpacing: 2,
//     //       crossAxisSpacing: 2,
//     //       repeatPattern: QuiltedGridRepeatPattern.inverted,
//     //       pattern: const [
//     //         QuiltedGridTile(2, 2),
//     //         QuiltedGridTile(1, 1),
//     //         QuiltedGridTile(1, 1),
//     //         QuiltedGridTile(1, 2),
//     //       ],
//     //     ),
//     //     childrenDelegate: SliverChildBuilderDelegate(
//     //       (context, index) {
//     //         return build_local_image(context, selectedImages[index]);
//     //       },
//     //       childCount: 4,
//     //     ),
//     //   );
//     // }
//   }

//   build_local_image(BuildContext context, File file_index) {
//     return Image.file(
//       File(file_index.path),
//       width: 80.0,
//       height: 80.0,
//       fit: BoxFit.cover,
//     );
//   }

//   bool sendingPost = false;

//   InputDecoration myDeco = const InputDecoration(
//     isDense: true,
//     fillColor: Color.fromRGBO(196, 196, 196, 0.2),
//     filled: true,
//     hintText: 'Type here',
//     hintStyle: TextStyle(fontWeight: FontWeight.w300),
//     border: OutlineInputBorder(borderSide: BorderSide.none),
//   );

//   int selectedIndex = 1;
// }
