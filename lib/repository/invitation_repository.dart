import 'package:wedding_guest/model/invitation.dart';

abstract class InvitationCardRepository {
  Future<InvitationCard> getInvitationCardById(String weddingId);
}
