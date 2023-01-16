import 'package:first_app/utilities/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: 'Delete', content: 'Are you sure you want to delete this note',
      optionsBuilder: ()=>{
        'Cancel':false,
        'Delete':true
      }
  ).then((value) => value ?? false);
}