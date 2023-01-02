import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/catalog.dart';
import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/item_widget.dart';
import '../widgets/drawer.dart';
import 'package:first_app/services/crud/notes_service.dart';
import 'dart:developer' show log;// show log indicates that we only want to import log from developer's library
enum Menu {
  logout,
}
class NotesView extends StatefulWidget{
  const NotesView({Key? key}) : super(key: key);
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;//This we did so that we can get the user's email and use it to create the user which is present in our firebase in our database
  @override
  void initState() {//Here we open the database by overriding the initState() function
    _notesService=NotesService();//Here we made a new instance of the NotesService class
    _notesService.open();
    super.initState();
  }
  @override
  void dispose() {//Here we are closing the database by overriding the dispose function
    _notesService = NotesService();
    _notesService.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Notes"),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            onSelected: (value) async{
              // log(value.toString());//print only prints the text to the console but log prints and also stores the text in the history
              switch(value) {
                case Menu.logout:
                  final want_tologout=await logoutdialog(context);//The dialog is returned from logoutdialog(context)
                  log(want_tologout.toString());
                  if(want_tologout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
                  }
                  break;
              }
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context,snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.active://This is called fallthrough in which two cases are written right after one another and after that the logic is performed
                    // Here our connection state is initially waiting and then it changes to active and after that it returns the text If ConnectionState.active was not there our app would show
                    // only circular progress bar indicator which is not a right approach
                        return const Text("Waiting for all notes");
                      default:
                        return const CircularProgressIndicator();
                    }
                  }
          );
              default:
                    return const CircularProgressIndicator();
          }
        },
      ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.pushNamed(context, MyRoutes.newnote);
    },
        child: const Icon(Icons.add),
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
        content: Text("Are you sure you want to sign out"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          },
            child: Text("Cancel"),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          },
            child: Text("Log Out"),
          ),
        ],
      );
    },).then((value) => value ?? false);
}