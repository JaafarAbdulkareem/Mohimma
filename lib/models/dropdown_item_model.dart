import 'package:equatable/equatable.dart';

class DropdownItemModel extends Equatable {
  final int amount;
  final int defaultValue;
  final String labelText;
  final String nameValue;

  const DropdownItemModel({
    required this.amount,
    this.defaultValue = 0,
    required this.labelText,
    required this.nameValue,
  });

  @override
  List<Object?> get props => [amount, defaultValue, labelText, nameValue];
}
