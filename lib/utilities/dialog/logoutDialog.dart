import 'package:first_app/utilities/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> logoutDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: "Log Out",
      content: "Are you sure you want to logout?",
      optionsBuilder: ()=>{
        'Cancel': false,
        'Log Out': true,
      },
  ).then((value) => value ?? false);
}