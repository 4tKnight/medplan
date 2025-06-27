import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medplan/api/profile_service.dart';
import 'dart:convert';
import 'global.dart';

my_log(value) {
  d.log(">>>>>> $value\n\n\n");
}

double calculateBMI(int weight, double height) {
  return double.parse((weight / (height * height)).toStringAsFixed(2));
}

Future<bool> increaseMedplanCoin(coinAmount) async {
  try {
    var res = await ProfileService().increaseMedplanCoins(coinAmount);
    my_log(res);
    if (res['status'] == 'ok') {
      if (getX.read(v.GETX_MEDPLAN_COINS) == null) {
        getX.write(v.GETX_MEDPLAN_COINS, 0);
      } else {
        getX.write(
          v.GETX_MEDPLAN_COINS,
          getX.read(v.GETX_MEDPLAN_COINS) + coinAmount,
        );
      }
      return true;
    } else {
      return false;
    }
  } catch (e) {
    my_log(e);
    return false;
  }
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String pluralize(int count) {
  if (count == 1) {
    return "";
  } else {
    return "s";
  }
}

set_getX_data(BuildContext context, dynamic res) {
  if (res[v.TOKEN] != null) {
    getX.write(v.GETX_IS_LOGGED_IN, true);
    getX.write(db.TOKEN, res[v.TOKEN]);
  }
  getX.write(v.GETX_USER_ID, res[db.DB_USER][db.DB_USER_ID]);
  getX.write(v.GETX_USERNAME, res[db.DB_USER][db.DB_USERNAME]);
  getX.write(v.GETX_EMAIL, res[db.DB_USER][db.DB_EMAIL]);
  getX.write(v.GETX_PHONE_NO, res[db.DB_USER][db.DB_PHONE_NO]);
  getX.write(v.GETX_USER_IMAGE, res[db.DB_USER][db.DB_USER_IMAGE]);
  getX.write(v.GETX_DEPENDENTS, res[db.DB_USER][v.GETX_DEPENDENTS]);
  getX.write(v.GETX_COMPANIONS, res[db.DB_USER][v.GETX_COMPANIONS]);
  getX.write(v.GETX_MEDPLAN_COINS, res[db.DB_USER][db.DB_MEDPLAN_COINS]);
  getX.write(v.GETX_GENDER, res[db.DB_USER][v.GETX_GENDER]);
  getX.write(v.GETX_DAY_OF_BIRTH, res[db.DB_USER][v.GETX_DAY_OF_BIRTH]);
  getX.write(v.GETX_PREFS, res[db.DB_USER][v.GETX_PREFS]);
  getX.write(v.GETX_DEPENDENTS, res[db.DB_USER][v.GETX_DEPENDENTS] ?? []);
  getX.write(v.GETX_COMPANIONS, res[db.DB_USER][v.GETX_COMPANIONS] ?? []);

  getX.write(v.GETX_ALLERGIES, res[db.DB_USER][v.GETX_ALLERGIES] ?? []);
  getX.write(v.GETX_SURGERIES, res[db.DB_USER][v.GETX_SURGERIES] ?? []);
  getX.write(
    v.GETX_FAMILY_CONDITIONS,
    res[db.DB_USER][v.GETX_FAMILY_CONDITIONS] ?? [],
  );

  getX.write(
    v.GETX_PERSONAL_HEALTH_INFORMATION,
    res[db.DB_USER][v.GETX_PERSONAL_HEALTH_INFORMATION] ??
        {
          "genotype": "",
          "blood_group": "",
          "weight": 0,
          "height": 0.0,
          "bmi": 0,
        },
  );
  getX.write(v.GETX_SERVER_ID_TO_LOCAL_IDS, {});

  // getX.write(
  //     v.GETX_FULLNAME,
  //     res[db.DB_USER][db.DB_FULLNAME] == ""
  //         ? "a"
  //         : res[db.DB_USER][db.DB_FULLNAME]);
  // getX.write(v.GETX_EMAIL, res[db.DB_USER][db.DB_EMAIL]);

  // getX.write(v.GETX_INTERESTS, res[db.DB_USER][db.DB_INTERESTS]);
  // getX.write(v.GETX_SUMMARY, res[db.DB_USER][db.DB_SUMMARY] ?? "");

  // getX.write(
  //     v.GETX_PROFILE_COMPLETE, res[db.DB_USER][db.DB_PROFILE_COMPLETE]);

  // getX.write(v.GETX_BIRTH_YEAR,
  //     res[db.DB_USER][db.DB_HEALTH_INFO][db.DB_BIRTH_YEAR]);
  // getX.write(
  //     v.GETX_GENOTYPE, res[db.DB_USER][db.DB_HEALTH_INFO][db.DB_GENOTYPE]);
  // getX.write(v.GETX_BLOOD_GROUP,
  //     res[db.DB_USER][db.DB_HEALTH_INFO][db.DB_BLOOD_GROUP]);
  // getX.write(v.GETX_BMI, res[db.DB_USER][db.DB_HEALTH_INFO][db.DB_BMI]);

  // getX.write(v.GETX_MEDICATIONS,
  //     res[db.DB_USER][db.DE_MEDICAL_HISTORY][db.DB_MEDICATIONS]);
  // getX.write(v.GETX_ALLERGIES,
  //     res[db.DB_USER][db.DE_MEDICAL_HISTORY][db.DB_ALLERGIES]);
  // getX.write(v.GETX_MED_CONDITIONS,
  //     res[db.DB_USER][db.DE_MEDICAL_HISTORY][db.DB_MED_CONDITIONS]);
  // getX.write(v.GETX_SURGERIES,
  //     res[db.DB_USER][db.DE_MEDICAL_HISTORY][db.DB_SURGERIES]);
  // getX.write(v.GETX_FAM_HISTORY,
  //     res[db.DB_USER][db.DE_MEDICAL_HISTORY][db.DB_FAM_HISTORY]);

  // getX.write(v.GETX_ONLINE, res[db.DB_USER][db.DB_STATE][db.DB_ONLINE]);
  // getX.write(v.GETX_AVAILABLE, res[db.DB_USER][db.DB_STATE][db.DB_AVAILABLE]);
  // getX.write(v.GETX_STATUS, res[db.DB_USER][db.DB_STATE][db.DB_STATUS]);

  // getX.write(
  //     v.GETX_DARK_MODE, res[db.DB_USER][db.DB_SETTINGS][db.DB_DARK_MODE]);
  // darkNotifier.value =
  //     res[db.DB_USER][db.DB_SETTINGS][db.DB_DARK_MODE] == "yes"
  //         ? true
  //         : false;

  // getX.write(v.GETX_RECEIVE_NOTIFICATIONS,
  //     res[db.DB_USER][db.DB_SETTINGS][db.DB_RECEIVE_NOTIFICATIONS]);
}

String mapToString(Map<String, dynamic> map) {
  if (map['start_reminder_date_time'] != null) {
    map['start_reminder_date_time'] =
        map['start_reminder_date_time'].toString();
  }
  return jsonEncode(map); // Convert Map to JSON String
}

Map<String, dynamic> stringToMap(String jsonString) {
  return jsonDecode(jsonString); // Convert JSON String back to Map
}
