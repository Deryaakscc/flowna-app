class AppConstants {
  static const String appName = 'Flowna';
  
  // API Endpoints
  static const String baseUrl = 'https://api.flowna.com';
  
  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  
  // Default Values
  static const int defaultDailyWaterGoal = 2000; // ml
  static const int defaultSleepGoal = 8; // hours
  static const int defaultCalorieGoal = 2000; // kcal
  
  // Notification Channels
  static const String exerciseChannelId = 'exercise_notifications';
  static const String waterChannelId = 'water_notifications';
  static const String motivationChannelId = 'motivation_notifications';
} 