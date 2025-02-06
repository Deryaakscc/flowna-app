class CalorieService {
  static final CalorieService _instance = CalorieService._internal();
  factory CalorieService() => _instance;
  CalorieService._internal();

  // Harris-Benedict denklemi ile BMR (Bazal Metabolik Hız) hesaplama
  double calculateBMR({
    required bool isFemale,
    required int age,
    required double weight,
    required double height,
  }) {
    if (isFemale) {
      return 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    } else {
      return 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
    }
  }

  // Aktivite seviyesine göre günlük kalori ihtiyacı hesaplama
  double calculateDailyCalories({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return bmr * 1.2;
      case ActivityLevel.lightlyActive:
        return bmr * 1.375;
      case ActivityLevel.moderatelyActive:
        return bmr * 1.55;
      case ActivityLevel.veryActive:
        return bmr * 1.725;
      case ActivityLevel.extraActive:
        return bmr * 1.9;
    }
  }

  // Hedef kiloya göre günlük kalori hesaplama
  double calculateTargetCalories({
    required double dailyCalories,
    required WeightGoal goal,
  }) {
    switch (goal) {
      case WeightGoal.lose:
        return dailyCalories - 500; // Haftada 0.5 kg vermek için
      case WeightGoal.maintain:
        return dailyCalories;
      case WeightGoal.gain:
        return dailyCalories + 500; // Haftada 0.5 kg almak için
    }
  }

  // Besin kalori hesaplama
  double calculateFoodCalories({
    required double protein,
    required double carbs,
    required double fat,
  }) {
    return (protein * 4) + (carbs * 4) + (fat * 9);
  }
}

enum ActivityLevel {
  sedentary, // Masa başı, az veya hiç egzersiz yok
  lightlyActive, // Hafif egzersiz (haftada 1-3 gün)
  moderatelyActive, // Orta egzersiz (haftada 3-5 gün)
  veryActive, // Yoğun egzersiz (haftada 6-7 gün)
  extraActive, // Çok yoğun egzersiz (günde 2 kez)
}

enum WeightGoal {
  lose,
  maintain,
  gain,
}