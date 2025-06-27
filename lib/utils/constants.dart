import 'dart:math';

import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color(0xff4e8ccb);

  //TO GENERATE ANY LENGTH OF RANDOM STRING
  String _getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  String format_image_name(String imgName) {
    if (imgName.contains('/')) {
      return imgName.split("/")[0];
    } else {
      return imgName;
    }
  }

  List<Color> diaryColors = [
    const Color.fromRGBO(255, 238, 149, 1),
    const Color.fromRGBO(167, 255, 239, 1),
    const Color.fromRGBO(249, 232, 255, 1),
    const Color.fromRGBO(253, 227, 223, 1),
    const Color.fromRGBO(204, 255, 179, 1),
  ];

  List<String> category = ["Show my identity", "Anonymous"];

  List<String> post_category = ["post", "health tips", "video tips"];

  List<String> diary_category = ["All", "others"];

  List<String> interests = [
    "Eye Health",
    "Heart Health",
    "Immune System",
    "Urinary System",
    "Digestive Health",
    "Ear, Nose & Throat Health",
    "Reproductive Health",
    "SkeletonMuscular Health",
  ];

  List<String> symptoms = [
    "Headache",
    "Nausea/Vomiting",
    "Fever",
    "Constipation",
    "Body Pain",
    "Diarrhoea",
    "Itchness",
    "Abdominal Pain",
    "Rashes",
    "Bleeding",
  ];

  List<String> hr_titles = [
    "Vitals",
    "Blood glucose",
    "Cholestrol",
    "Fitness",
    "Lab",
    "HIV",
  ];
  List<String> hr_subtitles = [
    "Pulse rate, Blood pressure, Temperature, Respiratory rate",
    "A/C test, Fasting blood glucose, Random blood glucose",
    "High Density Lipoprotein, Low Density Lipoprotein Triglycerides, Triglycerides",
    "Body fat, Calories consumption, Daily steps, Weight, Waist Circumference, Glass of Water, Alcohol Consumption, Sleep Hours",
    "Createinine, Estimated Glomerular Filtration Rate (eGFR)",
    "CD4 cell count, HIV Viral load",
  ];

  List<String> months = [
    "All",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<String> smileys = [
    "smiley1.png",
    "smiley2.png",
    "smiley3.png",
    "smiley4.png",
    "smiley5.png",
    "smiley6.png",
    "smiley7.png",
    "smiley8.png",
    "smiley9.png",
    "smiley10.png",
    "smiley11.png",
    "smiley12.png",
  ];

  List<String> smileys_text = [
    "Happy",
    "Sad",
    "Angry",
    "Emotional",
    "Worried",
    "Unwell",
    "Confused",
    "Feverish",
    "Depressed",
    "Nauseous",
    "Amazing",
    "Loved",
  ];

  List<String> color_label = [
    "yellow",
    "light_green_accent",
    "light_purple",
    "peech",
    "green",
    "light_green",
  ];

  List<Color> card_colors = [
    const Color.fromRGBO(245, 209, 18, 1), //yellow
    const Color.fromRGBO(10, 255, 211, 1), //light accent
    const Color.fromRGBO(228, 175, 247, 1), // light purple
    const Color.fromRGBO(249, 184, 175, 1), //peech
    const Color.fromRGBO(30, 234, 27, 0.88), //green
    const Color.fromRGBO(197, 255, 169, 0.88), //light_green
  ];

  Color decide_color(String color) {
    if (color == color_label[0]) {
      return card_colors[0];
    } else if (color == color_label[1]) {
      return card_colors[1];
    } else if (color == color_label[2]) {
      return card_colors[2];
    } else if (color == color_label[3]) {
      return card_colors[3];
    } else if (color == color_label[4]) {
      return card_colors[4];
    } else if (color == color_label[5]) {
      return card_colors[5];
    } else {
      return Colors.grey;
    }
  }

  List<String> interval_options = [
    "X times a day",
    "X times a day every Y days",
  ];
  List<String> days = [
    "1 day",
    "2 days",
    "3 days",
    "4 days",
    "5 days",
    "6 days",
    "7 days",
    "8 days",
    "9 days",
    "10 days",
  ];

  List<String> count = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  List<String> end_date_options = ["Continous", "Pick an end date"];

  List<String> medication_intake = [
    "Before meal",
    "After meal",
    "With meal",
    "None",
  ];

  Map<String, String> dosageImages = {
    "Tablet": "assets/tablet.png",
    "Capsule": "assets/capsule.png",
    "Syrup": "assets/syrup.png",
    "Drop": "assets/drop.png",
    "Powder": "assets/powder.png",
    "Paste/Ointment": "assets/paste.png",
    "Inhaler": "assets/inhaler.png",
    "Vial/Ampoule": "assets/vial.png",
    "Suppository": "assets/suppository.png",
    "Pessary": "assets/pessary.png",
  };

  List<String> dosage_forms = [
    "Tablet",
    "Capsule",
    "Syrup",
    "Drop",
    "Powder",
    "Paste/Ointment",
    "Inhaler",
    "Vial/Ampoule",
    "Suppository",
    "Pessary",
  ];
  Map<String, List<String>> medicationDose = {
    "Tablet": ['mg', 'g'],
    "Capsule": ['mg', 'g'],
    "Syrup": ['ml', 'L'],
    "Drop": ['drops', 'ml'],
    "Powder": ['mg', 'g'],
    "Paste/Ointment": ['mg', 'g'],
    "Inhaler": ['Puffs'],
    "Vial/Ampoule": ['Vial', 'Ampoule'],
    "Suppository": ['Suppository'],
    "Pessary": ['Pessary'],
  };

  List<String> frequencies = [
    "Once a day",
    "Two (2) times a day",
    "Three (3) times a day",
    "Four (4) times a day",
    "Six (6) times a day",
  ];
  Map<String, int> frequenciesWordToNumber = {
    "Once a day": 1,
    "Two (2) times a day": 2,
    "Three (3) times a day": 3,
    "Four (4) times a day": 4,
    "Six (6) times a day": 6,
  };
  // List<String> frequencies = [
  //   "1 times a day - 24 hourly",
  //   "2 times a day - 12 hourly",
  //   "3 times a day - 8 hourly",
  //   "4 times a day - 6 hourly",
  //   "6 times a day - 4 hourly",
  //   "8 times a day - 3 hourly",
  //   "12 times a day - 2 hourly",
  // ];
  // List<String> reminder_frequencies = [
  //   "1-24",
  //   "2-12",
  //   "3-8",
  //   "4-6",
  //   "6-4",
  //   "8-3",
  //   "12-2",
  // ];
  List<Map<String, int>> reminder_frequencies = [
    {"times": 1, "hour_interval": 24},
    {"times": 2, "hour_interval": 12},
    {"times": 3, "hour_interval": 8},
    {"times": 4, "hour_interval": 6},
    {"times": 6, "hour_interval": 4},
    {"times": 8, "hour_interval": 3},
    {"times": 12, "hour_interval": 2},
  ];

  List<String> medical_history = [
    "Medications",
    "Allergies",
    "Surgeries",
    "Medical Conditions",
    "Family Conditions",
  ];

  List<String> video_tuts = [
    "How to set a medication reminder",
    "How to save information to your Health Diary",
    "How to make a Post",
    "In setting a medication reminder, what does 'X times a day' and 'X times a day ever every Y days' mean?",
    "How to edit a saved medication reminder?",
    "How to save a health record value?",
  ];

  List<String> genotypes = ['AA', 'AS', 'SS', 'AC'];
  List<String> bloodGroups = ["AO", "BO", "A+", "AB", "OO"];
  List<int> weights = [for (int i = 1; i <= 300; i++) i];
  List<double> heights = [
    for (double i = 0.1; i <= 3.1; i += 0.1) double.parse(i.toStringAsFixed(1)),
  ];

  Map<String, String> notificationSoundAssets = {
    "Casino win alarm and coins":
        "notification_sounds/casino_win_alarm_and_coins.wav",
    "classic alarm": "notification_sounds/classic_alarm.wav",
    "Digital clock digital alarm buzzer":
        "notification_sounds/digital_clock_digital_alarm_buzzer.wav",
    "Drumming jungle music": "notification_sounds/drumming_jungle_music.wav",
    "Game level music": "notification_sounds/game_level_music.wav",
    "Marimba ringtone": "notification_sounds/marimba_ringtone.wav",
    "Marimba waiting ringtone":
        "notification_sounds/marimba_waiting_ringtone.wav",
    "Morning clock alarm": "notification_sounds/morning_clock_alarm.wav",
    "Slot machine win alarm": "notification_sounds/slot_machine_win_alarm.wav",
    "Urgent digital alarm tone":
        "notification_sounds/urgent_digital_alarm_tone.wav",
    "Vintage telephone ringtone":
        "notification_sounds/vintage_telephone_ringtone.wav",
    "Weird alarm": "notification_sounds/weird_alarm.wav",
  };


  List<Map<String,String>> adherenceComment=[
    {
      "image":"assets/smiley11.png",
      "comment_1":"Outstanding! You’ve were fully committed to your ",
      "comment_2":" this month with over 90% adherence. Keep up the great work and continue prioritizing your well-being!",
    },
    {
      "image":"assets/smiley12.png",
      "comment_1":"Great job! You’ve been 80–89% adherent to your ",
      "comment_2":" this month. A little more consistency, and you’ll reach perfection! Stay focused on your health journey.",
    },
    {
      "image":"assets/smiley1.png",
      "comment_1":"You’re on the right track. You’ve been 70–79% adherent to your ",
      "comment_2":" this month. Let’s aim a bit higher next month for even better health outcomes!",
    },
    {
      "image":"assets/smiley_saved.png",
      "comment_1":"You're making progress. You’ve been 50–69% adherent to your ",
      "comment_2":" this month. Staying consistent with your medications can significantly boost your health. Let’s work towards improving next month!",
    },
    {
      "image":"assets/smiley_delete.png",
      "comment_1":"We noticed you were below 50% adherence to your ",
      "comment_2":" this month. Don’t worry—every step counts! Let’s set small goals to build better habits and prioritize your health together.",
    },
  ];
}
