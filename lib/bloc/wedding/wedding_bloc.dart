import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_guest/repository/wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class WeddingBloc extends Bloc<WeddingEvent, WeddingState> {
  final WeddingRepository _weddingRepository;
  StreamSubscription _streamSubscription;

  WeddingBloc(
      {@required WeddingRepository weddingRepository})
      : assert(weddingRepository != null),
        _weddingRepository = weddingRepository,
        super(WeddingLoading());

  @override
  Stream<WeddingState> mapEventToState(WeddingEvent event) async* {
     if (event is LoadWeddings) {
      yield* _mapWeddingsLoadToState();
    }   else if (event is ToggleAll) {
       yield* _mapToggleAllToState(event);
     }
  }




  Stream<WeddingState> _mapWeddingsLoadToState() async* {
    _streamSubscription?.cancel();
    _streamSubscription = _weddingRepository.getAllWedding().listen(
          (weddings) => add(ToggleAll(weddings)),
    );
  }

  Stream<WeddingState> _mapToggleAllToState(ToggleAll event) async* {
    yield WeddingLoaded(event.weddings);
  }


  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
