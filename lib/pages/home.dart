import 'package:first_app/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../utilities/routes.dart';

class home  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: AuthService.firebase().Initialize(),
            //Here we have FutureBuilder which takes the credentials and checks or registers it with the firebase. Now there can be two cases one is that the registration is complete and second is it didn't. In second case it returns the default case
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = AuthService.firebase().currentUser;
                  if(user!=null) {
                    if (user.isEmailVerified) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, MyRoutes.NotesviewRoute);
                      });
                      //return NotesView();//In this the response was slow
                    }
                    else {
                      // return verifyemail();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, MyRoutes.verifyemailRoute);
                      });
                    }
                  }
                  else {
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      Navigator.pushNamed(context, MyRoutes.loginRoute,);
                    });
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