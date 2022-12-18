import 'package:first_app/services/auth/auth_service.dart';
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
                },
                  child:Text("Send email verification")

              ),
        ]
        ),
      )
    );
  }

}
