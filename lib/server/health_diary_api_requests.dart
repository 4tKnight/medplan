// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:medplan/main.dart';

// import '../utils/global.dart';


// Future<dynamic> save_diary_note(String mood, List<String> symptoms, String note, String color) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/note/save"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_MOOD: mood,
//       db.DB_SYMPTOMS: symptoms,
//       db.DB_NOTE: note,
//       db.DB_COLOR: color,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> edit_diary_note({required String noteID, required String mood, required List<String> symptoms, required String note, required String color}) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/note/edit"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_NOTE_ID: noteID,
//       db.DB_MOOD: mood,
//       db.DB_SYMPTOMS: symptoms,
//       db.DB_NOTE: note,
//       db.DB_COLOR: color,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> share_diary_note(bool showOwner, String message, List<String> tags) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/post/new_post"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_POST_OWNER_NAME: getX.read(v.GETX_FULLNAME),
//       db.DB_POST_OWNER_IMG: getX.read(v.GETX_USER_IMAGE),
//       db.DB_POST_OWNER_IMG_ID: getX.read(v.GETX_USER_IMAGE_ID),
//       db.DB_SHOW_OWNER: showOwner,
//       db.DB_MESSAGE: message,
//       db.DB_POST_TAGS: tags,
//       db.DB_POST_TYPE: "p_share",
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> fetch_diary_notes() async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/note/notes"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_PAGE_COUNT: 1,
//       db.DB_YEAR: DateTime.now().year,
//       db.DB_MONTH: DateTime.now().month,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> delete_diary_note(String noteID, int year, int month) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/note/delete"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_NOTE_ID: noteID,
//       db.DB_YEAR: year,
//       db.DB_MONTH: month,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }