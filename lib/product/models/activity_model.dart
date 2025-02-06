enum ActivityType {
  water,
  sleep,
  exercise,
  nutrition,
}

class ActivityModel {
  final String id;
  final String userId;
  final ActivityType type;
  final DateTime timestamp;
  final double value;
  final String? note;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    required this.value,
    this.note,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == 'ActivityType.${json['type']}',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'note': note,
    };
  }

  ActivityModel copyWith({
    String? id,
    String? userId,
    ActivityType? type,
    DateTime? timestamp,
    double? value,
    String? note,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      note: note ?? this.note,
    );
  }
} 