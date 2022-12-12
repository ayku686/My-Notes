import 'package:flutter/material.dart';

class MyTheme{
  static ThemeData lightTheme (BuildContext context)=>ThemeData(
        primarySwatch: Colors.deepPurple,
        //We specify all property of this AppBarTheme so that these properties are same for all the pages and we don't need to create specific properties for each page
        appBarTheme: AppBarTheme(
            toolbarHeight: 65,
            elevation: 0,
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            toolbarTextStyle: TextStyle(color: Colors.black),
            titleTextStyle: TextStyle(color :Colors.black,fontSize: 18,fontWeight: FontWeight.w500)
        ),
      );
  static ThemeData darkTheme(BuildContext context)=> ThemeData(
   brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        toolbarHeight: 65,
        elevation: 0,
        color: Colors.lightGreen,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        toolbarTextStyle: TextStyle(color: Colors.white),
        titleTextStyle: TextStyle(color :Colors.white,fontSize: 18,fontWeight: FontWeight.w500)
    ),
  );
  // ),
}