import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    required this.createdAt,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        totalSeconds,
        remainingSeconds,
        isRunning,
        createdAt,
      ];
}
