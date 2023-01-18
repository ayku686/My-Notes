import 'package:first_app/services/auth/auth_service.dart';
import 'package:first_app/services/crud/note_service.dart';
import 'package:first_app/utilities/generics/get_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class createUpdateNote extends StatefulWidget {
  const createUpdateNote({Key? key}) : super(key: key);
  @override
  State<createUpdateNote> createState() => _createUpdateNoteState();

}

class _createUpdateNoteState extends State<createUpdateNote> {
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
    final note = _note;
    if(note == null) {
      return;
    }
        final text= _textEditingController.text;
        await _notesService.updateNote(
            note: note,
            text: text
        );

  }
  void _setUpTextControllerListener(){//this listener continuously checks and remove old and adds new text
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }
  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async{
    final widgetNote =context.getArgument<DatabaseNote>();
    if(widgetNote != null){
      _note=widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    final newNote=await _notesService.createNote(owner: owner);
    _note=newNote;
    return newNote;
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
        future: createOrGetExistingNote(context),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              _setUpTextControllerListener();
              return TextField(
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18),
                    hintText: "Note",
                    border: InputBorder.none
                ),
              );
            default :
              return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
