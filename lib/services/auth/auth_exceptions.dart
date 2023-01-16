// This file we are creating so that our code looks clean
import 'package:first_app/utilities/dialog/showAlertDialog.dart';

//login page
class UserNotFoundAuthException implements Exception{

}
class WrongPasswordAuthException implements Exception{}

//signup page

class WeakPasswordAuthException implements Exception {

}
class InvalidEmailAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}

//generic exceptions

class UserNotLoggedInAuthException implements Exception{}
class GenericAuthException implements Exception{}