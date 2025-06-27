import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medplan/screens/auth/auth_login_signup.dart';
import 'package:medplan/screens/home/health_diary/my_health_diary.dart';
import 'package:medplan/screens/home/notification.dart';
import 'package:medplan/splashscreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'screens/bottom_control/bottom_nav_bar.dart';
import 'screens/onboarding/onboarding.dart';
import 'utils/app_theme.dart';
import 'utils/global.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_screenutil/flutter_screenutil.dart';
// flutter build apk --release --split-per-abi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  initPlatform();
  tz.initializeTimeZones();
  // final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName!));

  runApp(const MyApp());
}

Future<void> initPlatform() async {
  // await OneSignal.shared.setAppId(ONE_SIGNAL_APP_ID);
  OneSignal.initialize(ONE_SIGNAL_APP_ID);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    _initializeApp();
    handler_for_tapped_notifications();
    handler_to_show_notification_or_not_when_app_is_active_in_foreground();
    localNotificationHelper.initializeNotifications();
  }

  bool _isInitialized = false;
  Future<void> _initializeApp() async {
    // Simulate initialization process
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkNotifier,
      builder: (BuildContext context, bool isDark, Widget? child) {
        return OverlaySupport.global(
          child: ScreenUtilInit(
            designSize: const Size(414, 918),
            minTextAdapt: true,
            splitScreenMode: true,
            enableScaleText: () => true,
            ensureScreenSize: true,
            builder: (_, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'MedPlan',
                debugShowCheckedModeBanner: false,

                // themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: AppTheme.lightTheme,
                // darkTheme: AppTheme.lightTheme,
                // darkTheme: AppTheme.darkTheme,
                home: AnimatedSwitcher(
                  duration: Duration(milliseconds: 1000),
                  child: _isInitialized ? check() : SplashScreen(),
                ),
                // home: check(),
                // home: SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }

  Widget check() {
    if (getX.read(v.GETX_IS_FIRST_TIME) != null) {
      if (getX.read(v.GETX_IS_LOGGED_IN) == true) {
        return BottomNavBar();
      } else {
        return Login();
        // return SizedBox();
      }
    } else {
      return Onboarding();
    }
  }

  void handler_for_tapped_notifications() {
    OneSignal.Notifications.addClickListener((event) {
      print(
        "-------->>>>OneSignal: notification opened: ${event.notification.additionalData}",
      );

      Map<String, dynamic>? notificationData =
          event.notification.additionalData;
      print('-------->>>>>>>>>>> $notificationData');

      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => NotificationPage()),
      );
    });
  }

  void handler_to_show_notification_or_not_when_app_is_active_in_foreground() {
    // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    //   print('-------->>>>>>>>>>> ${event.notification.additionalData}');
    //   dynamic notificationData = event.notification.additionalData;

    //   //* Use event.preventDefault() to prevent the notification from displaying
    //   // event.preventDefault();
    //   //* Use event.notification to display the notification
    //   print(event.notification);
    //     event.display(); // Display the notification
    // });
  }

  // void showNotificationOrNotHandlerWhenAppIsInFocus() {
  //   //we want to actually check if the "from"ID is equal to the ID
  //   //of the other user in the page that the logged in user is on
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //       (OSNotificationReceivedEvent event) {
  //     // send null to not display, send notification to display
  //     // event.complete(null);
  //     event.complete(event.notification);
  //     // print('>>>>>>>>>>>>>>>>>>>>>>> ${event.notification} ');
  //   });
  // }

  // void notificationTappedHandler() {
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     print('"OneSignal: notification opened: ${result}');
  //   });
  // }
}
