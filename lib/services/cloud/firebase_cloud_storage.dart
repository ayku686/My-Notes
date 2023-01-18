import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/services/cloud/cloud_storage_constants.dart';
import 'package:first_app/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_note.dart';

class FirebaseCloudStorage{
  final notes = FirebaseFirestore.instance.collection('notes');
  //Collection gets a CollectionReference for the specified Firestore path.This 'notes' represents the collection path which we have passed
  //inside FirebaseFirestore.instance.collection('notes') we already made in our Firebase console.

  Future<void> deleteNote({required String documentId}) async {
    try{
      await notes.doc(documentId).delete();
    }
    catch(e){
      throw CouldNotDeleteNoteException();
    }
  }
  Future<void> updateNote({
  required String documentId,
  required String text,
}) async{
    try{
      await notes.doc(documentId).update({textFieldName: text});
    }
    catch(e){
      throw CouldNotUpdateNoteException();
    }
  }
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
    notes.snapshots().map((event) => event.docs//Snapshot is the result of the Future or Stream you are listening to in your FutureBuilder
    // . Before interacting with the data being returned and using it in your builder, you have to access it first.
        .map((doc) =>CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerUserId == ownerUserId));//conditon to get note only of specified user

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async{
    try{
      return await notes.
        where(ownerUserIdFieldName , isEqualTo: ownerUserId)
        .get()
        .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc))
      );
    }
    catch(e){
      throw CouldNotGetAllNotesException();
    }
  }
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        text: '');
  }

//Creating a singleton
  static final FirebaseCloudStorage _shared =
  FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;//factory constructor
}