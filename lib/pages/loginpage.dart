import 'package:first_app/services/auth/auth_exceptions.dart';
import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/services/auth/bloc/auth_bloc.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/utilities/dialog/loading_dialog.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first_app/utilities/dialog/showAlertDialog.dart';

import '../services/auth/bloc/auth_state.dart';
//to make a Stateful widget select the class name and press ALT+ENTER and select Convert to Stateful Widget
class LoginPage extends StatefulWidget{
  @override

  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name="";
  final _Formkey=GlobalKey<FormState>();
  //A late keyword tells the compiler that though this field doesn't contain a value now it will surely have one in the future
  late final TextEditingController _email;
  late final TextEditingController _password;
  // Whenever the user modifies a text field with an associated TextEditingController, the text field updates value and the controller notifies its listeners. Listeners can then read the text and selection properties to learn what the user has typed or how the selection has been updated.
  //Remember to dispose of the TextEditingController when it is no longer needed. This will ensure we discard any resources used by the object.
  //These all things we are doing for authentication purpose
  //We are creating a link between our TextFormField and our login button so that when we firebase does authentication it gets the value of email and password which the user has entered
  CloseDialog? _closeDialogHandle;
  @override
  void initState(){
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateLoggedOut){
          final closeDialog = _closeDialogHandle;
          if(!state.isLoading && closeDialog != null){
            closeDialog();
            _closeDialogHandle = null;
          }
          else if(state.isLoading && closeDialog == null){
            _closeDialogHandle = showLoadingDialog(
                context: context,
                text: 'Loading');
          }
          if(state.exception is UserNotFoundAuthException){
            await showAlertDialog(context, 'User not found');
          }
          else if(state.exception is WrongPasswordAuthException){
            await showAlertDialog(context, 'Wrong Credentials');
          }
          else if(state.exception is GenericAuthException){
            await showAlertDialog(context, 'Authentication Error');
          }
        }
      },
      child: Material(

      color: Colors.white,
      child: SingleChildScrollView(
       child:FutureBuilder(
        future: AuthService.firebase().Initialize(),
      builder:(context,snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Form(
              key: _Formkey, //
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 0),
                    child: Image.asset("allimages/login.png",
                        fit: BoxFit.fitHeight),
                  ),

                  Text("Welcome $name", style: GoogleFonts.nerkoOne(
                      color: Colors.deepPurple,
                      fontSize: 35,
                      letterSpacing: 1
                    // fontWeight: FontWeight.bold,

                  ),
                  ),
                  Padding(
                    //to add padding just select the column and press ALT+ENTER
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Column(
                      children: [
                        Card(
                          child: TextFormField(
                            controller: _email,
                            enableSuggestions: true,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration:
                            const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4),
                                labelText: "Email",
                                hintText: "Enter your email address"
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              }
                              else {
                                return null;
                              }
                            },
                            //We have used this onChanged function to attach the username after the welcome text when the user types his name
                            // onChanged: (value){
                            //   name=value;
                            //   setState(() {});
                            // },
                          ),
                        ),
                        const SizedBox(
                            height: 10
                        ),
                        Card(
                          borderOnForeground: true,
                          color: Colors.white,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: _password,

                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 4),
                              labelText: "Password",
                              hintText: "Enter your password ",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value.length < 8) {
                                return "Password must contain at least 8 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(30.0),
                        //   child: ElevatedButton(
                        //     child: Text("Login"),
                        //     onPressed: () {
                        //       //We use this Navigator.pushNamed to switch the screen on button click
                        //       Navigator.pushNamed(context, MyRoutes.homeRoute);
                        //     },
                        //     style: TextButton.styleFrom(fixedSize: Size(80, 40))),
                        //     ),
                        //To give ripple effect what we do is we wrap InkWell inside the Material widget,remove the decoration of the AnimatedContainer and give the color inside the Material widget only
                        const SizedBox(
                          height: 30,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(12),
                          child: ButtonTheme(
                              child: ElevatedButton(
                              onPressed: () async {
                                if (_Formkey.currentState!.validate()) {
                                  final email = _email.text;
                                  final password = _password.text;
                                  context.read<AuthBloc>().add(
                                      AuthEventLogIn(
                                          email: email,
                                          password: password)
                                  );
                                }
                                  }, child: const Text("Login"),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("OR", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                      //
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Create new account,", style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15
                          ),),
                          InkWell(
                            onTap: () {
                              context.read<AuthBloc>().add(
                                AuthEventShouldRegister()
                              );
                            },
                            child: const Text("Sign up", style: TextStyle(
                                color: Colors.deepPurple,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Forgotten Password? ", style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15
                          ),),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.homeRoute);
                            },
                            child: const Text("Click here", style: TextStyle(
                                color: Colors.deepPurple,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),
                          )
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          );
        default:
          return const Text("Loading...");
      }
    }
      )
    )
    ),
);
  }
}
