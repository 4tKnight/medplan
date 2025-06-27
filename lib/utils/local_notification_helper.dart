// // ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/route_manager.dart';
// import 'package:medplan/db/sqflite_helper.dart';
// import 'package:medplan/main.dart';
// import 'package:medplan/models/payload_model.dart';
// import 'package:medplan/utils/global.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:intl/intl.dart';

// class LocalNotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//   final notification_sound = "notification_sound.mp3";

//   // final sound = "notification_sound.mp3";

//   static Future showNotification({required id, required String title, required String body, String? payload}) async {
//     // print('-----------------> $id $title $body $payload ');
//     _notifications.show(
//       id,
//       title,
//       body,
//       await _notificationDetails(),
//       payload: "payload",
//     );
//     // _notifications.periodicallyShow(id, title, body, repeatInterval, notificationDetails)
//     // print('>>>>>>>>>>>>>>>>>>>>>>> $payload ');
//   }

//   Future showCustomNotification(Map<String, dynamic> reminder) async {
//     // print('-----------------> $id $title $body $payload ');

//     String dose;
//     if (reminder["dosage_forms"] == constants.dosage_forms[2]) {
//       //syrup
//       dose = reminder["dosage_count"] + "ml";
//     } else if (reminder["dosage_forms"] == constants.dosage_forms[4] || reminder["dosage_forms"] == constants.dosage_forms[6]) {
//       //powder and inhaler
//       dose = reminder["dosage_count"] + "puffs";
//     } else {
//       dose = reminder["dosage_count"] + "mg";
//     }
//     String title = "It's time to take your ${reminder["med_name"]} $dose";
//     String body = "Take ${reminder["dosage_count"]} ${reminder["dosage_forms"].toLowerCase()} ${reminder["when_to_take"] == "None" ? "" : '${reminder["when_to_take"]!.toLowerCase()}'} - ${reminder["frequency"].split("-")[0]}";

//     //The complete payload we are working with is usually in Map<String, dynamic> format
//     //but the payload of the show() method receives a String?
//     //so we'd need to encode it to a String object using the next two lines
//     LocalNotificationPayload newPayload = LocalNotificationPayload(payload: convert_DateTime_In_ReminderObj_To_String(reminder));
//     String payloadJsonString = newPayload.toJsonString();

//     _notifications.show(
//       1,
//       title,
//       body,
//       await _notificationDetails(),
//       payload: payloadJsonString,
//     );
//     // _notifications.periodicallyShow(id, title, body, repeatInterval, notificationDetails)
//     // print('>>>>>>>>>>>>>>>>>>>>>>> $payload ');
//   }

//   List<int> makeIDs(double n) {
//     var rng = Random();
//     List<int> ids = [];
//     for (int i = 0; i < n; i++) {
//       ids.add(rng.nextInt(1000000000));
//     }
//     return ids;
//   }

//   Future<void> setNewPillReminder(Map<String, dynamic> reminder) async {
//     int intervalCount = reminder["interval_count"];
//     if (intervalCount == 2) {
//       await reminder2HoursApart(reminder);
//     } else if (intervalCount == 3) {
//       await reminder3HoursApart(reminder);
//     } else if (intervalCount == 4) {
//       await reminder4HoursApart(reminder);
//     } else if (intervalCount == 6) {
//       await reminder6HoursApart(reminder);
//     } else if (intervalCount == 8) {
//       await reminder8HoursApart(reminder);
//     } else if (intervalCount == 12) {
//       await reminder12HoursApart(reminder);
//     }

//     //storing a list of int and datetime can be problematic, so we need those fields as Strings instead
//     Map<String, dynamic> reminder_string = convert_DateTime_In_ReminderObj_To_String(reminder);
//     // reminder_string["_id"] = reminder["_id"];
//     // reminder_string["notificationIDs"] = reminder["notificationIDs"].toString();
//     // reminder_string["interval_count"] = reminder["interval_count"];
//     // reminder_string["dateTime"] = reminder["dateTime"].toString();
//     // reminder_string["endDateTime"] = reminder["endDateTime"].toString();
//     // reminder_string["med_name"] = reminder["med_name"];
//     // reminder_string["dosage_forms"] = reminder["dosage_forms"];
//     // reminder_string["dosage_count"] = reminder["dosage_count"];
//     // reminder_string["frequency"] = reminder["frequency"];
//     // reminder_string["when_to_take"] = reminder["when_to_take"];
//     // reminder_string["additional_note"] = reminder["additional_note"];
//     // reminder_string["time_taken"] = "";
//     // reminder_string["reason"] = "";
//     print('----------------->$reminder_string ');

//     List<dynamic> remindersGetXList = getXreminders.read(v.GETX_REMINDERS) ?? [];
//     remindersGetXList.add(reminder_string);
//     getXreminders.write(v.GETX_REMINDERS, remindersGetXList);

//     //!Error: PlatformException (PlatformException(sqlite_error, table reminder_table has no column named _id (code 1 SQLITE_ERROR[1]): , while compiling: INSERT INTO reminder_table (_id, notificationIDs, interval_count, dateTime, endDateTime, med_name, dosage_forms, dosage_count, frequency, when_to_take, additional_note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?), {arguments: [1680499056183, [257675331, 900644373, 230652017, 234152123, 897701120, 488827433, 601519205, 484920676], 3, 2023-04-03 06:06:00.000, , Ninja pills, Capsule, 3, 8 times a day - 3 hourly, After meal, ], sql: INSERT INTO reminder_table (_id, notificationIDs, interval_count, dateTime, endDateTime, med_name, dosage_forms, dosage_count, frequency, when_to_take, additional_note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}, null))
//     // int id = await ReminderDatabaseHelper.instance.insert(reminder_string);
//     // print('inserted row id: $id');
//   }

//   Map<String, dynamic> convert_DateTime_In_ReminderObj_To_String(Map<String, dynamic> reminder) {
//     Map<String, dynamic> reminder_string = {};
//     reminder_string["_id"] = reminder["_id"];
//     reminder_string["notificationIDs"] = reminder["notificationIDs"].toString();
//     reminder_string["interval_count"] = reminder["interval_count"];
//     reminder_string["dateTime"] = reminder["dateTime"].toString();
//     reminder_string["endDateTime"] = reminder["endDateTime"].toString();
//     reminder_string["med_name"] = reminder["med_name"];
//     reminder_string["dosage_forms"] = reminder["dosage_forms"];
//     reminder_string["dosage_count"] = reminder["dosage_count"];
//     reminder_string["frequency"] = reminder["frequency"];
//     reminder_string["when_to_take"] = reminder["when_to_take"];
//     reminder_string["additional_note"] = reminder["additional_note"];
//     reminder_string["time_taken"] = "";
//     reminder_string["reason"] = "";
//     return reminder_string;
//   }

//   // method to handle 2 hours selected
//   Future<void> reminder2HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 2)), notificationIDs[1]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 4)), notificationIDs[2]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 6)), notificationIDs[3]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 8)), notificationIDs[4]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 10)), notificationIDs[5]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 12)), notificationIDs[6]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 14)), notificationIDs[7]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 16)), notificationIDs[8]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 18)), notificationIDs[9]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 20)), notificationIDs[10]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 22)), notificationIDs[11]);
//   }

//   // method to handle 3 hours selected
//   Future<void> reminder3HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 3)), notificationIDs[1]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 6)), notificationIDs[2]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 9)), notificationIDs[3]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 12)), notificationIDs[4]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 15)), notificationIDs[5]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 18)), notificationIDs[6]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 21)), notificationIDs[7]);
//   }

//   // method to handle 4 hours selected
//   Future<void> reminder4HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 4)), notificationIDs[1]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 8)), notificationIDs[2]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 12)), notificationIDs[3]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 16)), notificationIDs[4]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 20)), notificationIDs[5]);
//   }

//   // method to handle 6 hours selected
//   Future<void> reminder6HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 6)), notificationIDs[1]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 12)), notificationIDs[2]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 18)), notificationIDs[3]);
//   }

//   // method to handle 8 hours selected
//   Future<void> reminder8HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 8)), notificationIDs[1]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 16)), notificationIDs[2]);
//   }

//   // method to handle 12 hours selected
//   Future<void> reminder12HoursApart(Map<String, dynamic> reminder) async {
//     DateTime startTime = reminder["dateTime"];
//     List<int> notificationIDs = reminder["notificationIDs"];

//     await _showDailyAtTime(reminder, startTime, notificationIDs[0]);

//     await _showDailyAtTime(reminder, startTime.add(Duration(hours: 12)), notificationIDs[1]);
//   }

//   Future<void> _showDailyAtTime(Map<String, dynamic> reminder, DateTime dateTime, int reminderId) async {
//     int hour = dateTime.hour;
//     int minute = dateTime.minute;

//     var time = Time(hour, minute, 0);

//     // it's time to take your Panadol 50mg
//     // Take 2 tablets after meal - 3 times a day.
//     // note***
//     // Syrup: ml
//     // For powder and inhaler: "puffs"

//     String dose;
//     if (reminder["dosage_forms"] == constants.dosage_forms[2]) {
//       //syrup
//       dose = reminder["dosage_count"] + "ml";
//     } else if (reminder["dosage_forms"] == constants.dosage_forms[4] || reminder["dosage_forms"] == constants.dosage_forms[6]) {
//       //powder and inhaler
//       dose = reminder["dosage_count"] + "puffs";
//     } else {
//       dose = reminder["dosage_count"] + "mg";
//     }

//     // String title = "${reminder["med_name"]} : Reminder set for ${reminder["frequency"]}";
//     String title = "It's time to take your ${reminder["med_name"]} $dose";
//     String body = "Take ${reminder["dosage_count"]} ${reminder["dosage_forms"].toLowerCase()} ${reminder["when_to_take"] == "None" ? "" : '${reminder["when_to_take"]!.toLowerCase()}'} - ${reminder["frequency"].split("-")[0]}";

//     //The complete payload we are working with is usually in Map<String, dynamic> format
//     //but the payload of the show() method receives a String?
//     //so we'd need to encode it to a String object using the next two lines
//     LocalNotificationPayload newPayload = LocalNotificationPayload(payload: convert_DateTime_In_ReminderObj_To_String(reminder));
//     String payloadJsonString = newPayload.toJsonString();

//     await _notifications.zonedSchedule(
//       reminderId,
//       title,
//       body,
//       nextInstanceOfTime(time),
//       await _notificationDetails(),
//       payload: payloadJsonString, //this payload will be passed to the "onSelectNotification"
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   tz.TZDateTime nextInstanceOfTime(Time time) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate.subtract(Duration(hours: 1)); //subtracting 1 hour because somehow the reminder gets set to 1 hour after by default
//   }

// //_____________________________________________________________

//   static Future _notificationDetails() async {
//     var vibrationPattern = Int64List(4);
//     vibrationPattern[0] = 0;
//     vibrationPattern[1] = 1000;
//     vibrationPattern[2] = 5000;
//     vibrationPattern[3] = 2000;

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'medPlan Pills',
//       'medPlan',
//       channelDescription: 'This handles all of your pill reminder notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound("alert"),
//       playSound: true,
//       ongoing: true,
//       autoCancel: true,
//       enableVibration: true,
//       vibrationPattern: vibrationPattern,
//       enableLights: true,
//       color: primaryColor,
//       ledColor: primaryColor,
//       ledOnMs: 1000,
//       ledOffMs: 500,
//       // icon: 'medplan_noti',
//       // sound: RawResourceAndroidNotificationSound('medplan_ringtone'),
//       // largeIcon: FilePathAndroidBitmap('app_icon'),
//       //      largeIconBitmapSource: BitmapSource.Drawable,
//     );
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: "medplan_ringtone.aiff");

//     return NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//   }

//   Future<void> setup() async {
//     const initSettings = InitializationSettings(
//       android: AndroidInitializationSettings('app_icon'),
//       iOS: IOSInitializationSettings(),
//     );
//     await _notifications.initialize(initSettings, onSelectNotification: (
//       String? payload,
//     ) async {
//       // Handle notification tap
//       Map<String, dynamic> noti_payload = LocalNotificationPayload.toLocalJsonObject(payload!);
//       noti_payload = noti_payload["payload"];

//       print('------------> FlutterLocalNotificationsPlugin tapped $payload');
//       // Get.to(() => MyMedicines(from_tapped_notification: true, payload: noti_payload));
//       Future.delayed(const Duration(milliseconds: 200)).then((_) {
//       // Future.delayed(Duration.zero).then((_) {
//         Get.to(() => MyMedicines(from_tapped_notification: true, payload: noti_payload));
//       });
//     }).then((_) {
//       print('FlutterLocalNotificationsPlugin setup success');
//     });
//   }

//   /// Request IOS permissions
//   // void requestIOSPermissions() {
//   //   _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
//   //         alert: true,
//   //         badge: true,
//   //         sound: true,
//   //       );
//   // }

//   static cancelAllLocalNotifications() async => await _notifications.cancelAll();
//   static cancelNotification(id) async => await _notifications.cancel(id);

// //____________________________________

//   static Future setContinousReminder({required id, required title, required body, String? payload}) async {
//     //! Ensure you store the id that you can use in cancelling this notification reminder, else you are in soup :)

//     DateTime now = DateTime.now();
//     print('>>>>>>>>>>>>>>>>>>>>>>> $now ');
//     int endTime = now.millisecondsSinceEpoch + 5000; //1670385268827 //this will schedule the notification for the next 5 secs

//     final tzdatetime = tz.TZDateTime.from(now, tz.local); //this converts the regular DateTime to TZDateTime cause TZDateTime is seemingly +1 hour ahead though still correct somehow
//     // print('>>>>>>>>>2>>>>>>>>>>>>>> $tzdatetime ');

//     tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime); //2022-12-07 03:54:28.827Z
//     // print('>>>>>>>>1>>>>>>>>>>>>>>> $scheduleTime ');

//     _notifications.periodicallyShow(
//       id,
//       title,
//       body,
//       // RepeatInterval.everyMinute,
//       RepeatInterval.daily,
//       await _notificationDetails(),
//       androidAllowWhileIdle: true,
//     );
//   }

// //_____________________________________________________________

//   // static Future setContinuosNotification({
//   //   required String title,
//   //   required String body,
//   //   required DateTime dateTime,
//   //   required String? frequency,
//   //   String? payload,
//   // }) async {
//   //   DateTime now = DateTime.now();

//   //   // int freq = 0;
//   //   int hour_interval = 0;

//   //   if (constants.frequencies[0] == frequency) {
//   //     hour_interval = 24;
//   //     // freq = 1;
//   //   } else if (constants.frequencies[1] == frequency) {
//   //     hour_interval = 12;
//   //     // freq = 2;
//   //   } else if (constants.frequencies[2] == frequency) {
//   //     hour_interval = 8;
//   //     // freq = 3;
//   //   } else if (constants.frequencies[3] == frequency) {
//   //     hour_interval = 6;
//   //     // freq = 4;
//   //   } else if (constants.frequencies[4] == frequency) {
//   //     hour_interval = 4;
//   //     // freq = 6;
//   //   } else if (constants.frequencies[5] == frequency) {
//   //     hour_interval = 3;
//   //     // freq = 8;
//   //   } else if (constants.frequencies[6] == frequency) {
//   //     hour_interval = 2;
//   //     // freq = 12;
//   //   }

//   //   List<int> id_list = []; //this will hold all the IDs for this reminder

//   //   //first reminder that's set for the specified time without yet adding intervals
//   //   int rand_id = randomNotifId();
//   //   setScheduledNotification(
//   //     body: body,
//   //     title: title,
//   //     // payload: payload,
//   //     id: rand_id,
//   //     dateTime: dateTime,
//   //   );
//   //   id_list.add(rand_id); //this is the first reminder thats not in the loop

//   //   print('>>>>>>>>>>>NOW>>>>>>>>>>>> $now ');
//   //   //this will handle for the other intervals
//   //   for (int i = hour_interval; i < 24; i += hour_interval) {
//   //     tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
//   //       tz.local,
//   //       dateTime.add(Duration(hours: i)).millisecondsSinceEpoch,

//   //       // dateTime.add(Duration(hours: hour_interval)).millisecondsSinceEpoch,
//   //     ); //2022-12-07 03:54:28.827Z

//   //     print('>>>>>>>scheduleTime>>>>$i>>>>>>>>>>>> $scheduleTime ');
//   //     final tzdatetime = tz.TZDateTime.from(now, tz.local); //this converts the regular DateTime to TZDateTime cause TZDateTime is seemingly +1 hour ahead though still correct somehow
//   //     print('>>>>>>>>tzdatetime>>>$i>>>>>>>>>>>> $tzdatetime \n\n');

//   //     int noti_id = randomNotifId();

//   //     _notifications.zonedSchedule(
//   //       noti_id,
//   //       title,
//   //       body,
//   //       scheduleTime,
//   //       await _notificationDetails(),
//   //       androidAllowWhileIdle: true,
//   //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//   //     );

//   //     id_list.add(noti_id);
//   //   }

//   //   //we'll be storing the IDs in a list of maps
//   //   //the maps will contain the general id to identify that particular reminder and then
//   //   //a list of the continous ID's which can be used to cancel the individual notifications
//   //   Map<String, dynamic> getXobj = {
//   //     "gen_id": now.millisecondsSinceEpoch,
//   //     "list_of_id": id_list,
//   //   };
//   //   List<dynamic> getXlist = getXreminders.read(v.GETX_REMINDERS) ?? [];
//   //   getXlist.add(getXobj);
//   //   getXreminders.write(v.GETX_REMINDERS, getXlist);

//   //   // if (dateTime.isBefore(now)) {
//   //   //   dateTime = dateTime.add(const Duration(days: 1));
//   //   //   print('---------_>Schedulate date .isBefore');
//   //   // }
//   // }

// //_____________________________________________________________

//   static int randomNotifId() {
//     Random objectname = Random();
//     int randomNotif = objectname.nextInt(10000000);

//     return randomNotif;
//   }

// //_____________________________________________________________

//   Future setScheduledNotification({required id, required title, required DateTime dateTime, required body, required Map<String, dynamic> med_reminder}) async {
//     tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, dateTime.millisecondsSinceEpoch); //2022-12-07 03:54:28.827Z

//     //The complete payload we are working with is usually in Map<String, dynamic> format
//     //but the payload of the show() method receives a String?
//     //so we'd need to encode it to a String object using the next two lines

//     LocalNotificationPayload newPayload = LocalNotificationPayload(payload: convert_DateTime_In_ReminderObj_To_String(med_reminder));
//     String payloadJsonString = newPayload.toJsonString();

//     // print('>>>>>>>>>>>>>>>>>>>>>>> $now ');
//     print('>>>>>>>>>>>>>>>>>>>>>>> $scheduleTime ');
//     final tzdatetime = tz.TZDateTime.from(scheduleTime, tz.local); //this converts the regular DateTime to TZDateTime cause TZDateTime is seemingly +1 hour ahead though still correct somehow
//     print('>>>>>>>>>>>>>>>>>>>>>>> $tzdatetime ');

//     _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tzdatetime,
//       await _notificationDetails(),
//       payload: payloadJsonString,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

// //_____________________________________________________________

// //let the continuos reminder be set for 365 days
// // do scheduled time .add(365 days)
//   static Future setHardcodedScheduledNotification({required id, required title, required body, String? payload}) async {
//     DateTime now = DateTime.now();

//     int duration = 60000 * 60 * 1; //60000 is 1min
//     int endTime = now.millisecondsSinceEpoch + duration; //1670385268827 //this will schedule the notification for the next 5 secs
//     tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime); //2022-12-07 03:54:28.827Z

//     print('>>>>>>>>>>>>>>>>>>>>>>> $now ');
//     print('>>>>>>>>>>>>>>>>>>>>>>> $scheduleTime ');
//     final tzdatetime = tz.TZDateTime.from(now, tz.local); //this converts the regular DateTime to TZDateTime cause TZDateTime is seemingly +1 hour ahead though still correct somehow
//     print('>>>>>>>>>>>>>>>>>>>>>>> $tzdatetime ');

//     _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduleTime,
//       await _notificationDetails(),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

// //_____________________________________________________________

//   static void set_scheduled_reminders({
//     required DateTime set_sch_time,
//     // required id,
//     required title,
//     required body,
//   }) async {
//     //add dateTime
//     final now = DateTime.now();
//     // final tzdatetime = tz.TZDateTime.from(now, tz.local); //this converts the regular DateTime to TZDateTime cause TZDateTime is seemingly +1 hour ahead though still correct somehow

//     //year,month,day, hour, min, sec
//     // DateTime set_sch_time = DateTime(2022, 12, 7, 11, 53, 20);
//     int endTime = set_sch_time.millisecondsSinceEpoch;
//     tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime); //2022-12-07 03:54:28.827Z

//     print('>>>>>>>>>>>>>>sch:>>>>>>>>> $set_sch_time ');
//     print('>>>>>>>>>>>>>now:>>>>>>>>>> $now ');

//     int diff_in_Hrs = set_sch_time.difference(now).inHours;
//     print('>>>>>>>>>>>>>>diff_in_Hrs>>>>>>>>> $diff_in_Hrs ');

//     while (diff_in_Hrs >= 4) {
//       //while the result is greater than 4 hours
//       //keep setting local notifications at (diff_in_Hrs ~/ 2) hours
//       diff_in_Hrs = diff_in_Hrs ~/ 2;
//       print('>>>>>>>>>>>>>>>>>>>>>>> $diff_in_Hrs ');

//       // if (diff_in_Hrs > 3) {
//       sub_dur_inHrs_and_set_local_notification(
//         id: DateTime.now().millisecondsSinceEpoch,
//         title: title,
//         body: body,
//         final_sch_time: scheduleTime,
//         sub_hrs: diff_in_Hrs,
//       ); //meaning it will keep notifying the delivery agent diff_in_Hrs/2 before the actual sch time
//       // }
//     }
//     //This would ensure that at least one local notification
//     //is set to notify the delivery agent 1 hour before that pick up delivery time whether or not the difference between the scheduled delivery time and current time is greater than 4 hours
//     sub_dur_inHrs_and_set_local_notification(
//       id: DateTime.now().millisecondsSinceEpoch,
//       title: title,
//       body: body,
//       final_sch_time: scheduleTime,
//       sub_hrs: 1,
//     );
//   }

//   static sub_dur_inHrs_and_set_local_notification({required id, required title, required body, required tz.TZDateTime final_sch_time, required int sub_hrs}) async {
//     DateTime dateTime_to_notify_user_before_scheduled_time = final_sch_time.subtract(Duration(hours: sub_hrs));
//     int milliS_time_to_notify_user_before_scheduled_time = dateTime_to_notify_user_before_scheduled_time.millisecondsSinceEpoch;

//     tz.TZDateTime reminder_sch_time = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, milliS_time_to_notify_user_before_scheduled_time);

//     await _notifications.zonedSchedule(
//       sub_hrs,
//       title,
//       body,
//       reminder_sch_time,
//       await _notificationDetails(),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

// //_____________________________________________________________

// }
