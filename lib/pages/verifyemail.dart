import 'package:first_app/pages/home.dart';
import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class verifyemail extends StatefulWidget{
  const verifyemail({Key? key}) : super(key: key);

  @override
  State<verifyemail> createState() => _verifyemailState();
}
final user=AuthService.firebase().currentUser;
class _verifyemailState extends State<verifyemail> {
  @override
  // void initState() {
  //   Navigator.pushNamedAndRemoveUntil(
  //       context, MyRoutes.homeRoute, (route) => false);
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Verify your email address",style: TextStyle(
          color: Colors.white
        ),
        ), 
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        child: Column(
          children: [
          Text("Kindly verify your email address"),
            TextButton(
                onPressed: () async {
                  AuthService.firebase().sendVerificationEmail();
                  Future.delayed(Duration(seconds: 10));
                  if (await EmailVerified()) {
                    home();
                  }
                },
                child: Text("Send email verification")
              ),
        ]
        ),
      )
    );
  }
}
Future<bool> EmailVerified() async{
  var yes=await user!.isEmailVerified;
  if(yes){
    return true;
  }
  else{
    return false;
  }
}
