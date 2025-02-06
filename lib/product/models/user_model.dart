class UserModel {
  final String id;
  final String name;
  final String email;
  final int dailyWaterGoal;
  final int dailyCalorieGoal;
  final int sleepGoal;
  final bool exerciseNotifications;
  final bool waterNotifications;
  final bool motivationNotifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dailyWaterGoal = 2000,
    this.dailyCalorieGoal = 2000,
    this.sleepGoal = 8,
    this.exerciseNotifications = true,
    this.waterNotifications = true,
    this.motivationNotifications = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dailyWaterGoal: json['dailyWaterGoal'] as int? ?? 2000,
      dailyCalorieGoal: json['dailyCalorieGoal'] as int? ?? 2000,
      sleepGoal: json['sleepGoal'] as int? ?? 8,
      exerciseNotifications: json['exerciseNotifications'] as bool? ?? true,
      waterNotifications: json['waterNotifications'] as bool? ?? true,
      motivationNotifications: json['motivationNotifications'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dailyWaterGoal': dailyWaterGoal,
      'dailyCalorieGoal': dailyCalorieGoal,
      'sleepGoal': sleepGoal,
      'exerciseNotifications': exerciseNotifications,
      'waterNotifications': waterNotifications,
      'motivationNotifications': motivationNotifications,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? dailyWaterGoal,
    int? dailyCalorieGoal,
    int? sleepGoal,
    bool? exerciseNotifications,
    bool? waterNotifications,
    bool? motivationNotifications,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      exerciseNotifications: exerciseNotifications ?? this.exerciseNotifications,
      waterNotifications: waterNotifications ?? this.waterNotifications,
      motivationNotifications: motivationNotifications ?? this.motivationNotifications,
    );
  }
} 