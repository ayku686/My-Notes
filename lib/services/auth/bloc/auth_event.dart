import 'package:flutter/cupertino.dart';
//This file contains events which act as input to the bloc
@immutable
abstract class AuthEvent{
  const AuthEvent();
}
class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}
class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}
class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}
class AuthEventForgottenPassword extends AuthEvent{
  final String? email;
  const AuthEventForgottenPassword({this.email});
}
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn({required this.email,required this.password});
}
class AuthEventSendEmailVerification extends AuthEvent{
  const AuthEventSendEmailVerification();
}
class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}
