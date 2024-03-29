import 'package:first_app/helpers/loading/LoadingScreen.dart';
import 'package:first_app/notes/notesview.dart';
import 'package:first_app/pages/loginpage.dart';
import 'package:first_app/pages/sign_uppage.dart';
import 'package:first_app/pages/verifyemail.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
class home  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return Material(
        child: BlocConsumer<AuthBloc ,AuthState>(
          listener: (context,state) {
            if (state.isLoading) {
              LoadingScreen().show(
                  context: context,
                  text: state.loadingText ?? 'Please wait a moment');
            }else{
              LoadingScreen().hide();
            }
          },
          builder: (context,state){
            if (state is AuthStateLoggedIn) {
              return const NotesView();
            }
            else if (state is AuthStateNeedsEmailVerification) {
              return const verifyemail();
            }
            else if(state is AuthStateRegistering){
              return signUpPage();
            }
            else if (state is AuthStateLoggedOut) {
              return LoginPage();
            }
            else {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }
          }
        )

    );
  }
}