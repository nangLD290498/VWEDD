import 'package:equatable/equatable.dart';
import 'package:wedding_guest/model/category.dart';
abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Category> cates;

  const TodosLoaded([this.cates = const []]);

  @override
  List<Object> get props => [cates];

  @override
  String toString() => 'TodosLoaded { todos: $cates }';
}

class TodosNotLoaded extends TodosState {}