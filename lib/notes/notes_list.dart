import 'package:first_app/services/crud/note_service.dart';
import 'package:first_app/utilities/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/cloud/cloud_note.dart';
import '../utilities/dialog/showDeleteDialog.dart';
//Here this list view is not itself deleting the note what it is doing is just showing the dialog
// and passing the user's selection back(Callback) to the notesview
typedef NoteCallback = void Function(CloudNote note);//This is our Callback definition
// So we are creating this function which gets called when the user presses yes on the delete
// alert dialog and also to access the particular note tile the user taps on
class NotesList extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesList({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context,index){
          final note=notes.elementAt(index);
          return Padding(
              padding: EdgeInsets.all(12) ,
            child:ListTile(
            onTap: (){
              onTap(note);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.deepPurple,
            textColor: Colors.white,
            title: Text(note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,),
            trailing: IconButton(
              onPressed: () async{
                final shouldDelete = await showDeleteDialog(context);
                if(shouldDelete){
                  onDeleteNote(note);
                }
              }, icon: const Icon(Icons.delete),
            ),
          ));
        },
      ),
    );
  }
}
