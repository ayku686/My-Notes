import 'package:first_app/services/auth/auth_provider.dart';
import 'package:first_app/services/auth/auth_user.dart';
import 'package:first_app/services/auth/firebase_auth_provider.dart';
class AuthService implements AuthProvider{

  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() =>AuthService(FirebaseAuthProvider());
  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) => provider.logIn(email: email, password: password);

  @override
  Future<void> logOut()  => provider.logOut();

  @override
  Future<void> sendVerificationEmail() => provider.sendVerificationEmail();

  @override
  Future<AuthUser> signUp({required String email, required String password}) => provider.signUp(email: email, password: password);

  @override
  Future<void> Initialize() => provider.Initialize();
}