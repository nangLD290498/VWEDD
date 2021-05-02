import 'package:equatable/equatable.dart';
import 'package:wedding_guest/model/category.dart';


abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  final Category cate;

  const AddTodo(this.cate);

  @override
  List<Object> get props => [cate];

  @override
  String toString() => 'AddTodo { todo: $cate }';
}

class UpdateTodo extends TodosEvent {
  final Category updatedTodo;

  const UpdateTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedTodo }';
}

class DeleteTodo extends TodosEvent {
  final Category todo;

  const DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteTodo { todo: $todo }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}

class TodosUpdated extends TodosEvent {
  final List<Category> cates;

  const TodosUpdated(this.cates);

  @override
  List<Object> get props => [cates];
}