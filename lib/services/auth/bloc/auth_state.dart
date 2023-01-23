//Now we are going to implement auth_event,auth_state and auth_bloc so that our UI
//doesn't communicate directly with the firebase
//auth_event goes into the auth_bloc as input and auth_state comes out of the auth_bloc as output
//Now our auth_state can have three states either logged in, the user is getting logged in or logged out with an error
import 'package:first_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState{
  const AuthState();
}
class AuthStateUnInitialized extends AuthState{
  const AuthStateUnInitialized();
}
class AuthStateRegistering extends AuthState{
  final Exception? exception;
  AuthStateRegistering({required this.exception});

}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  AuthStateLoggedIn(this.user);
}

class AuthStateNeedsEmailVerification extends AuthState{
  const AuthStateNeedsEmailVerification();
}
//Now here AuthStateLoggedOut has three substates
//1. The AuthStateLoggedOut with an exception
//2. The AuthStateLoggedOut with exception as null
//3. The AuthStateLoggedOut with the state as loading
//So now our app needs to understand that although these three states are instances of the same class
// they might not be same internally. So we need to create a sort of equality between these three instances.
//Here steps in the equatable library
class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading});
  @override
  List<Object?> get props => [
    exception,
    isLoading
  ];
}