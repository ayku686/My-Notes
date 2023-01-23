import 'package:first_app/services/auth/auth_exceptions.dart';
import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/utilities/dialog/showAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';

//to make a Stateful widget select the class name and press ALT+ENTER and select Convert to Stateful Widget
class signUpPage extends StatefulWidget{
  @override

  State<signUpPage> createState() =>_signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  String name="";
  final _Formkey=GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmpassword;
  @override
  void initState() {
    // TODO: implement initState
    _email=TextEditingController();
    _password=TextEditingController();
    _confirmpassword=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) async {
      if(state is AuthStateRegistering){
         if(state.exception is EmailAlreadyInUseAuthException ){
          await showAlertDialog(
                  context, 'Email already exists.\n Please try with a different email');
        }
         else if(state is WeakPasswordAuthException){
           await showAlertDialog(
               context, "Password is weak"
           );
         }
         else if(state is InvalidEmailAuthException){
            await showAlertDialog(
               context, "Invalid email"
           );
         }
         else if(state is GenericAuthException){
           await showAlertDialog(
               context, 'Failed to register.\n Please try again');
         }
      }
    },
    child: Material(

        color: Colors.white,
        child: SingleChildScrollView(
          child:FutureBuilder(
            future: AuthService.firebase().Initialize(),
            //Here we have FutureBuilder which takes the credentials and checks or registers it with the firebase. Now there can be two cases one is that the registration is complete and second is it didn't. In second case it returns the default case
            builder:(context,snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.done:
              return Form(
                key: _Formkey, //
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 120,
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 0),
                      //   child: Image.asset("allimages/signup.png",
                      //       fit: BoxFit.fitHeight ),
                      // ),

                      const Text("Let's get started...", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 26,
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
                                enableSuggestions: true,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                decoration:
                                const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Name",
                                    hintText: "Enter your name"
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Card(
                              child: TextFormField(
                                enableSuggestions: true,
                                keyboardType: TextInputType.emailAddress,
                                controller: _email,
                                autocorrect: true,
                                decoration:
                                const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Email Id",
                                    hintText: "Enter email id"
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Card(
                              child: TextFormField(
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                decoration:
                                const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Phone no.",
                                    hintText: "Enter your phone no."
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone no. cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4),
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
                            const SizedBox(
                                height: 10
                            ),
                            Card(
                              color: Colors.white,
                              child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _confirmpassword,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4),
                                  labelText: "Confirm password",
                                  hintText: "Enter your password ",
                                ),
                                validator: (value) {
                                  if (value != _password.text) {
                                    return "Password doesn't match";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(25.0),

                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                child:ButtonTheme(
                                  height: 30,
                                  child: ElevatedButton(
                                      onPressed: () {
                                      if (_Formkey.currentState!.validate()) {
                                          final email = _email.text;
                                          final password = _password.text;
                                          context.read<AuthBloc>().add(
                                           AuthEventRegister(
                                               email,
                                               password)
                                          );
                                          showAlertDialog(context, "Congratulations! Your account has been successfully created.");
                                      }
                                    }, child: const Text("Register"),
                                  ),
                                ),
                              ),
                            ),
                            const Text("Already have an account?"),
                            InkWell(
                              onTap: () {
                               context.read<AuthBloc>().add(const AuthEventLogOut()
                               );
                              },
                              child: const Text("Sign in", style: TextStyle(
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold

                              ),),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text("OR", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
                default :
                  return const Text("Loading...");
            }
            }
            ),
        ),
    ),
);
  }
}
