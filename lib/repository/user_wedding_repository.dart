import 'package:wedding_guest/model/user_wedding.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserWeddingRepository {
  Future<void> addUserToWedding(UserWedding userWedding);
  Future<void> createUserWedding(User user);
  Future<void> createUserWeddingByEmail(String email);
  Future<void> updateUserWedding(UserWedding userWedding);
  Stream<UserWedding> getWeddingByUser(String userId);
  Future<List<UserWedding>> getAllUserByWedding(String weddingId);
  Future<UserWedding> getUserWeddingByUser(User user);
  Future<UserWedding> getUserWeddingByEmail(String email);
  Future<void> addUserId(UserWedding userWedding, User user);
  Stream<List<UserWedding>> getAllUserWedding(String weddingId);
  Future<void> deleteAllUserWeddingByWedding(String weddingId);
}
