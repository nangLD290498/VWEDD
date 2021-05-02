

import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/model/invitation.dart';

@immutable
abstract class InvitationState {}

class InvitationCardLoading extends InvitationState {}

class InvitationCardLoaded extends InvitationState {
  InvitationCard invitationCard;
  InvitationCardLoaded( this.invitationCard);
}
