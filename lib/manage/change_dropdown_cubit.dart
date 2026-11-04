import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeDropdownCubit extends Cubit<int> {
  ChangeDropdownCubit(super.initialValue);

  void changeValue(int value) {
    emit(value);
  }
}
