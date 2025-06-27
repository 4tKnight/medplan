import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medplan/utils/local_notification_handler.dart';
import 'package:medplan/utils/time_manager.dart';
// import 'package:share_plus/share_plus.dart';

import '../helper_widget/helper_widget.dart';
import '../screens/health_record/records/record_widgets.dart';
import 'color.dart';
import 'constants.dart';
import 'custom_widgets.dart';
import 'loading_widgets.dart';
import 'variables.dart';

final darkNotifier = ValueNotifier<bool>(getX.read(v.GETX_THEME_MODE) ?? false);
final getX = GetStorage();
Variables v = Variables();
DB db = DB();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Color primaryColor = const Color.fromRGBO(0, 124, 238, 1);
Color secondaryColor = const Color.fromRGBO(255, 158, 6, 1);

Color greyTextColor = const Color.fromRGBO(0, 0, 0, 0.7);
HelperWidget helperWidget = HelperWidget();
CustomWidgets myWidgets = CustomWidgets();
LocalNotificationHelper localNotificationHelper = LocalNotificationHelper();
HealthRecordWidgets healthRecordWidgets = HealthRecordWidgets();
MyColor color = MyColor();
Constants constants = Constants();

TimeManager time = TimeManager();
LoadingWidgets loading = LoadingWidgets();

String httpBaseUrl = "server-medplan.onrender.com";
String dioBaseUrl = "https://server-medplan.onrender.com";

// String httpBaseUrl = "medplan.onrender.com";
// String dioBaseUrl = "https://medplan.onrender.com";

const ONE_SIGNAL_APP_ID = "c5b724bd-5880-42b3-846f-6f55f1393548";
String APP_ID = "com.medplan.solutions";

String laughwithlily = "lisamote03@gmail.com";

const GOOGLE_PLAY_URL =
    "https://play.google.com/store/apps/details?id=com.medplansolution.medplan";

const MEDPLAN_WEB_URL = "https://medplan.netlify.app";

void share_to_external({required String title, required String body}) {
  String n_body;
  int max_length = 300;
  if (body.length <= max_length) {
    n_body = body; // No truncation needed
  } else {
    n_body =
        body.substring(0, max_length) + " ..."; // Truncate and add ellipsis
  }

  // Share.share(
  //   "${title.toUpperCase()}\n\n${n_body}\n\n\nTo further view enlightening content by continuing to read similar educational articles.\nDownload MedPlan app from Google playstore now:\n$GOOGLE_PLAY_URL",
  // );
}
