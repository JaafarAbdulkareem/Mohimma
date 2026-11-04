import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:task_time/models/task_model.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit() : super([]);

  final Map<String, Timer> _timers = {};
  final AudioPlayer _audioPlayer = AudioPlayer();

  void addTask({
    required String title,
    String? description,
    required int days,
    required int hours,
    required int minutes,
  }) {
    final totalSecs = (days * 86400) + (hours * 3600) + (minutes * 60);
    if (totalSecs <= 0 || title.trim().isEmpty) return;

    final newTask = TaskModel(
      id: DateTime.now().toIso8601String(),
      title: title.trim(),
      description: description?.trim().isEmpty == true ? null : description?.trim(),
      totalSeconds: totalSecs,
      remainingSeconds: totalSecs,
      isRunning: false,
      createdAt: DateTime.now(),
    );

    emit([...state, newTask]);
  }

  void deleteTask(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    emit(state.where((task) => task.id != id).toList());
  }

  void toggleTimer(String id, {required Function(String) onFinished}) {
    final index = state.indexWhere((element) => element.id == id);
    if (index == -1) return;

    final task = state[index];

    if (task.isRunning) {
      _timers[id]?.cancel();
      _updateTaskState(index, task.copyWith(isRunning: false));
    } else {
      if (task.remainingSeconds <= 0) return;

      final updatedList = List<TaskModel>.from(state);
      updatedList[index] = task.copyWith(isRunning: true);
      emit(updatedList);

      _timers[id] = Timer.periodic(const Duration(seconds: 1), (timer) {
        final currentIndex = state.indexWhere((element) => element.id == id);
        if (currentIndex == -1) {
          timer.cancel();
          return;
        }

        final currentTask = state[currentIndex];
        if (currentTask.remainingSeconds > 1) {
          _updateTaskState(
            currentIndex,
            currentTask.copyWith(
              remainingSeconds: currentTask.remainingSeconds - 1,
            ),
          );
        } else {
          timer.cancel();
          _updateTaskState(
            currentIndex,
            currentTask.copyWith(remainingSeconds: 0, isRunning: false),
          );
          _playSound();
          onFinished(currentTask.title);
        }
      });
    }
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('alarm.mp3'));
    } catch (_) {
      // Catch exceptions silently if sound device is unavailable
    }
  }

  void _updateTaskState(int index, TaskModel updatedTask) {
    final updatedList = List<TaskModel>.from(state);
    updatedList[index] = updatedTask;
    emit(updatedList);
  }

  @override
  Future<void> close() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _audioPlayer.dispose();
    return super.close();
  }
}
