import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/loginpage.dart';
class verifyemail extends StatefulWidget{
  const verifyemail({Key? key}) : super(key: key);

  @override
  State<verifyemail> createState() => _verifyemailState();
}

class _verifyemailState extends State<verifyemail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Verify your email address",style: TextStyle(
          color: Colors.white
        ),)
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        child: Column(
          children: [
          Text("Kindly verify your email address"),
            TextButton(
                onPressed: () async{
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: Text("Send email verification"),
              ),
        ]
        ),
      )
    );
  }
}
