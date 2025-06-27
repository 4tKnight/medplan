
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../utils/global.dart';
// import 'package:dio/dio.dart';


// // Future<dynamic> makePost(dynamic formData) async {
// //   Response response;
// //   Dio dio = Dio();

// //   response = await dio.post(
// //     "$dioBaseUrl/post/new_post",
// //     data: formData,
// //     options: Options(method: "POST", responseType: ResponseType.json, headers: {
// //       "Authorization": getX.read(v.TOKEN),
// //       "Content-Type": "multipart/form-data",
// //     }),
// //   );

// //   // print("returning response now");

// //   return response.data;
// // }

// // Future<dynamic> fetchGeneralPosts() async {
// //   http.Client client = http.Client();
// //   http.Response response = await client.post(Uri.https(httpBaseUrl, "/post/posts"),
// //       body: json.encode({
// //         db.TOKEN: getX.read(v.TOKEN),
// //         db.DB_PAGE_COUNT: 1,
// //       }),
// //       headers: {
// //         "Content-Type": "application/json"
// //       });

// //   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
// //   return decodedResponse;
// // }

// Future<dynamic> like_post(String postID) async {
//   print('----------:::-------> ${{
//     db.TOKEN: getX.read(v.TOKEN),
//     db.DB_POST_ID: postID,
//     db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//     db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//   }}');
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/cheer_post/like_post'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_POST_ID: postID,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_post(String postID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/cheer_post/unlike_post'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_POST_ID: postID,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> comment_on_post(String postID, String comment) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/comment_post/post'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//         db.DB_POST_ID: postID,
//         db.DB_COMMENT: comment,
//         db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//         db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//         db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetchRepliesApi(String commentID) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/reply_post/get_replies_post_comments'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//         db.DB_COMMENT_ID: commentID,
//         db.DB_POSITION: 0,
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> reply_comment_on_post(String postID, String commentID, String comment) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/reply_post/comment_reply'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_POST_ID: postID,
//       db.DB_COMMENT_ID: commentID,
//       db.DB_COMMENT: comment,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> like_post_comment(String commentID) async {
//   // print({
//   //   db.TOKEN: getX.read(v.TOKEN),
//   //   db.DB_COMMENT_ID: commentID,
//   //   db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//   //   db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//   // });
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/cheer_post/like_comment'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: commentID,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_post_comment(String commentID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/cheer_post/unlike_comment'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: commentID,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }
