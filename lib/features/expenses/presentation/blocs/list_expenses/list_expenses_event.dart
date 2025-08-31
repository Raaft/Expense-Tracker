
import 'package:equatable/equatable.dart';

abstract class ListExpensesEvent extends Equatable {
  const ListExpensesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFirstPage extends ListExpensesEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadFirstPage({this.from, this.to});
}

class LoadNextPage extends ListExpensesEvent {}
