
import 'package:flutter/cupertino.dart';

@immutable
abstract class InvitationEvent {}

class LoadInvitationCard extends InvitationEvent{
  String weddingID;
  LoadInvitationCard( this.weddingID);
}
