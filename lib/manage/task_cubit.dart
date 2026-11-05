import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/models/task_model.dart';
import 'package:task_time/services/notification_service.dart';
import 'package:task_time/services/task_storage.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit(this._storage, this._notifications) : super([]);

  final TaskStorage _storage;
  final NotificationService _notifications;
  Timer? _ticker;

  /// Called when a task reaches zero while the app is open.
  void Function(String title)? onTaskFinished;

  /// Loads saved tasks, catches up on time that passed while the app was
  /// closed, and re-arms the alarms of tasks that are still running.
  Future<void> load() async {
    final List<TaskModel> saved = await _storage.load();
    final List<TaskModel> refreshed = _refresh(saved, DateTime.now()).tasks;
    emit(refreshed);
    for (final t in refreshed.where((t) => t.isRunning)) {
      await _notifications.scheduleAlarm(
        id: t.id,
        taskTitle: t.title,
        when: t.endAt!,
      );
    }
    await _storage.save(refreshed);
    _syncTicker();
  }

  /// Called when the app returns to the foreground.
  Future<void> onResume() async {
    _tick();
  }

  void addTask({
    required String title,
    String? description,
    required int days,
    required int hours,
    required int minutes,
  }) {
    final totalSecs = (days * 86400) + (hours * 3600) + (minutes * 60);
    if (totalSecs <= 0 || title.trim().isEmpty) return;

    final now = DateTime.now();
    final desc = description?.trim();
    final task = TaskModel(
      id: now.millisecondsSinceEpoch.remainder(0x7fffffff),
      title: title.trim(),
      description: (desc == null || desc.isEmpty) ? null : desc,
      totalSeconds: totalSecs,
      remainingSeconds: totalSecs,
      createdAt: now,
    );

    emit([...state, task]);
    _storage.save(state);
  }

  Future<void> deleteTask(int id) async {
    await _notifications.cancel(id);
    emit(state.where((t) => t.id != id).toList());
    await _storage.save(state);
    _syncTicker();
  }

  Future<void> toggleTimer(int id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final task = state[index];
    final now = DateTime.now();

    if (task.isRunning) {
      // Pause: remember what is left and cancel the alarm.
      await _notifications.cancel(id);
      _replace(
        index,
        task.copyWith(remainingSeconds: task.secondsLeft(now), clearEndAt: true),
      );
    } else {
      if (task.remainingSeconds <= 0) return;
      final endAt = now.add(Duration(seconds: task.remainingSeconds));
      _replace(index, task.copyWith(endAt: endAt));
      await _notifications.scheduleAlarm(
        id: id,
        taskTitle: task.title,
        when: endAt,
      );
    }
    await _storage.save(state);
    _syncTicker();
  }

  void _replace(int index, TaskModel updated) {
    final list = List<TaskModel>.from(state);
    list[index] = updated;
    emit(list);
  }

  ({List<TaskModel> tasks, List<TaskModel> finished}) _refresh(
    List<TaskModel> tasks,
    DateTime now,
  ) {
    final finished = <TaskModel>[];
    final result = tasks.map((t) {
      if (!t.isRunning) return t;
      final left = t.secondsLeft(now);
      if (left <= 0) {
        final done = t.copyWith(remainingSeconds: 0, clearEndAt: true);
        finished.add(done);
        return done;
      }
      return t.copyWith(remainingSeconds: left);
    }).toList();
    return (tasks: result, finished: finished);
  }

  void _tick() {
    final r = _refresh(state, DateTime.now());
    emit(r.tasks);
    if (r.finished.isNotEmpty) {
      _storage.save(r.tasks);
      for (final t in r.finished) {
        onTaskFinished?.call(t.title);
      }
    }
    _syncTicker();
  }

  /// Runs a 1-second UI refresh only while at least one task is running.
  void _syncTicker() {
    final anyRunning = state.any((t) => t.isRunning);
    if (anyRunning && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    } else if (!anyRunning) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
