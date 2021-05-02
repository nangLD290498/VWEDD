
import 'package:wedding_guest/entity/user_wedding_entity.dart';

class UserWedding {
  final String id;
  final String userId;
  final String weddingId;
  final String role;
  final String email;
  final DateTime joinDate;

  UserWedding(this.id,
      {String email,
      String userId,
      String weddingId,
      String role,
      DateTime joinDate})
      : this.email = email,
        this.userId = userId,
        this.weddingId = weddingId,
        this.role = role,
        this.joinDate = joinDate;

  UserWedding copyWith(
      {String email,
      String id,
      String userId,
      String weddingId,
      String role,
      DateTime joinDate}) {
    return UserWedding(id ?? this.id,
        email: email ?? this.email,
        userId: userId ?? this.userId,
        weddingId: weddingId ?? this.weddingId,
        role: role ?? this.role,
        joinDate: joinDate ?? this.joinDate);
  }

  static UserWedding fromEntity(UserWeddingEntity entity) {
    return UserWedding(entity.id,
        email: entity.email,
        userId: entity.userId,
        weddingId: entity.weddingId,
        role: entity.role,
        joinDate: entity.joinDate);
  }

  UserWeddingEntity toEntity() {
    return UserWeddingEntity(id, userId, weddingId, role, email, joinDate);
  }

  @override
  String toString() {
    return 'UserWedding{userId: $userId, weddingId: $weddingId, role: $role, email: $email, joinDate: $joinDate}';
  }
}
