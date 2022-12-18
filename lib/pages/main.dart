import 'package:first_app/pages/homepage.dart';
import 'package:first_app/pages/loginpage.dart';
import 'package:first_app/pages/registrationsuccessful.dart';
import 'package:first_app/pages/sign_uppage.dart';
import 'package:first_app/pages/verifyemail.dart';
import 'package:first_app/utilities/MyTheme.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';

import 'home.dart';
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
        initialRoute: MyRoutes.homeRoute,
        routes: {
          MyRoutes.homepageRoute: (context) => HomePage(),
          MyRoutes.loginRoute: (context) => LoginPage(),
          MyRoutes.signupRoute: (context) => signUpPage(),
          MyRoutes.verifyemailRoute: (context) => verifyemail(),
          MyRoutes.homeRoute: (context) => home(),
           MyRoutes.regsuccess: (context) => regsuccessfull()
          // "/regsuccessfull/":(context) => const regsuccessfull()
        }
    );
  }
}

