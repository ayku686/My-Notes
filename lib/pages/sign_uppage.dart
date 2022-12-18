import 'dart:developer' show log;
import 'package:first_app/services/auth/auth_exceptions.dart';
import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/utilities/showAlertDialog.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//to make a Stateful widget select the class name and press ALT+ENTER and select Convert to Stateful Widget
class signUpPage extends StatefulWidget{
  @override

  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  @override
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

   Widget build(BuildContext context) {
    // TODO: implement build
    return Material(

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
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 0),
                      //   child: Image.asset("allimages/signup.png",
                      //       fit: BoxFit.fitHeight ),
                      // ),

                      Text("Let's get started...", style: TextStyle(
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
                                InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Name",
                                    hintText: "Enter your name"
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name cannot be empty";
                                  }
                                  else
                                    return null;
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
                                InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Email Id",
                                    hintText: "Enter email id"
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  else
                                    return null;
                                },
                              ),
                            ),
                            Card(
                              child: TextFormField(
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                decoration:
                                InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4),
                                    labelText: "Phone no.",
                                    hintText: "Enter your phone no."
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone no. cannot be empty";
                                  }
                                  else
                                    return null;
                                },
                              ),
                            ),
                            SizedBox(
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
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4),
                                  labelText: "Password",
                                  hintText: "Enter your password ",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Password cannnot be empty";
                                  else if (value.length < 8)
                                    return "Password must contain at least 8 characters";
                                  else
                                    return null;
                                },
                              ),
                            ),
                            SizedBox(
                                height: 10
                            ),
                            Card(
                              color: Colors.white,
                              child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _confirmpassword,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4),
                                  labelText: "Confirm password",
                                  hintText: "Enter your password ",
                                ),
                                validator: (value) {
                                  if (value != _password.text)
                                    return "Password doesn't match";
                                  else
                                    return null;
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
                                      onPressed: () async {
                                      if (_Formkey.currentState!.validate()) {
                                        try {
                                          final email = _email.text;
                                          final password = _password.text;
                                          final UserCredential =
                                          await AuthService.firebase().signUp(email: email, password: password);
                                          log(UserCredential.toString());
                                          if(UserCredential!=null){
                                            Navigator.pushNamedAndRemoveUntil(context, MyRoutes.regsuccess,(route)=>false);
                                          }
                                        }
                                        on WeakPasswordAuthException{
                                          log("Weak password");
                                          shownDialog.showAlertDialog(
                                              context, "Password is weak"
                                          );
                                        }
                                        on InvalidEmailAuthException{
                                          log("Invalid email");
                                          shownDialog.showAlertDialog(
                                              context, "Invalid email"
                                          );
                                        }
                                        on EmailAlreadyInUseAuthException{
                                          log("Email already in use");
                                          shownDialog.showAlertDialog(
                                              context, "Email already in use. Please try with a different email"
                                          );
                                        }
                                        on GenericAuthException{
                                          shownDialog.showAlertDialog(
                                              context, "Invalid Credentials");
                                        }
                                      }
                                    }, child: Text("Register"),
                                  ),
                                ),
                              ),
                            ),
                            Text("Already have an account?"),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.loginRoute);
                              },
                              child: Text("Sign in", style: TextStyle(
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold

                              ),),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("OR", style: TextStyle(
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
            };
            }
            ),
        ),
    );
  }
}
