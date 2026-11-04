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
    if (days > 0) parts.add('$days يوم');
    parts.add(
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_rounded, color: Color(0xFF6366F1), size: 22),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'إدارة المهام والعد التنازلي',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<TaskCubit, List<TaskModel>>(
        builder: (context, tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.timer_outlined,
                          size: 56, color: Color(0xFF6366F1)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'لا توجد مهام حالياً',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اضغط على زر "مهمة جديدة" في الأسفل لإضافة مهمة وحدد العد التنازلي',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 90),
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
