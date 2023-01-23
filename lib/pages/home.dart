import 'package:first_app/notes/notesview.dart';
import 'package:first_app/pages/loginpage.dart';
import 'package:first_app/pages/sign_uppage.dart';
import 'package:first_app/pages/verifyemail.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/services/auth/bloc/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../utilities/dialog/showAlertDialog.dart';

class home  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return Material(
        child: BlocBuilder<AuthBloc ,AuthState>(
          builder: (context,state) {
            if (state is AuthStateLoggedIn) {
              return const NotesView();
            }
            else if (state is AuthStateNeedsEmailVerification) {
              return verifyemail();
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