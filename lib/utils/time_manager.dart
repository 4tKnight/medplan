import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeManager {
  //1658370201297
  //July 21, 2022
  String dateFromTimestamp(int timestamp) {
    var date2 = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    String d = date2.toString().split(" ")[0];
    List<String> s = d.split("-");
    String month = getMonthString(int.parse(s[1]));
    // print("$month ${s[2]}, ${s[0]}");

    String c_month = month.length <= 4 ? month : month.substring(0, 3).toString();
    return "$c_month ${s[2]}, ${s[0]}";
  }

  //1658370201297
  //3:23AM
  String timeFromTimestamp(int timestamp) {
    String? noon;
    int? hour24;
    String? hour;
    String? minute;

    var date2 = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    print(date2);
    String d2 = date2.toString().split(" ")[1];
    List<String> d = d2.split(":");
    hour24 = int.parse(d[0]);
    minute = d[1];

    if (hour24 > 12) {
      int hour12 = hour24 - 12;
      hour = hour12.toString();
      noon = 'pm';
    } else {
      hour = hour24.toString();
      print(hour24.toString());
      noon = 'am';
    }

    return ('$hour:$minute $noon');
  }

  //TimeOfDay(01:18)
  //3:23AM
  String timeFromShowTimePicker(String timeOfDay) {
    String? noon;
    int? hour24;
    String? hour;
    String? minute;

    // print(date2);
    List<String> d = timeOfDay.split(":");
    hour24 = int.parse(d[0]);
    minute = d[1];

    if (hour24 > 12) {
      int hour12 = hour24 - 12;
      hour = hour12.toString();
      noon = 'PM';
    } else {
      hour = hour24.toString();
      print(hour24.toString());
      noon = 'AM';
    }

    return ('$hour:$minute$noon');
  }

  String timestamp(int timestamp) {
    //1579096362834 //365days ago
    // 1610402362834
    // 1610407362834
    // 1610502362834
    // 1610620579043
    // final now = DateTime.now();

    // int time = 1610207362834;

    DateTime d = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // List<String> myDate2 = d.toString().split(' ');
    // List<String> myDate = myDate2[0].toString().split('-');
    // int year = int.parse(myDate[0]);
    // int month = int.parse(myDate[1]);
    // int day = int.parse(myDate[2]);

    int year = int.parse(DateFormat.y().format(d));
    int month = int.parse(DateFormat.M().format(d));
    int day = int.parse(DateFormat.d().format(d));

    return "$day/$month/$year";
  }


//Convert DateTime to Date 
//2024-04-23 00:00:00.000 to Day(Int), Month(Int), Year (Int)
  Map<String, int> extractDateComponents(String dateTimeString) {
  final List<int> dateTimeParts =
      dateTimeString.split(' ').first.split('-').map(int.parse).toList();
  return {
    'year': dateTimeParts[0],
    'month': dateTimeParts[1],
    'day': dateTimeParts[2],
  };
}

//receives a month as int and returns the month in full String e.g April
  String getMonthString(int month) {
    if (month == 1) {
      return 'January';
    } else if (month == 2) {
      return 'February';
    } else if (month == 3) {
      return 'March';
    } else if (month == 4) {
      return 'April';
    } else if (month == 5) {
      return 'May';
    } else if (month == 6) {
      return 'June';
    } else if (month == 7) {
      return 'July';
    } else if (month == 8) {
      return 'August';
    } else if (month == 9) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';

      // 'January',
      // 'February',
      // 'March',
      // 'April',
      // 'May',
      // 'June',
      // 'July',
      // 'August',
      // 'September',
      // 'October',
      // 'November',
      // 'December',
    }
  }

  //MY CUSTOM FUNCTION TO GET & CONVERT THE TIMESTAMP
  String myTimestamp(int timestamp) {
    //1579096362834 //365days ago
    // 1610402362834
    // 1610407362834
    // 1610502362834
    // 1610620579043
    final now = DateTime.now();

    // int time = 1610207362834;

    DateTime d = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // List<String> myDate2 = d.toString().split(' ');
    // List<String> myDate = myDate2[0].toString().split('-');
    // int year = int.parse(myDate[0]);
    // int month = int.parse(myDate[1]);
    // int day = int.parse(myDate[2]);

    int year = int.parse(DateFormat.y().format(d));
    int month = int.parse(DateFormat.M().format(d));
    int day = int.parse(DateFormat.d().format(d));

    DateTime date = DateTime(year, month, day);
    int diff = now.difference(date).inDays;
    int diffHrs = now.difference(date).inHours;

    print(diff);

    //jm //MMMEd //yMMMEd
    if (diff == 0) {
      return (timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp)).toString());
    } else if (diffHrs >= 24 && diffHrs <= 48) {
      return ('Yesterday, ${DateFormat.jm().format(d)}');
    } else if (diff == 2) {
      return ('${timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp))} ${DateFormat.jm().format(d)}');
    } else if (diff == 3) {
      return ('${timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp))} ${DateFormat.jm().format(d)}');
    } else if (diff > 3 && diff <= 364) {
      return ('${DateFormat.MMMd().format(d)}, ${DateFormat.jm().format(d)}');
    } else {
      return (DateFormat.yMMMd().format(d).toString());
    }
  }

  String formatStringTimestamp(String timestamp) {
    String datek = timestamp.split('T')[0];
    String timek = timestamp.split('T')[1].split(":")[0] + ":" + timestamp.split('T')[1].split(":")[1];
    return "$datek $timek";
  }

  //1/2/2020, 10:40AM
  String formatPostDateTimeWithTimeStamp(int timestamp) {
    DateTime ts = DateTime.fromMillisecondsSinceEpoch(timestamp);

    //fomatting date
    int day = int.parse(DateFormat.d().format(ts));
    int month = int.parse(DateFormat.M().format(ts));
    int year = int.parse(DateFormat('yy').format(ts));
    //formatting time
    String t = ts.toString().split(" ")[1];
    List<String> d = t.split(":");
    int hour24 = int.parse(d[0]);
    String minute = d[1];
    String noon;
    String hour;

    if (hour24 > 12) {
      int hour12 = hour24 - 12;
      hour = hour12.toString();
      noon = 'PM';
    } else if (hour24 == 0) {
      hour = "12";
      // print(hour24.toString());
      noon = 'AM';
    } else {
      hour = hour24.toString();
      // print(hour24.toString());
      noon = 'AM';
    }

    return ('$day/$month/$year,  $hour:$minute$noon');
  }

//2023-04-04 15:38:00.000 to 3:38PM
  String convert24hour(String time) {
    // print('--------herhererere---------> $time');
    String t = time.split(" ")[1];
    List<String> d = t.split(":");
    int hour24 = int.parse(d[0]);
    String minute = d[1];
    String noon;
    String hour;

    if (hour24 > 12) {
      int hour12 = hour24 - 12;
      hour = hour12.toString();
      noon = 'pm';
    } else if (hour24 == 0) {
      hour = "12";
      // print(hour24.toString());
      noon = 'am';
    } else {
      hour = hour24.toString();
      // print(hour24.toString());
      noon = 'am';
    }

    return ('$hour:$minute$noon');
  }

    formattedDateFromTimestamp(int timestamp) {
    final now = DateTime.now();

    DateTime ts = DateTime.fromMillisecondsSinceEpoch(timestamp);

    //fomatting date
    int day = int.parse(DateFormat.d().format(ts));
    int month = int.parse(DateFormat.M().format(ts));
    int year = int.parse(DateFormat('y').format(ts));

    DateTime date = DateTime(year, month, day);
    int diff = now.difference(date).inDays;
    int diffHrs = now.difference(date).inHours;
    String monthName = getMonthString(month);
    String cMonth = monthName.length <= 4
        ? monthName
        : monthName.substring(0, 3).toString();

    if (diff == 0) {
      return ('Today');
    } else if (diffHrs >= 24 && diffHrs <= 48) {
      return ('Yesterday');
    } else {
      int year = int.parse(DateFormat('yy').format(ts));
      return ('$cMonth $day, $year');
    }
  }

   /// Formats a timestamp (millisecondsSinceEpoch) to "12th@ 11:03am"
    String formatTimestampWithSuffix(int timestamp) {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final day = date.day;
      final suffix = _getDaySuffix(day);
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = date.hour >= 12 ? 'pm' : 'am';
      return '$day$suffix@ $hour:$minute$ampm';
    }
  
    String _getDaySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }
  
}
