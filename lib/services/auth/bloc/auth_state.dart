//Now we are going to implement auth_event,auth_state and auth_bloc so that our UI
//doesn't communicate directly with the firebase
//auth_event goes into the auth_bloc as input and auth_state comes out of the auth_bloc as output
//Now our auth_state can have three states either logged in, the user is getting logged in or logged out with an error
import 'package:first_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState{
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}
class AuthStateUnInitialized extends AuthState{
  const AuthStateUnInitialized({required isLoading}) : super(isLoading: isLoading);
}
class AuthStateRegistering extends AuthState{
  final Exception? exception;
  AuthStateRegistering({required isLoading,required this.exception}) : super(isLoading: isLoading);

}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  AuthStateLoggedIn({required this.user,required isLoading}) : super(isLoading:  isLoading);
}
//This forgotten password can have three sub states
//1. The user pressed the forgotten password button for the first time
//2. The user was sent a password recovery mail by the firebase and it did not succeed(i.e., some exception arose)
//3. The user was sent a password recovery mail by the firebase and it succeeded(i.e.,no exceptions arose)
// class AuthStateForgottenPassword extends AuthState{
//
// }
class AuthStateNeedsEmailVerification extends AuthState{
  const AuthStateNeedsEmailVerification({required isLoading}) : super(isLoading: isLoading);
}
//Now here AuthStateLoggedOut has three sub states
//1. The AuthStateLoggedOut with an exception
//2. The AuthStateLoggedOut with exception as null
//3. The AuthStateLoggedOut with the state as loading
//So now our app needs to understand that although these three states are instances of the same class
// they might not be same internally. So we need to create a sort of equality between these three instances.
//Here steps in the equatable library
class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
    isLoading: isLoading,
    loadingText: loadingText,
  );
  @override
  List<Object?> get props => [
    exception,
    isLoading
  ];
}