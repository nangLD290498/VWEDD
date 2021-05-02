import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_guest/entity/user_wedding_entity.dart';
import 'package:wedding_guest/model/user_wedding.dart';
import 'package:wedding_guest/repository/user_wedding_repository.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserWeddingRepository extends UserWeddingRepository {
  final userWeddingCollection =
      FirebaseFirestore.instance.collection("user_wedding");

  @override
  Future<void> addUserToWedding(UserWedding userWedding) async {
    return userWeddingCollection
        .doc(userWedding.id)
        .update(userWedding.toEntity().toDocument());
  }

  @override
  Stream<UserWedding> getWeddingByUser(String userId) {
    return userWeddingCollection.doc(userId).snapshots().map((snapshot) =>
        UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot)));
  }

  @override
  Future<List<UserWedding>> getAllUserByWedding(String weddingId) async {
    QuerySnapshot querySnapshot = await userWeddingCollection
        .where("wedding_id", isEqualTo: weddingId)
        .get();
    return querySnapshot.docs.map((snapshot) {
      return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
    }).toList();
  }

  @override
  Future<void> createUserWedding(User user) {
    return userWeddingCollection
        .add(new UserWedding(user.uid, email: user.email).toEntity().toDocument());
  }

  @override
  Future<void> createUserWeddingByEmail(String email) {
    return userWeddingCollection
        .add(new UserWedding(email).toEntity().toDocument());
  }

  @override
  Future<void> updateUserWedding(UserWedding userWedding) {
    return userWeddingCollection
        .doc(userWedding.id)
        .set(userWedding.toEntity().toDocument());
  }

  @override
  Future<UserWedding> getUserWeddingByUser(User user) async {
    QuerySnapshot snapshots =
        await userWeddingCollection.where("email", isEqualTo: user.email).get();
    if (snapshots.size == 0) {
      return null;
    }

    DocumentSnapshot snapshot = snapshots.docs[0];
    return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
  }

  @override
  Future<UserWedding> getUserWeddingByEmail(String email) async {
    QuerySnapshot snapshots =
        await userWeddingCollection.where("email", isEqualTo: email).get();
    if (snapshots.size == 0) {
      return null;
    }

    DocumentSnapshot snapshot = snapshots.docs[0];
    return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
  }

  @override
  Future<void> addUserId(UserWedding userWedding, User user) {
    return userWeddingCollection.doc(userWedding.id).set(new UserWedding(
            user.email,
            role: userWedding.role,
            userId: user.uid,
            joinDate: userWedding.joinDate,
            weddingId: userWedding.weddingId)
        .toEntity()
        .toDocument());
  }

  @override
  Stream<List<UserWedding>> getAllUserWedding(String weddingId) {
    return userWeddingCollection
        .where("wedding_id", isEqualTo: weddingId)
        .orderBy("join_date", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> deleteAllUserWeddingByWedding(String weddingId) {
    return userWeddingCollection
        .where("wedding_id", isEqualTo: weddingId)
        .get()
        .then((snapshots) {
      for (DocumentSnapshot snapshot in snapshots.docs) {
        snapshot.reference.update({"wedding_id": null, "role": null});
      }
    });
  }
}
