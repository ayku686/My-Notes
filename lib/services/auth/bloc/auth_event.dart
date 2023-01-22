import 'package:flutter/cupertino.dart';
//This file contains events which act as input to the bloc
@immutable
abstract class AuthEvent{
  const AuthEvent();
}
class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn({required this.email,required this.password});
}
class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
} 