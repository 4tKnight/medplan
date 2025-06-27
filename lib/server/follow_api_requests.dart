// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../utils/global.dart';




// Future<dynamic> follow_user(String userID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/follow/follow"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "following_id": userID,
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

// Future<dynamic> unfollow_user(String userID) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/follow/unfollow"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "following_id": userID,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> follow_single_interests(String interest) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/interests/follow_one"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "interest": interest,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> unfollow_single_interests(String interest) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/interests/unfollow_one"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       "interest": interest,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> follow_interests({required List<String> interest}) async {
//   http.Client client = http.Client();
//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, "/interests/follow_many"),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_INTERESTS: interest,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }
