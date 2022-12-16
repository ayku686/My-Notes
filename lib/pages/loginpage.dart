import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' show log;
//to make a Stateful widget select the class name and press ALT+ENTER and select Convert to Stateful Widget
class LoginPage extends StatefulWidget{
  @override

  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  String name="";
  final _Formkey=GlobalKey<FormState>();
  //A late keyword tells the compiler that though this field doesn't contain a value now it will surely have one in the future
  late final TextEditingController _email;
  late final TextEditingController _password;
  // Whenever the user modifies a text field with an associated TextEditingController, the text field updates value and the controller notifies its listeners. Listeners can then read the text and selection properties to learn what the user has typed or how the selection has been updated.
  //Remember to dispose of the TextEditingController when it is no longer needed. This will ensure we discard any resources used by the object.
  //These all things we are doing for authentication purpose
  //We are creating a link between our TextFormField and our login button so that when we firebase does authentication it gets the value of email and password which the user has entered
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

  bool changeButton = false;
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(

      color: Colors.white,
      child: SingleChildScrollView(
       child:FutureBuilder(
        future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    ),
    builder:(context,snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.done:
          return Form(
            key: _Formkey, //
            child: Column(
              children: [
                SizedBox(
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
                          InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4),
                              labelText: "Email",
                              hintText: "Enter your email address"
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            else
                              return null;
                          },
                          //We have used this onChanged function to attach the username after the welcome text when the user types his name
                          // onChanged: (value){
                          //   name=value;
                          //   setState(() {});
                          // },
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 4),
                            labelText: "Password",
                            hintText: "Enter your password ",
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Password cannot be empty";
                            else if (value.length < 8)
                              return "Password must contain at least 8 characters";
                            else
                              return null;
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
                      SizedBox(
                        height: 30,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        child: ButtonTheme(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final email = _email.text;
                                final password = _password.text;
                                final UserCredential = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword( //This creates an instance of the user credentials in our firebase console everytime a user enters or registers
                                    email: email,
                                    password: password
                                );
                                log(UserCredential.toString());
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushNamedAndRemoveUntil(context, MyRoutes.homeRoute,(route)=>false);//pushNamedAndRemoveUntil pushes our screen and (route)=>false means that we have specified to remove all the screens present before this screen
                                });
                              }
                              on FirebaseAuthException catch(e){
                                if(e.code=='user-not-found'){
                                  log("User not found");
                                }
                                else{
                                  log("Something bad happened");
                                  log(e.code);
                                }
                              }
                              // if (_Formkey.currentState!.validate()) {
                              //    setState(() {
                              //            Navigator.pushNamed(context, MyRoutes.homeRoute);
                              //    });
                              //  }
                              }, child: Text("Login"),
                          ),
                          ),
                          ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("OR",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                      //
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Create new account,",style: TextStyle(
                            fontStyle: FontStyle.italic,
                              fontSize: 15
                          ),),
                          InkWell(
                            onTap: () {
                                Navigator.pushNamed(context, MyRoutes.signupRoute);
                            },
                            child: Text("Sign up", style: TextStyle(
                             color: Colors.deepPurple,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Forgotten Password? ",style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15
                          ),),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.homeRoute);
                            },
                            child: Text("Click here", style: TextStyle(
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
      };
    }
      )
    )
    );
  }
}
