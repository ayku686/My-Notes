import 'package:first_app/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class regsuccessfull extends StatelessWidget {
  const regsuccessfull({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Registration Successful",style: TextStyle(
            color: Colors.white
        ),
        ),
      ),
      body:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Your account has been successfully created"),
                TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute,(route)=>false);
                  },
                  child: Text("Login here"), )
                ],
              ),
            ),

          );
  }
}
