//This file contains all the auth providers(through which we can sign in in our app) such as
// google,facebook,github which we have now or which we can add in future
//The AuthProvider class encapsulates all the providers which we have now or which we add in future and make a nice interface to them
//Now we need the current user which we have extracted from the firebase and have it in our AuthUser class so
// we'll now import that class and create an instance of that class
import 'package:first_app/services/auth/auth_user.dart';
import 'package:flutter/cupertino.dart';
abstract class AuthProvider{
  Future<void> Initialize();
  AuthUser? get currentUser;// currentUser is a getter which returns the current user from the firebase( ? indicates that value returned by AuthUser can be null)
  Future<AuthUser> logIn({
    required String email,
    required String password
  });//When we make a function,we can give default value of the arguments used inside the curly braces such
// that if the user doesn't give any value it takes the default value
//   Also if we don't give the required value and the user also doesn't provide it,we can make
//   the argument as required so that it has to take the value otherwise error is generated.
  Future<AuthUser> signUp({
    required String email,
    required String password
  });
  Future<void> logOut();
  Future<void> sendVerificationEmail();
}