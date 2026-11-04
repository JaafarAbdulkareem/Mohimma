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
    final statusColor = isFinished
        ? const Color(0xFFEF4444)
        : (task.isRunning ? const Color(0xFF10B981) : const Color(0xFFF59E0B));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
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
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Status Indicator bar
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title, description, and time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: isFinished ? TextDecoration.lineThrough : null,
                            decorationColor: statusColor,
                            color: isFinished ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                          ),
                        ),
                        if (task.description != null && task.description!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            task.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              isFinished ? Icons.alarm_off_rounded : Icons.timer_outlined,
                              size: 14,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                formattedTime,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Play / Pause Button
                  IconButton(
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      task.isRunning
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: isFinished ? const Color(0xFFCBD5E1) : statusColor,
                    ),
                    onPressed: isFinished
                        ? null
                        : () => context.read<TaskCubit>().toggleTimer(task.id),
                  ),
                  const SizedBox(width: 6),
                  // Delete Button
                  IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                    onPressed: () {
                      context.read<TaskCubit>().deleteTask(task.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
