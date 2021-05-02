import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<bool> isAuthenticated();

  Future<void> authenticate();

  Future<User> getUser();

  Future<User> signInWithGoogle();

  Future<User> signInWithCredentials(String email, String password);

  Future<User> signUp({String email, String password});

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);
}
