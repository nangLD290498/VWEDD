import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_guest/entity/invitation_entity.dart';
import 'package:wedding_guest/entity/wedding_entity.dart';
import 'package:wedding_guest/model/invitation.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/repository/invitation_repository.dart';
import 'package:wedding_guest/repository/wedding_repository.dart';

class FirebaseInvitationCardRepository extends InvitationCardRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');

  @override
  Future<InvitationCard> getInvitationCardById(String weddingId) async {
    DocumentSnapshot snapshots = await weddingCollection.doc(weddingId).collection('invitation_card')
        .doc("1")
        .get();
    if (snapshots == null) {
      return null;
    }
    return InvitationCard.fromEntity(
        InvitationCartEntity.fromSnapshot(snapshots));
  }

}

