import 'package:wedding_guest/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailNotFoundException implements Exception{}
class WrongPasswordException implements Exception{}
class TooManyRequestException implements Exception{}
class EmailAlreadyInUseException implements Exception{}
class FirebaseException implements Exception{}

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseUserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  @override
  Future<void> authenticate() {
    throw UnimplementedError();
  }

  @override
  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<User> signInWithCredentials(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          user.sendEmailVerification();
        }
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.message);
        throw EmailNotFoundException;
      } else if (e.code == 'wrong-password') {
        print(e.message);
        throw WrongPasswordException();
      } else if (e.code == 'too-many-requests') {
        print(e.message);
        throw TooManyRequestException();
      } else {
        print(e.code);
        throw FirebaseException();
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Có lỗi xảy ra");
    }

    return null;
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential)
        .catchError(
            (onError) => {print('[Firebase Google Sign Up Error] : $onError')});

    final User user = userCredential.user;

    if (user != null) {
      if (!user.emailVerified) user.sendEmailVerification();
      return user;
    }

    return null;
  }

  @override
  Future<void> signOut() {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<User> signUp({String email, String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user;

      if (user != null) {
        user.sendEmailVerification();
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailNotFoundException();
      } else {
        print(e.code);
        throw FirebaseException();
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Có lỗi xảy ra");
    }

  }

  @override
  Future<bool> isEmailVerified() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser.emailVerified;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
