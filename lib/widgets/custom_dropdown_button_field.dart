import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/manage/change_dropdown_cubit.dart';
import 'package:task_time/models/dropdown_item_model.dart';

class CustomDropdownButtonField extends StatelessWidget {
  const CustomDropdownButtonField({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final DropdownItemModel data;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeDropdownCubit(data.defaultValue),
      child: BlocBuilder<ChangeDropdownCubit, int>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: DropdownButtonFormField<int>(
              value: state,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                labelText: data.labelText,
                labelStyle: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6366F1), size: 18),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              items: List.generate(data.amount, (index) => index)
                  .map(
                    (val) => DropdownMenuItem<int>(
                      value: val,
                      child: Text(
                        '$val ${data.nameValue}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<ChangeDropdownCubit>().changeValue(value);
                  onChanged(value);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
