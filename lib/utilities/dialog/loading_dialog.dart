import 'package:flutter/material.dart';
// This we are using so that the caller can call when this dialog needs to be ended
typedef CloseDialog = void Function();
CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text
}){
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children:[
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(text),
        TextButton(onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')
        )
      ],
    ),
  );
  showDialog(
      context: context,
      barrierDismissible: false,//This barrierDismissible allows the user to dismiss
      // the dialog on a tap anywhere outside on the screen. We don't want the user to
      // dismiss the dialog while the dialog is being displayed so we set it tp false.
      builder: (context) => dialog
  );
  return () => Navigator.of(context).pop();
}