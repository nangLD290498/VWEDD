import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserWeddingEntity extends Equatable {
  final String id;
  final String userId;
  final String weddingId;
  final String role;
  final String email;
  final DateTime joinDate;

  UserWeddingEntity(this.id, this.userId, this.weddingId, this.role, this.email,
      this.joinDate);

  @override
  List<Object> get props => [id, userId, weddingId, role, email, joinDate];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "wedding_id": weddingId,
      "role": role,
      "email": email,
      "join_date": joinDate
    };
  }

  static UserWeddingEntity fromJson(Map<String, Object> json) {
    return UserWeddingEntity(
        json["id"] as String,
        json["user_id"] as String,
        json["wedding_id"] as String,
        json["role"] as String,
        json["email"] as String,
        (json["join_date"] as Timestamp).toDate());
  }

  static UserWeddingEntity fromSnapshot(DocumentSnapshot snapshot) {
    return UserWeddingEntity(
        snapshot.id,
        snapshot.get("user_id"),
        snapshot.get("wedding_id"),
        snapshot.get("role"),
        snapshot.get("email"),
        snapshot.get("join_date") == null
            ? null
            : (snapshot.get("join_date") as Timestamp).toDate());
  }

  Map<String, Object> toDocument() {
    return {
      "user_id": userId,
      "wedding_id": weddingId,
      "role": role,
      "email": email,
      "join_date": joinDate
    };
  }
}
