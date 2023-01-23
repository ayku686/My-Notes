import 'package:first_app/services/auth/auth_provider.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//This is our AuthBloc which takes AuthState as input and gives AuthEvent as output
//This AuthBloc is responsible for handling everything related to authentication(i.e., initializing the log in process, then log in and then logout
class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateUnInitialized()){//Here we have initialized our bloc with initial state as AuthStateLoading
    //Initialize
    on<AuthEventInitialize>((event, emit) async{
      await provider.Initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false
        ));
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsEmailVerification());
      }else{
        emit(AuthStateLoggedIn(user) );
      }
    });

  //  log in
    on<AuthEventLogIn>((event, emit) async{
      emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true));
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(
            email: email,
            password: password
        );
        if(!user.isEmailVerified){
          emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false));
            emit(const AuthStateNeedsEmailVerification());
        }
        else{
          emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false));
          emit(AuthStateLoggedIn(user));;
        }
      }
      on Exception catch(e){
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    //Send email verification
    on<AuthEventSendEmailVerification>((event,emit) async{
      await provider.sendVerificationEmail();
      emit(state);
    });

    on<AuthEventShouldRegister>((event,emit){
      try{
        emit(AuthStateRegistering(exception:null));
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e, isLoading: true));
      }
    });

    //Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try{
        await provider.signUp(
          email: email,
          password: password
        );
        await provider.sendVerificationEmail();
        emit(const AuthStateNeedsEmailVerification());
      }on Exception catch(e){
        emit(AuthStateRegistering(exception: e));
      }
    });

  //  log out
    on<AuthEventLogOut>((event, emit) async{
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: true));
      }on Exception catch (e){
        emit(
          AuthStateLoggedOut(exception: e,
              isLoading:false)
        );
      }
    });
  }
}