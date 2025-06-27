// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../utils/global.dart';


// //health tip
// Future<dynamic> increase_health_tip_views(String health_tipID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/health_tip/inc_view"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_HEALTH_TIP_ID: health_tipID,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   // print('--------increase--------->$decodedResponse ');
//   return decodedResponse;
// }

// Future<dynamic> get_health_tips_comments(String health_tipID, {int position = 0}) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/health_tip/get_comments'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//         db.DB_HEALTH_TIP_ID: health_tipID,
//         db.DB_POSITION: position,
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   // print('--------||comments inside---------> $decodedResponse');
//   return decodedResponse;
// }

// Future<dynamic> comment_on_health_tip(String healthtip_id, String comment) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/health_tip/comment'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//         db.DB_COMMENT: comment,
//         db.DB_HEALTH_TIP_ID: healthtip_id,
//         db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//         db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//         db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// //VIDEO TIPS
// Future<dynamic> increase_video_tip_views(String video_tipID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/video_tip/inc_view"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_VIDEO_TIP_ID: video_tipID,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   // print('----------------->$decodedResponse ');

//   return decodedResponse;
// }

// Future<dynamic> get_video_tips_comments(String video_tipID,
//     {int position = 0}) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/comment_vtip/get_comments'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_VIDEO_TIP_ID: video_tipID,
//       db.DB_POSITION: position,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> comment_on_video_tip(String videotip_id, String comment) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/comment_vtip/comment'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT: comment,
//       db.DB_VIDEO_TIP_ID: videotip_id,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> get_video_tips([String search = ""]) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/video_tip/get"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_SEARCH_STRING: search,
//       db.DB_PAGE_COUNT: 1,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> like_video_tips(String videotip_id) async {
//   print('----------------->${{
//     db.TOKEN: getX.read(v.TOKEN),
//     db.DB_VIDEO_TIP_ID: videotip_id,
//     db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//   }} ');
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/like_vtip/like_videotip"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_VIDEO_TIP_ID: videotip_id,
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_video_tips(String videotip_id) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/like_vtip/unlike_videotip"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_VIDEO_TIP_ID: videotip_id,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> like_video_tips_comment(String video_comment_id) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/like_vtip/like_videotip_comment"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: video_comment_id,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_video_tips_comment(String video_comment_id) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/like_vtip/unlike_videotip_comment"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: video_comment_id,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetch_video_tips_replies(String commentID) async {
//   http.Client client = http.Client();

//   http.Response response = await client
//       .post(Uri.https(httpBaseUrl, '/reply_vtip/get_replies_videotip_comments'),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_COMMENT_ID: commentID,
//             db.DB_POSITION: 0,
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> reply_comment_on_video_tips(
//     {required String videoTipsID,
//     required String commentID,
//     required String comment}) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/reply_vtip/comment_reply'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "video_tip_id": videoTipsID,
//       db.DB_COMMENT_ID: commentID,
//       db.DB_COMMENT: comment,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// //

// Future<dynamic> fetchHealthTips() async {
//   http.Client client = http.Client();
//   http.Response response =
//       await client.post(Uri.https(httpBaseUrl, "/health_tip/get"),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_CATEGORY: "health",
//             db.DB_PAGE_COUNT: 1,
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetchRecentHealthTips() async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/health_tip/recent"),
//     body: json.encode({db.TOKEN: getX.read(v.TOKEN)}),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> like_health_tips(String healthtip_id) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/like_htip/like_healthtip'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_HEALTH_TIP_ID: healthtip_id,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_health_tips(String healthtip_id) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/like_htip/unlike_healthtip'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_HEALTH_TIP_ID: healthtip_id,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> like_health_tips_comments(String commentID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/like_htip/like_healthtip_comment'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: commentID,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unlike_health_tips_comments(String commentID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/like_htip/unlike_healthtip_comment'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_COMMENT_ID: commentID,
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetchHealthTipRepliesApi(String commentID) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(
//       Uri.https(httpBaseUrl, '/reply_htip/get_replies_healthtip_comments'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//         db.DB_COMMENT_ID: commentID,
//         db.DB_POSITION: 0,
//       }),
//       headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> reply_comment_on_health_tips(
//     {required String healthTipsID,
//     required String commentID,
//     required String comment}) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/reply_htip/comment_reply'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "health_tip_id": healthTipsID,
//       db.DB_COMMENT_ID: commentID,
//       db.DB_COMMENT: comment,
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//     }),
//     headers: {"Content-Type": "application/json"},
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> comment_on_health_tips(
//     String healthtip_id, String comment) async {
//   http.Client client = http.Client();
//   http.Response response =
//       await client.post(Uri.https(httpBaseUrl, '/comment_htip/comment'),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_HEALTH_TIP_ID: healthtip_id,
//             db.DB_COMMENT: comment,
//             db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//             db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//             db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetch_health_tips_comments_api(String healthtip_id) async {
//   http.Client client = http.Client();

//   http.Response response =
//       await client.post(Uri.https(httpBaseUrl, '/comment_htip/get_comments'),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_HEALTH_TIP_ID: healthtip_id,
//             db.DB_POSITION: 0,
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> searchHealthTips({String search = ''}) async {
//   http.Client client = http.Client();
//   http.Response response =
//       await client.post(Uri.https(httpBaseUrl, '/health_tip/search'),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_SEARCH_STRING: search,
//             db.DB_PAGE_COUNT: 1,
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetchCommentsApi(String postID) async {
//   http.Client client = http.Client();

//   http.Response response =
//       await client.post(Uri.https(httpBaseUrl, '/comment_post/get_comments'),
//           body: json.encode({
//             db.TOKEN: getX.read(v.TOKEN),
//             db.DB_POST_ID: postID,
//             db.DB_POSITION: 0,
//           }),
//           headers: {"Content-Type": "application/json"});

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }
