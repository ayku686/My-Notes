import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';
@immutable
class AuthUser {
  final String? email;//It stores the email of the current user
  final bool isEmailVerified;
  const AuthUser({required this.email, required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(
      email: user.email,
      isEmailVerified: user.emailVerified);//AuthUser.fromFirebase(User user) extracts the current user details from the firebase and sends it to user of class AuthUser.This user.emailVerified checks if the email is verified or not and returns it to the constructor AuthUser(this.isEmailVerified)
}