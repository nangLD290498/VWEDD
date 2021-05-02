import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/model/user_wedding.dart';
import 'package:wedding_guest/repository/user_repository.dart';
import 'package:wedding_guest/repository/user_wedding_repository.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedding_guest/util/validations.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  final UserWeddingRepository _userWeddingRepository;
  LoginBloc({
    @required UserRepository userRepository,@required UserWeddingRepository userWeddingRepository,
  })  : assert(userRepository != null), assert(userWeddingRepository != null),
        _userRepository = userRepository,
        _userWeddingRepository = userWeddingRepository,
        super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events, transitionFn) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validation.isEmailValid(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validation.isPasswordValid(password));
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (e) {
      print("[ERROR] : $e");
      yield LoginState.failure(message: "Có lỗi xảy ra");
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      final user = await _userRepository.signInWithCredentials(email, password);
      final user1 = await _userRepository.getUser();
      final UserWedding userWedding =
     await _userWeddingRepository.getUserWeddingByUser(user1);

      if (user == null) {
        yield LoginState.failure(message: "Có lỗi xảy ra");
      } else {
        if (!user.emailVerified) {
          yield LoginState.failure(message: "Bạn chưa xác nhận email");
        } else if(userWedding.role!='admin'){
          yield LoginState.failure(message: "Bạn không được cấp quyền truy cập");
        }
        else {
          yield LoginState.success();
        }
      }
    } on EmailNotFoundException{
      yield LoginState.failure(message: "Tài khoản không tồn tại");
    } on WrongPasswordException{
      yield LoginState.failure(message: "Sai mật khẩu");
    } on TooManyRequestException{
      yield LoginState.failure(
          message:
          "Bạn đã đăng nhập quá nhiều lần. Hãy thử lại trong giây lát");
    } on FirebaseException{
      yield LoginState.failure(message: "Có lỗi xảy ra");
    }catch (e) {
      print("[ERROR] : $e");
      yield LoginState.failure(message: "Có lỗi xảy ra");
    }
  }
}
