//Now we are going to implement auth_event,auth_state and auth_bloc so that our UI
//doesn't communicate directly with the firebase
//auth_event goes into the auth_bloc as input and auth_state comes out of the auth_bloc as output
//Now our auth_state can have three states either logged in, the user is getting logged in or logged out with an error
import 'package:first_app/services/auth/auth_user.dart';

abstract class AuthState{
  const AuthState();
}
class AuthStateLoading extends AuthState{
  const AuthStateLoading();
}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  AuthStateLoggedIn(this.user);
}

class AuthStateNeedsEmailVerification extends AuthState{
  const AuthStateNeedsEmailVerification();
}
class AuthStateLoggedOut extends AuthState{
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}
class AuthStateLogOutFailure extends AuthState{
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}