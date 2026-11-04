import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/manage/task_cubit.dart';
import 'package:task_time/models/task_model.dart';
import 'package:task_time/widgets/task_detail_dialog.dart';

class ItemTask extends StatelessWidget {
  const ItemTask({
    super.key,
    required this.task,
    required this.isFinished,
    required this.formattedTime,
  });

  final TaskModel task;
  final bool isFinished;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => TaskDetailDialog(
              task: task,
              formattedTime: formattedTime,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: isFinished ? TextDecoration.lineThrough : null,
                        color: isFinished ? Colors.grey : Colors.black87,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: isFinished ? Colors.red : Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'الوقت: $formattedTime',
                          style: TextStyle(
                            color: isFinished ? Colors.red : Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 36,
                icon: Icon(
                  task.isRunning
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: isFinished
                      ? Colors.grey
                      : (task.isRunning ? Colors.orange : Colors.green),
                ),
                onPressed: isFinished
                    ? null
                    : () => context.read<TaskCubit>().toggleTimer(task.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  context.read<TaskCubit>().deleteTask(task.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
