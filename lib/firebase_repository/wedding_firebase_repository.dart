import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_guest/entity/wedding_entity.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/repository/wedding_repository.dart';

class FirebaseWeddingRepository extends WeddingRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');


  @override
  Stream<Wedding> getWedding(String weddingId) {
    return weddingCollection.doc(weddingId).snapshots().map(
        (snapshot) => Wedding.fromEntity(WeddingEntity.fromSnapshot(snapshot)));
  }

  @override
  Stream<List<Wedding>> getAllWedding() {
    return weddingCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Wedding.fromEntity(WeddingEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Wedding> getWeddingById(String weddingId) async {
    DocumentSnapshot snapshot = await weddingCollection.doc(weddingId).get();
    return Wedding.fromEntity(WeddingEntity.fromSnapshot(snapshot));
  }

}

