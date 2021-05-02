import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_guest/bloc/category/bloc.dart';
import 'package:wedding_guest/repository/category_repository.dart';

class CateBloc extends Bloc<TodosEvent, TodosState> {
  final CategoryRepository _todosRepository;
  StreamSubscription _todosSubscription;

  CateBloc({@required CategoryRepository todosRepository})
      : assert(todosRepository != null),
        _todosRepository = todosRepository,
        super(TodosLoading());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdateToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    _todosSubscription?.cancel();
    _todosSubscription = _todosRepository.getallCategory().listen(
          (cates) => add(TodosUpdated(cates)),
        );
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.cates);
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
