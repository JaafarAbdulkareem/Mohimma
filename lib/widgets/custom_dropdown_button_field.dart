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
          return DropdownButtonFormField<int>(
            value: state,
            decoration: InputDecoration(
              labelText: data.labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            items: List.generate(data.amount, (index) => index)
                .map(
                  (val) => DropdownMenuItem<int>(
                    value: val,
                    child: Text('$val ${data.nameValue}'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<ChangeDropdownCubit>().changeValue(value);
                onChanged(value);
              }
            },
          );
        },
      ),
    );
  }
}
