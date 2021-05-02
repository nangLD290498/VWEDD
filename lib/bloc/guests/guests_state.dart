import 'package:equatable/equatable.dart';
import 'package:wedding_guest/model/guest.dart';

abstract class GuestsState extends Equatable{
  const GuestsState();

  @override
  List<Object> get props => [];
}

class GuestsLoading extends GuestsState{}

class GuestsSearching extends GuestsState{}

class GuestsLoaded extends GuestsState{
  final List<Guest> guests;

  GuestsLoaded([this.guests = const []]);

  @override
  List<Object> get props => [guests];

  @override
  String toString() => 'GuestsLoaded {guests: guests}';
}

class GuestsLoadedByID extends GuestsState{
  Guest guest;

  GuestsLoadedByID(this.guest);

  @override
  List<Object> get props => [guest];
}

class GuestsNotLoaded extends GuestsState{}

class GuestUpdated extends GuestsState{}

class GuestDeleted extends GuestsState{}

class GuestAdded extends GuestsState{}

class CompanionChose extends GuestsState{}