class Endpoints {
  //auth
  static const String signup = '/user/auth/signup';
  static const String login = '/user/auth/login';
  static const String logout = '/user/auth/logout';
  static const String forgotPassword = '/user/auth/forgot_password';
  static const String deleteAccount = '/user/auth/user_delete_account';


//bug_reports
  static const String createBugReport = '/user/bug_report/create_bug_report';

//dependent
  static const String addDependent = '/user/dependent/add_dependent';
  static const String editDependent = '/user/dependent/edit_dependent';
  static const String viewUsersDependents = '/user/dependent/view_users_dependents';
  static const String deleteDependent = '/user/dependent/delete_dependent';

//companion
  static const String addCompanion = '/user/companion/add_companion';
  static const String editCompanion = '/user/companion/edit_companion';
  static const String viewUserCompanions = '/user/companion/view_users_companions';
  static const String viewUserTrackees = '/user/companion/view_user_trackees';
  static const String deleteCompanion = '/user/companion/delete_companion';
  static const String companionRequest = '/user/companion/accept_decline_companion_request';


//search
  static const String viewAllUsers = '/user/search/view_all_users';
  static const String searchHealthArticle = '/user/search/search_health_article';
  static const String searchVideoTip = '/user/search/search_video_tip';



//notification
  static const String viewNotifications = '/user/notification/view_notifications';
  static const String deleteNotification = '/user/notification/delete_notification';



//profile
  static const String setDeviceToken = '/user/profile/set_device_token';
  static const String increaseMedplanCoins = '/user/profile/increase_medplan_coins';
  static const String editProfile = '/user/profile/edit_profile';
  static const String viewProfile = '/user/profile/view_profile';
  static const String editAccountPreferences = '/user/profile/edit_account_preferences';



//health_diary
  static const String addHealthDiary = '/user/health_diary/add_health_diary';
  static const String editHealthDiary = '/user/health_diary/edit_health_diary';
  static const String deleteHealthDiary = '/user/health_diary/delete_health_diary';
  static const String viewHealthDiaries = '/user/health_diary/view_multiple_health_diaries';


  //medication_reminder
  static const String addMedicationReminder = '/user/medication_reminder/add_medication_reminder';
  static const String editMedicationReminder = '/user/medication_reminder/edit_medication_reminder';
  static const String deleteMedicationReminder = '/user/medication_reminder/delete_medication_reminder';
  static const String viewTodaysMedicationReminders = '/user/medication_reminder/view_todays_medication_reminders';
  static const String viewMedicationHistory = '/user/medication_reminder/view_medication_history';
  static const String searchMedicine = '/user/medication_reminder/search_medicine';
  static const String skipMedication = '/user/medication_reminder/skip_medication';
  static const String takeMedication = '/user/medication_reminder/take_medication';
  
  
  //appointment
  static const String createAppointment = '/user/appointment/create_appointment';
  static const String editAppointment = '/user/appointment/edit_appointment';
  static const String deleteAppointment = '/user/appointment/delete_appointment';
  static const String viewUpcomingAppointment = '/user/appointment/view_upcoming_appointments';



  //chat
  static const String getConversations = '/user/chat/get_conversations';
  static const String getMessages = '/user/chat/get_messages';
  static const String checkConvers = '/user/chat/check_convers';
  static const String sendFile = '/user/chat/send_file';

  //view_health_articles
  static const String viewHealthArticles = '/user/health_articles/view_health_articles';
  static const String incHealthArticleShareCount = '/user/health_articles/inc_health_article_share_count';
  static const String commentHealthArticle = '/user/health_articles/comment_health_article';
  static const String viewHealthArticleComments = '/user/health_articles/view_health_article_comments';
  static const String likeHealthArticle = '/user/health_articles/like_health_article';
  static const String viewHealthArticleCommentReplies = '/user/health_articles/view_comment_replies';
  static const String likeHealthArticleComment = '/user/health_articles/like_comment';
  static const String viewTopArticles = '/user/health_articles/view_top_articles';
  
  
  //video_tips
  static const String viewVideoTips = '/user/video_tips/view_video_tips';
  static const String incVideoTipShareCount = '/user/video_tips/inc_video_tip_share_count';
  static const String commentVideoTip = '/user/video_tips/comment_video_tip';
  static const String viewVideoTipComments = '/user/video_tips/view_video_tip_comments';
  static const String likeVideoTip = '/user/video_tips/like_video_tip';
  static const String viewVideoTipCommentReplies = '/user/video_tips/view_comment_replies';
  static const String likeVideoTipComment = '/user/video_tips/like_comment';


  //reply_comment
  static const String commentReply = '/user/comment_reply/comment_reply';
  static const String getRepliesPostComments = '/user/comment_reply/get_replies_post_comments';
  static const String togglelikeCommentReply = '/user/comment_reply/toggle_like_comment_reply';
  // static const String unlikeCommentReply = '/user/reply_comment/unlike_comment_reply';
  
  
  
  
//adherence_report
  static const String viewAdherenceReports = '/user/adherence_report/view_adherence_reports';
  
//medplan_story
  static const String createMedplanStory = '/user/medplan_story/create_medplan_story';
 
//daily_tips
  static const String incDailyTipShareCount = '/user/daily_tips/inc_daily_tip_share_count';
  static const String likeDailyTip = '/user/daily_tips/like_daily_tip';
  static const String viewDailyTips = '/user/daily_tips/view_daily_tips';
  
  
  //health_record
  static const String setPersonalHealthInfo = '/user/health_record/set_personal_health_info';
  
  static const String updateAllergies = '/user/health_record/update_allergies';
  static const String updateSurgeries = '/user/health_record/update_surgeries';
  static const String updateFamilyConditions = '/user/health_record/update_family_conditions';
 
  static const String viewPulseRate = '/user/health_record/view_pulse_rate';
  static const String addPulseRate = '/user/health_record/add_pulse_rate';
 
  static const String viewBloodPressure = '/user/health_record/view_blood_pressure';
  static const String addBloodPressure = '/user/health_record/add_blood_pressure';
 
  static const String viewTemperature = '/user/health_record/view_temprature';
  static const String addTemperature = '/user/health_record/add_temprature';
 
  static const String viewRespiratoryRate = '/user/health_record/view_respiratory_rate';
  static const String addRespiratoryRate = '/user/health_record/add_respiratory_rate';
  
  static const String viewA1cTest = '/user/health_record/view_bg_a1c_test';
  static const String addA1cTest = '/user/health_record/add_bg_a1c_test';

  static const String viewFastingBloodGlucose = '/user/health_record/view_bg_fasting_bg';
  static const String addFastingBloodGlucose = '/user/health_record/add_bg_fasting_bg';

  static const String viewRandomBloodGlucose = '/user/health_record/view_bg_random_bg';
  static const String addRandomBloodGlucose = '/user/health_record/add_bg_random_bg';

  static const String viewHDL = '/user/health_record/view_bc_high_density_lipoprotein';
  static const String addHDL = '/user/health_record/add_bc_high_density_lipoprotein';

  static const String viewLDL = '/user/health_record/view_bc_low_density_lipoprotein';
  static const String addLDL = '/user/health_record/add_bc_low_density_lipoprotein';

  static const String viewTriglycerides = '/user/health_record/view_bc_triglycerides';
  static const String addTriglycerides = '/user/health_record/add_bc_triglycerides';

  static const String viewCreatine = '/user/health_record/view_lab_tests_creatine';
  static const String addCreatine = '/user/health_record/add_lab_tests_creatine';

  static const String viewEGFR = '/user/health_record/view_lab_tests_eGFR';
  static const String addEGFR = '/user/health_record/add_lab_tests_eGFR';

  static const String viewCD4 = '/user/health_record/view_hiv_cd4_cell_count';
  static const String addCD4 = '/user/health_record/add_hiv_cd4_cell_count';

  static const String viewHIV = '/user/health_record/view_hiv_viral_load';
  static const String addHIV = '/user/health_record/add_hiv_viral_load';

  static const String viewBodyFatPercentage = '/user/health_record/view_fitness_body_fat_percentage';
  static const String addBodyFatPercentage = '/user/health_record/add_fitness_body_fat_percentage';

  static const String viewCaloryConsumption = '/user/health_record/view_fitness_calory_consumption';
  static const String addCaloryConsumption = '/user/health_record/add_fitness_calory_consumption';

  static const String viewDailySteps = '/user/health_record/view_fitness_daily_steps';
  static const String addDailySteps = '/user/health_record/add_fitness_daily_steps';

  static const String viewWeight = '/user/health_record/view_fitness_weight';
  static const String addWeight = '/user/health_record/add_fitness_weight';

  static const String viewWaistCircumference = '/user/health_record/view_fitness_waist_circumference';
  static const String addWaistCircumference = '/user/health_record/add_fitness_waist_circumference';

  static const String viewGlassOfWater = '/user/health_record/view_fitness_glass_of_water';
  static const String addGlassOfWater = '/user/health_record/add_fitness_glass_of_water';

  static const String viewAlcoholConsumption = '/user/health_record/view_fitness_alcohol_consumption';
  static const String addAlcoholConsumption = '/user/health_record/add_fitness_alcohol_consumption';

  static const String viewSleepHours = '/user/health_record/view_fitness_sleep_hours';
  static const String addSleepHours = '/user/health_record/add_fitness_sleep_hours';


//dependent health_record
  static const String setDependentPersonalHealthInfo = '/user/dependent/set_personal_health_info';
  
  static const String updateDependentAllergies = '/user/dependent/update_allergies';
  static const String updateDependentSurgeries = '/user/dependent/update_surgeries';
  static const String updateDependentFamilyConditions = '/user/dependent/update_family_conditions';
 
  static const String viewDependentPulseRate = '/user/dependent/view_pulse_rate';
  static const String addDependentPulseRate = '/user/dependent/add_pulse_rate';
 
  static const String viewDependentBloodPressure = '/user/dependent/view_blood_pressure';
  static const String addDependentBloodPressure = '/user/dependent/add_blood_pressure';
 
  static const String viewDependentTemperature = '/user/dependent/view_temprature';
  static const String addDependentTemperature = '/user/dependent/add_temprature';
 
  static const String viewDependentRespiratoryRate = '/user/dependent/view_respiratory_rate';
  static const String addDependentRespiratoryRate = '/user/dependent/add_respiratory_rate';
  
  static const String viewDependentA1cTest = '/user/dependent/view_bg_a1c_test';
  static const String addDependentA1cTest = '/user/dependent/add_bg_a1c_test';

  static const String viewDependentFastingBloodGlucose = '/user/dependent/view_bg_fasting_bg';
  static const String addDependentFastingBloodGlucose = '/user/dependent/add_bg_fasting_bg';

  static const String viewDependentRandomBloodGlucose = '/user/dependent/view_bg_random_bg';
  static const String addDependentRandomBloodGlucose = '/user/dependent/add_bg_random_bg';

  static const String viewDependentHDL = '/user/dependent/view_bc_high_density_lipoprotein';
  static const String addDependentHDL = '/user/dependent/add_bc_high_density_lipoprotein';

  static const String viewDependentLDL = '/user/dependent/view_bc_low_density_lipoprotein';
  static const String addDependentLDL = '/user/dependent/add_bc_low_density_lipoprotein';

  static const String viewDependentTriglycerides = '/user/dependent/view_bc_triglycerides';
  static const String addDependentTriglycerides = '/user/dependent/add_bc_triglycerides';

  static const String viewDependentCreatine = '/user/dependent/view_lab_tests_creatine';
  static const String addDependentCreatine = '/user/dependent/add_lab_tests_creatine';

  static const String viewDependentEGFR = '/user/dependent/view_lab_tests_eGFR';
  static const String addDependentEGFR = '/user/dependent/add_lab_tests_eGFR';

  static const String viewDependentCD4 = '/user/dependent/view_hiv_cd4_cell_count';
  static const String addDependentCD4 = '/user/dependent/add_hiv_cd4_cell_count';

  static const String viewDependentHIV = '/user/dependent/view_hiv_viral_load';
  static const String addDependentHIV = '/user/dependent/add_hiv_viral_load';

  static const String viewDependentBodyFatPercentage = '/user/dependent/view_fitness_body_fat_percentage';
  static const String addDependentBodyFatPercentage = '/user/dependent/add_fitness_body_fat_percentage';

  static const String viewDependentCaloryConsumption = '/user/dependent/view_fitness_calory_consumption';
  static const String addDependentCaloryConsumption = '/user/dependent/add_fitness_calory_consumption';

  static const String viewDependentDailySteps = '/user/dependent/view_fitness_daily_steps';
  static const String addDependentDailySteps = '/user/dependent/add_fitness_daily_steps';

  static const String viewDependentWeight = '/user/dependent/view_fitness_weight';
  static const String addDependentWeight = '/user/dependent/add_fitness_weight';

  static const String viewDependentWaistCircumference = '/user/dependent/view_fitness_waist_circumference';
  static const String addDependentWaistCircumference = '/user/dependent/add_fitness_waist_circumference';

  static const String viewDependentGlassOfWater = '/user/dependent/view_fitness_glass_of_water';
  static const String addDependentGlassOfWater = '/user/dependent/add_fitness_glass_of_water';

  static const String viewDependentAlcoholConsumption = '/user/dependent/view_fitness_alcohol_consumption';
  static const String addDependentAlcoholConsumption = '/user/dependent/add_fitness_alcohol_consumption';

  static const String viewDependentSleepHours = '/user/dependent/view_fitness_sleep_hours';
  static const String addDependentSleepHours = '/user/dependent/add_fitness_sleep_hours';







}