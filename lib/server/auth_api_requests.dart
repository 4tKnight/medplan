// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../utils/global.dart';



// Future<dynamic> storeDeviceToken(String deviceToken) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/profile/set_device_token'),
//     body: json.encode({
//       db.TOKEN: getX.read(v.TOKEN),
//       db.DB_DEVICE_TOKEN: deviceToken,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> createUserAccount(String email, String password) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(
//     Uri.https(httpBaseUrl, '/auth/signup'),
//     body: json.encode({
//       "email": email,
//       "password": password,
//     }),
//     headers: {
//       "Content-Type": "application/json"
//     },
//   );

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<dynamic> loginUserAccount(String email, String password) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/auth/login'),
//       body: json.encode({
//         "email": email,
//         "password": password
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }


// Future<dynamic> forgotPassword(String email) async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/auth/forgotpassword'),
//       body: json.encode({
//         "email": email,
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   return decodedResponse;
// }

// Future<void> setUserFollowingsArray() async {
//   http.Client client = http.Client();

//   http.Response response = await client.post(Uri.https(httpBaseUrl, '/profile/user_followings'),
//       body: json.encode({
//         db.TOKEN: getX.read(v.TOKEN),
//       }),
//       headers: {
//         "Content-Type": "application/json"
//       });

//   dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

//   if (decodedResponse['msg'] == "Success") {
//     getX.write(v.FOLLOWINGS, decodedResponse[v.FOLLOWINGS]);
//   }
// }