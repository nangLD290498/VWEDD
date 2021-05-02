import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "AppStarted";
  }
}

class LoggedIn extends AuthenticationEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "LoggedIn";
  }
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "LoggedOut";
  }
}
