//This file we have created so that if a user tries to share an empty not he cannot be able to share it
//This dialog will appear if the user tries to share the empty note
import 'package:first_app/utilities/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context){
  return showGenericDialog<void>(
      context: context,
      title: 'Empty note',
      content: 'Cannot share empty note',
      optionsBuilder: () =>{
          'Ok' : null
      }
  );
}