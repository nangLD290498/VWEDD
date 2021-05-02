import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/bloc/authentication/bloc.dart';
import 'package:wedding_guest/model/user_wedding.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/repository/user_repository.dart';
import 'package:wedding_guest/repository/user_wedding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_guest/repository/wedding_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final UserWeddingRepository _userWeddingRepository;
  final WeddingRepository _weddingRepository;

  AuthenticationBloc(
      {@required UserRepository userRepository,
      @required UserWeddingRepository userWeddingRepository,
      @required WeddingRepository weddingRepository})
      : assert(userRepository != null),
        assert(userWeddingRepository != null),
        assert(weddingRepository != null),
        _userRepository = userRepository,
        _userWeddingRepository = userWeddingRepository,
        _weddingRepository = weddingRepository,
        super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isAuthenticated = await _userRepository.isAuthenticated();
      if (isAuthenticated) {
        final isEmailVerified = await _userRepository.isEmailVerified();
        if (isEmailVerified) {
          final user = await _userRepository.getUser();
          final UserWedding userWedding =
          await _userWeddingRepository.getUserWeddingByUser(user);
          if (userWedding.weddingId == null) {
            yield Unauthenticated();
          } else {
            yield Authenticated(user);
          }
        } else {
          yield Unauthenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      print("[ERROR]" + e);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final user = await _userRepository.getUser();
    final UserWedding userWedding =
    await _userWeddingRepository.getUserWeddingByUser(user);
    if (userWedding.weddingId == null) {
      yield WeddingNull(user);
    } else {
      Wedding wedding = await _weddingRepository.getWeddingById(userWedding.weddingId);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("wedding_id", userWedding.weddingId);
      await preferences.setString(
          "user_wedding", jsonEncode(userWedding.toEntity().toJson()));
      await preferences.setString(
          "wedding", jsonEncode(wedding.toEntity().toJson()));
      yield Authenticated(user);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("wedding_id");
    preferences.remove("user_wedding");
    preferences.remove('wedding');
    yield Unauthenticated();
    _userRepository.signOut();
  }
}