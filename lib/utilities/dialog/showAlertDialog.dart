import 'package:first_app/utilities/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';
Future<void> showAlertDialog(BuildContext context,String text){
  return showGenericDialog<void>(context: context,
      title: "An error occurred",
      optionsBuilder: () => {
          'OK':null
      },
      content: "$text.Try again",
  );
}
