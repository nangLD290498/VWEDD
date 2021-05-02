import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_guest/entity/guest_entity.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/repository/guests_repository.dart';


class FirebaseGuestRepository extends GuestsRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');

  @override
  Future<void> createGuest(Guest guest, String weddingId) {
    return weddingCollection.doc(weddingId).collection('guest')
        .add(guest.toEntity().toDocument());
  }

  @override
  Future<void> deleteGuest(Guest guest, String weddingId) {
    return weddingCollection.doc(weddingId).collection('guest')
        .doc(guest.id)
        .delete();
  }

  @override
  Stream<List<Guest>> readGuest(String weddingId) {
    return weddingCollection.doc(weddingId).collection('guest').snapshots().map(
            (snapshot) => snapshot.docs.map(
                    (doc) => Guest.fromEntity(GuestEntity.fromSnapshot(doc))
            ).toList()
    );
  }

  @override
  Future<void> updateGuest(Guest guest, String weddingId) {
    return weddingCollection.doc(weddingId).collection('guest')
        .doc(guest.id)
        .update(guest.toEntity().toDocument());
  }

  @override
  Future<Guest> readGuestByID(String weddingId, String guestID) async {
    DocumentSnapshot snapshots = await weddingCollection.doc(weddingId).collection('guest')
        .doc(guestID)
        .get();
    if (snapshots == null) {
      return null;
    }
    return Guest.fromEntity(
        GuestEntity.fromSnapshot(snapshots));
  }

}