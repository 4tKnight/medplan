import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medplan/screens/medicines/medication_reminder/alarm_notification_page.dart';
import 'package:medplan/utils/functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import 'global.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'dart:convert';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.data,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final Map<String, dynamic>? data;
}

class LocalNotificationHelper {
  /// A notification action which triggers a App navigation event
  String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  String darwinNotificationCategoryPlain = 'plainCategory';

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    my_log(
      'notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}',
    );
    if (notificationResponse.input?.isNotEmpty ?? false) {
      my_log(
        'notification action tapped with input: ${notificationResponse.input}',
      );
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
          DarwinNotificationCategory(
            darwinNotificationCategoryText,
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.text(
                'text_1',
                'Action 1',
                buttonTitle: 'Send',
                placeholder: 'Placeholder',
              ),
            ],
          ),
          DarwinNotificationCategory(
            darwinNotificationCategoryPlain,
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('id_1', 'Action 1'),
              DarwinNotificationAction.plain(
                'id_2',
                'Action 2 (destructive)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.destructive,
                },
              ),
              DarwinNotificationAction.plain(
                navigationActionId,
                'Action 3 (foreground)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground,
                },
              ),
              DarwinNotificationAction.plain(
                'id_4',
                'Action 4 (auth required)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.authenticationRequired,
                },
              ),
            ],
            options: <DarwinNotificationCategoryOption>{
              DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
          ),
        ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: darwinNotificationCategories,
        );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        my_log('onDidReceiveNotificationResponse: ${details.payload}');
        await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder:
                (context) => AlarmNotificationPage(
                  reminderData: stringToMap(details.payload.toString()),
                ),
          ),
        );
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
      my_log(
        'notificationAppLaunchDetails: ${notificationAppLaunchDetails.notificationResponse?.payload}',
      );
      await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (context) => AlarmNotificationPage(
                reminderData: stringToMap(
                  notificationAppLaunchDetails.notificationResponse!.payload
                      .toString(),
                ),
              ),
        ),
      );
    }
  }

  NotificationDetails _notificationDetails() {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'MedPlan Pills',
          'MedPlan',
          channelDescription:
              'This handles all of your pill reminder notifications',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: false,
          // sound: RawResourceAndroidNotificationSound("alert"),
          playSound: true,
          ongoing: true,
          autoCancel: true,
          enableVibration: true,
          vibrationPattern: vibrationPattern,
          enableLights: true,
          color: primaryColor,
          ledColor: primaryColor,
          ledOnMs: 1000,
          ledOffMs: 500,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          // categoryIdentifier: darwinNotificationCategoryPlain,
        );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  Future<void> showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Hello, World!',
      'This is a local notification.',
      _notificationDetails(),
      payload: 'item x',
    );
  }

  Future<void> scheduleNotification() async {
    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: 10));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This notification was scheduled to appear after 10 seconds.',
      scheduledTime,
      _notificationDetails(),
      payload: 'scheduled_notification',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> setNewPillReminder(Map<String, dynamic> reminderData) async {
    int intervalCount = reminderData["interval_count"];

    my_log(reminderData['duration']);

    for (var i = 0; i < reminderData['duration']; i++) {
      my_log('interation:$i');

      if (reminderData['start_reminder_date_time'] is String) {
        reminderData['start_reminder_date_time'] = DateTime.parse(
          reminderData['start_reminder_date_time'],
        );
      }
      if (intervalCount == 4) {
        await reminder4HoursApart(reminderData, i);
      } else if (intervalCount == 6) {
        await reminder6HoursApart(reminderData, i);
      } else if (intervalCount == 8) {
        await reminder8HoursApart(reminderData, i);
      } else if (intervalCount == 12) {
        await reminder12HoursApart(reminderData, i);
      } else {
        await reminder24HoursApart(reminderData, i);
      }
    }
  }

  // method to handle 4 hours selected
  Future<void> reminder4HoursApart(
    Map<String, dynamic> reminderData,
    int day,
  ) async {
    my_log('day:$day');
    DateTime startTime = reminderData["start_reminder_date_time"];
    List<int> notificationIDs = reminderData["notification_ids"];

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(days: day)),
      notificationIDs[0],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 4, days: day)),

      // startTime.add(Duration(minutes: 2, days: day)),
      notificationIDs[1],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 8, days: day)),

      // startTime.add(Duration(minutes: 4, days: day)),
      notificationIDs[2],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 12, days: day)),

      // startTime.add(Duration(minutes: 6, days: day)),
      notificationIDs[3],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 16, days: day)),

      // startTime.add(Duration(minutes: 8, days: day)),
      notificationIDs[4],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 20, days: day)),

      // startTime.add(Duration(minutes: 10, days: day)),
      notificationIDs[5],
    );
  }

  // method to handle 6 hours selected
  Future<void> reminder6HoursApart(
    Map<String, dynamic> reminderData,
    int day,
  ) async {
    DateTime startTime = reminderData["start_reminder_date_time"];
    List<int> notificationIDs = reminderData["notification_ids"];

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(days: day)),
      notificationIDs[0],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 6, days: day)),
      notificationIDs[1],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 12, days: day)),
      notificationIDs[2],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 18, days: day)),
      notificationIDs[3],
    );
  }

  // method to handle 8 hours selected
  Future<void> reminder8HoursApart(
    Map<String, dynamic> reminderData,
    int day,
  ) async {
    DateTime startTime = reminderData["start_reminder_date_time"];
    List<int> notificationIDs = reminderData["notification_ids"];

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(days: day)),
      notificationIDs[0],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 8, days: day)),
      notificationIDs[1],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 16, days: day)),
      notificationIDs[2],
    );
  }

  // method to handle 12 hours selected
  Future<void> reminder12HoursApart(
    Map<String, dynamic> reminderData,
    int day,
  ) async {
    DateTime startTime = reminderData["start_reminder_date_time"];
    List<int> notificationIDs = reminderData["notification_ids"];

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(days: day)),
      notificationIDs[0],
    );

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(hours: 12, days: day)),
      notificationIDs[1],
    );
  }

  // method to handle 24 hours selected
  Future<void> reminder24HoursApart(
    Map<String, dynamic> reminderData,
    int day,
  ) async {
    my_log('day:$day');

    DateTime startTime = reminderData["start_reminder_date_time"];
    List<int> notificationIDs = reminderData["notification_ids"];

    await _showDailyAtTime(
      reminderData,
      startTime.add(Duration(days: day)),
      notificationIDs[0],
    );
  }

  Future<void> _showDailyAtTime(
    Map<String, dynamic> reminderData,
    DateTime dateTime,
    int reminderId,
  ) async {
    // int hour = dateTime.hour;
    // int minute = dateTime.minute;

    // var time = TimeOfDay(hour: hour, minute: minute);

    // it's time to take your Panadol 50mg
    // Take 2 tablets after meal - 3 times a day.
    // note***
    // Syrup: ml
    // For powder and inhaler: "puffs"

    String title =
        "It's time to take your ${reminderData["medicine_name"]} ${reminderData["dosage_quantity"]}";
    String body =
        "Take ${reminderData["dosage_quantity"]} ${reminderData["dosage_form"].toLowerCase()} ${reminderData["meal_time"]} - ${reminderData["daily_dosage"]}";

    //The complete payload we are working with is usually in Map<String, dynamic> format
    //but the payload of the show() method receives a String?
    //so we'd need to encode it to a String object using the next two lines

    String payload = mapToString(reminderData);

    my_log(dateTime);
    my_log(nextInstanceOfTime(dateTime));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminderId,
      title,
      body,
      nextInstanceOfTime(dateTime),
      _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime nextInstanceOfTime(DateTime date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate.subtract(
      Duration(hours: 1),
    ); //subtracting 1 hour because somehow the reminder gets set to 1 hour after by default
  }

  cancelAllLocalNotifications() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
  cancelNotification(int id) async =>
      await flutterLocalNotificationsPlugin.cancel(id);
}
