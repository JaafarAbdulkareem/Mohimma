import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  /// Also used as the Android notification id, so it must fit in 31 bits.
  final int id;
  final String title;
  final String? description;
  final int totalSeconds;

  /// Seconds left while the task is paused/finished. For a running task this
  /// is only a cached value for the UI; the real value comes from [endAt].
  final int remainingSeconds;

  /// Absolute moment the task ends. Non-null only while the task is running.
  final DateTime? endAt;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.endAt,
    required this.createdAt,
  });

  bool get isRunning => endAt != null;

  /// Seconds left right now, computed from the absolute end time.
  int secondsLeft([DateTime? now]) {
    final end = endAt;
    if (end == null) return remainingSeconds;
    final ms = end.difference(now ?? DateTime.now()).inMilliseconds;
    //999 is added to round up to the next second if there are any milliseconds left.
    //~/ is used to perform integer division, discarding any remainder. example: 1999 + 999 = 2998, 2998 ~/ 1000 = 2 seconds left.
    return ms <= 0 ? 0 : (ms + 999) ~/ 1000;
  }

  TaskModel copyWith({
    int? remainingSeconds,
    DateTime? endAt,
    bool clearEndAt = false,
  }) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      totalSeconds: totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      endAt: clearEndAt ? null : (endAt ?? this.endAt),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'totalSeconds': totalSeconds,
        'remainingSeconds': remainingSeconds,
        'endAt': endAt?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final endAtMs = json['endAt'] as int?;
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      totalSeconds: json['totalSeconds'] as int,
      remainingSeconds: json['remainingSeconds'] as int,
      endAt:
          endAtMs == null ? null : DateTime.fromMillisecondsSinceEpoch(endAtMs),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        totalSeconds,
        remainingSeconds,
        endAt,
        createdAt,
      ];
}
