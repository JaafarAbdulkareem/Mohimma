import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/data/dropdown_item_data.dart';
import 'package:task_time/manage/task_cubit.dart';
import 'package:task_time/widgets/custom_dropdown_button_field.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  void _showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    int selectedDays = 0;
    int selectedHours = 0;
    int selectedMinutes = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'إضافة مهمة جديدة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان المهمة (مطلوب)',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال عنوان المهمة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'الوصف (اختياري)',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdownButtonField(
                          data: dropdownData[0],
                          onChanged: (val) => selectedDays = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomDropdownButtonField(
                          data: dropdownData[1],
                          onChanged: (val) => selectedHours = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomDropdownButtonField(
                          data: dropdownData[2],
                          onChanged: (val) => selectedMinutes = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final totalSecs = (selectedDays * 86400) + (selectedHours * 3600) + (selectedMinutes * 60);
                        if (totalSecs <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('يرجى تحديد وقت أكبر من الصفر!'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        context.read<TaskCubit>().addTask(
                              title: titleController.text,
                              description: descriptionController.text,
                              days: selectedDays,
                              hours: selectedHours,
                              minutes: selectedMinutes,
                            );
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('حفظ وإضافة المهمة', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddTaskBottomSheet(context),
      icon: const Icon(Icons.add),
      label: const Text('مهمة جديدة'),
    );
  }
}
