import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class shownDialog{
static Future<void> showAlertDialog(BuildContext context,String text){
  return showDialog(
    context: context,
    builder: (context){
    return AlertDialog(
      title: Text("An error occured"),
      content: Text("$text.Try again"),
      actions: [
          TextButton(onPressed: (){
          Navigator.pop(context);
          },
          child: Text("Ok")
          ),
      ],
);
});
}
}