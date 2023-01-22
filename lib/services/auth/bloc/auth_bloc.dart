import 'package:first_app/services/auth/auth_provider.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//This is our AuthBloc which takes AuthState as input and gives AuthEvent as output
//This AuthBloc is responsible for handling everything related to authentication(i.e., initializing the log in process, then log in and then logout
class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){//Here we have initialized our bloc with initial state as AuthStateLoading
    //Initialize
    on<AuthEventInitialize>((event, emit) async{
      await provider.Initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(const AuthStateLoggedOut());
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsEmailVerification());
      }else{
        emit(AuthStateLoggedIn(user) );
      }
    });

  //  log in
    on<AuthEventLogIn>((event, emit) async{
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(
            email: email,
            password: password);
        emit(AuthStateLoggedIn(user));
      }on Exception catch(e){
        emit(AuthStateLogInFailure(e));
      }
    });

  //  log out
    on<AuthEventLogOut>((event, emit) async{
      try{
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      }
      on Exception catch(e){
        emit(AuthStateLogOutFailure(e));
      }
    });
  }
}