import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
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
        title: const Text("Verify your email address",style: TextStyle(
          color: Colors.white
        ),
        ), 
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
                },
                child: const Text("Send email verification")
              ),
            TextButton(
                onPressed: () {
              context.read<AuthBloc>().add(
               const AuthEventLogOut()
              );
            },
                child: const Text("Restart"))
        ]
        ),
      )
    );
  }
}

