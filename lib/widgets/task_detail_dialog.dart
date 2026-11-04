import 'package:flutter/material.dart';
import 'package:task_time/models/task_model.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskModel task;
  final String formattedTime;

  const TaskDetailDialog({
    super.key,
    required this.task,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFinished = task.remainingSeconds == 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isFinished
                      ? Colors.red.withOpacity(0.15)
                      : theme.colorScheme.primary.withOpacity(0.15),
                  child: Icon(
                    isFinished ? Icons.alarm_off : Icons.timer,
                    color: isFinished ? Colors.red : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'الوصف:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.description ?? 'لا يوجد وصف مضاف لهذه المهمة.',
                style: TextStyle(
                  fontSize: 14,
                  color: task.description != null ? Colors.black87 : Colors.grey[500],
                  fontStyle: task.description == null ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوقت المتبقي:',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isFinished ? Colors.red : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isFinished
                        ? Colors.red.withOpacity(0.1)
                        : (task.isRunning ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFinished
                        ? 'منتهية'
                        : (task.isRunning ? 'قيد العد' : 'متوقفة'),
                    style: TextStyle(
                      color: isFinished
                          ? Colors.red
                          : (task.isRunning ? Colors.green[700] : Colors.orange[800]),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
