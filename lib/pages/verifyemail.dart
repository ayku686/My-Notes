import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/catalog.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/loginpage.dart';
class verifyemail extends StatefulWidget{
  const verifyemail({Key? key}) : super(key: key);

  @override
  State<verifyemail> createState() => _verifyemailState();
}
final user=FirebaseAuth.instance.currentUser;
class _verifyemailState extends State<verifyemail> {
  Future<bool?> waitforverification() async {
    return await user?.emailVerified;
  }
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
                onPressed: () async{
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  bool? wait=user?.emailVerified ;
                  try{
                  if(await waitforverification() ?? false){
                    Text("Redirecting to homepage....");//?? Called also null operator. This operator returns expression on its left, except if it is null, and if so, it returns right expression:
                    Navigator.pushNamed(context, MyRoutes.homepageRoute);
                  }
                }
                catch(e){
                    log(e.toString());
                }
                },
                child: Text("Send email verification"),
              ),
        ]
        ),
      )
    );
  }

}
