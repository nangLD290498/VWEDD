import 'package:wedding_guest/model/wedding.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class WeddingEvent extends Equatable {
  const WeddingEvent();
  @override
  List<Object> get props => [];
}

class ToggleAll extends WeddingEvent {
  final List<Wedding> weddings;
  const ToggleAll(this.weddings);

  @override
  List<Object> get props => [weddings];
}
class LoadWeddings extends WeddingEvent {
  const LoadWeddings();
}


