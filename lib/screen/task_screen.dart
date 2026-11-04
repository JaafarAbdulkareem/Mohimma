import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/manage/task_cubit.dart';
import 'package:task_time/models/task_model.dart';
import 'package:task_time/widgets/custom_floating_action_button.dart';
import 'package:task_time/widgets/item_task.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  String _formatTime(int totalSeconds) {
    int days = totalSeconds ~/ 86400;
    int hours = (totalSeconds % 86400) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> parts = [];
    if (days > 0) parts.add('${days}ي');
    parts.add('${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المهام والعد التنازلي'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<TaskCubit, List<TaskModel>>(
        builder: (context, tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد مهام حالياً\nاضغط على "مهمة جديدة" للبدء',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isFinished = task.remainingSeconds == 0;
              final formatted = _formatTime(task.remainingSeconds);

              return ItemTask(
                task: task,
                isFinished: isFinished,
                formattedTime: formatted,
              );
            },
          );
        },
      ),
      floatingActionButton: const CustomFloatingActionButton(),
    );
  }
}
