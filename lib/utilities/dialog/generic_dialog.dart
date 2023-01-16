import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}){
  final options = optionsBuilder();
  return showDialog<T>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle){
            final T value = options[optionTitle];
            return TextButton(onPressed: (){
              if(value!=null){
                Navigator.of(context).pop(value);//Here the main data(value) associated with the respective optionTitle(key) comes in value and we pop it
              }
              else{
                Navigator.of(context).pop();//In our login page when we show the dialog it just has an ok button and no value so far that we have created this case
              }
            }, child: Text(optionTitle));
          }).toList(),
        );
  });
}