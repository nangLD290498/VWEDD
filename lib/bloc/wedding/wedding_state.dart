import 'package:equatable/equatable.dart';
import 'package:wedding_guest/model/wedding.dart';

abstract class WeddingState extends Equatable {
  final String isSubmitted;
  const WeddingState([this.isSubmitted]);

  @override
  List<Object> get props => [];
}

class WeddingLoading extends WeddingState {}

class WeddingLoaded extends WeddingState {
  final List<Wedding> weddings;
  WeddingLoaded(this.weddings);

  @override
  List<Object> get props => [weddings];
}


