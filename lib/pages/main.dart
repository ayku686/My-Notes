import 'package:first_app/notes/create_update_note_view.dart';
import 'package:first_app/notes/notesview.dart';
import 'package:first_app/pages/loginpage.dart';
import 'package:first_app/pages/registrationsuccessful.dart';
import 'package:first_app/pages/sign_uppage.dart';
import 'package:first_app/pages/understanding_bloc.dart';
import 'package:first_app/pages/verifyemail.dart';
import 'package:first_app/services/auth/bloc/auth_bloc.dart';
import 'package:first_app/services/auth/firebase_auth_provider.dart';
import 'package:first_app/utilities/MyTheme.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: home()),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: MyTheme.lightTheme(context),
        darkTheme: MyTheme.darkTheme(context),
        // initialRoute: MyRoutes.homeRoute,
        routes: {
          MyRoutes.NotesviewRoute: (context) => NotesView(),
          MyRoutes.loginRoute: (context) => LoginPage(),
          MyRoutes.signupRoute: (context) => signUpPage(),
          MyRoutes.verifyemailRoute: (context) => verifyemail(),
          MyRoutes.homeRoute: (context) => home(),
          MyRoutes.createUpdateNote: (context) => createUpdateNote(),
           MyRoutes.regsuccess: (context) => regsuccessfull(),
          // "/regsuccessfull/":(context) => const regsuccessfull()
          "/BlocDemo/":(context) => const BlocDemo()
        }
    );
  }
}

