
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/pages/homepage.dart';
import 'package:first_app/pages/loginpage.dart';
import 'package:first_app/pages/sign_uppage.dart';
import 'package:first_app/pages/verifyemail.dart';
import 'package:first_app/utilities/MyTheme.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: homePage(),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: MyTheme.lightTheme(context),
        darkTheme: MyTheme.darkTheme(context),
        initialRoute: MyRoutes.loginRoute,
        routes: {
          MyRoutes.homepageRoute: (context) => HomePage(),
          MyRoutes.loginRoute: (context) => LoginPage(),
          MyRoutes.signupRoute: (context) => signUpPage(),
          MyRoutes.verifyemailRoute: (context) => verifyemail(),
          MyRoutes.homeRoute: (context) => home(),
        }
    );
  }
}
class home  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            //Here we have FutureBuilder which takes the credentials and checks or registers it with the firebase. Now there can be two cases one is that the registration is complete and second is it didn't. In second case it returns the default case
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  if(user!=null) {
                    if (user?.emailVerified ?? false) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, MyRoutes.homepageRoute);
                      });
                      //return HomePage();//In this the response was slow
                    }
                    else {
                     // return verifyemail();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, MyRoutes.verifyemailRoute);
                      });
                    }
                  }
                  else {
                    return LoginPage();
                  }
                  return const Text("Done");
                default:
                  return CircularProgressIndicator(
                    color: Colors.deepPurple,
                  );
              }
            }
        )

    );
  }
}
