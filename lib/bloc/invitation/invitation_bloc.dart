import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:wedding_guest/model/invitation.dart';
import 'package:wedding_guest/repository/invitation_repository.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';


class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationCardRepository _invitationRepository;

  InvitationBloc({@required InvitationCardRepository invitationCardRepository})
      :assert(invitationCardRepository != null),
        _invitationRepository =invitationCardRepository,
        super(InvitationCardLoading());

  @override
  Stream<InvitationState> mapEventToState(
    InvitationEvent event,
  ) async* {
    if(event is LoadInvitationCard){
      yield* _mapLoadInvitationToState(event);
    }
  }

  Stream<InvitationState> _mapLoadInvitationToState(LoadInvitationCard event) async* {
    InvitationCard invitationCard = await _invitationRepository.getInvitationCardById(event.weddingID);
    yield InvitationCardLoaded(invitationCard);
  }
}
