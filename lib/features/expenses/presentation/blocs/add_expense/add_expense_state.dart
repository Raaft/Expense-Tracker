
import 'package:equatable/equatable.dart';

class AddExpenseState extends Equatable {
  final bool saving;
  final bool success;
  final String? error;

  const AddExpenseState({this.saving = false, this.success = false, this.error});

  AddExpenseState copyWith({bool? saving, bool? success, String? error}) {
    return AddExpenseState(saving: saving ?? this.saving, success: success ?? this.success, error: error);
  }

  @override
  List<Object?> get props => [saving, success, error];
}
