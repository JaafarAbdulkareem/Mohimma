import 'package:task_time/models/dropdown_item_model.dart';

const List<DropdownItemModel> dropdownData = [
  DropdownItemModel(amount: 31, labelText: 'الأيام', nameValue: 'يوم'),
  DropdownItemModel(amount: 24, labelText: 'الساعات', nameValue: 'ساعة'),
  DropdownItemModel(amount: 60, defaultValue: 5, labelText: 'الدقائق', nameValue: 'دقيقة'),
];
