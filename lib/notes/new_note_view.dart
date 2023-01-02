import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/services/crud/notes_service.dart';
import 'package:first_app/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class newNote extends StatefulWidget {
  const newNote({Key? key}) : super(key: key);
  @override
  State<newNote> createState() => _newNoteState();

}

class _newNoteState extends State<newNote> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;
  @override
  void initState(){
    _notesService=NotesService();
    _textEditingController=TextEditingController();
    super.initState();
  }
  //We create a function which consists of a listener so that while the user is writing the note the
  // listener can constantly update the note with the database
  void _textControllerListener() async{
    final note= _note;
    if(note == null)
      return;
    else{
      final text= _textEditingController.text;
      await _notesService.updateNote(
          note: note,
          text: text
      );
    }
  }
  void _setUpTextControllerListener(){//this listener continuously checks and remove old and adds new text
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }
  Future<DatabaseNote> createNewNote() async{
    final existingNote = _note;
    if(existingNote!= null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }
  void _deleteNoteIfTextIsEmpty(){
    final note=_note;
    if(_textEditingController.text.isEmpty && note!=null){
      _notesService.deleteNote(id: note.id);
    }
  }
  void _saveNoteIfTextNotEmpty() async{
    final note=_note;
    final text=_textEditingController.text;
    if(note!=null && text.isNotEmpty){
      await _notesService.updateNote(
          note: note,
          text: text);
    }
  }
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        toolbarHeight: 108,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.menu))
        ],
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setUpTextControllerListener();
              return Column(
                children: [
                  const TextField(
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      hintText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18),
                        hintText: "Note",
                        border: InputBorder.none
                    ),
                  ),
                ],
              );
            default :
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
