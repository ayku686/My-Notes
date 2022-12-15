import 'package:first_app/models/catalog.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/item_widget.dart';
import '../widgets/drawer.dart';
import 'dart:developer' show log;// show log indicates that we only want to import log from developer's library
enum Menu {
  logout,
  settings;
}
class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Catalog App"),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            onSelected: (value) {
              log(value.toString());//print only prints the text to the console but log prints and also stores the text in the history
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<Menu>(   // In dart we can create a menu in our app bar or anywhere using the popMenuButton
              //    To do this we make an enumeration (made outside the class name) using the enum keyword
              // Then we use the popMenuButton and pass the enumeration into it which we have created

                    value:Menu.logout,//value is for displaying to the programmer in the console whereas Text displays to the user
                    child: Text("Logout")
                )
              ];
            }
          )
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),

        child: ListView.builder(
          itemCount: CatalogModel.items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ItemWidget(
                  item: CatalogModel.items[index]),
            );
          },
        ),
      ),
    );
  }
}
Future<bool> logoutdialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Sign out"),
        actions: [
          Text("Are you sure you want to sign out"),
          TextButton(onPressed: (){
            //Navigator.of(context).pop(true);
          },
            child: Text("Log Out"),
          ),
          TextButton(onPressed: (){
                  //Navigator.of(context).pop(false);
      },
            child: Text("Cancel"),
          )
        ],
      );
    },).then((value) => value ?? false);
}