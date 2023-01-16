import 'dart:async';
import 'package:first_app/extensions/list/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:first_app/services/crud/crud_exceptions.dart';
// We need stream and stream controller to cache data
//Let's say we have 1 million rows in a table NOw if we need to delete one row it is not feasible to go to the database,
// fetch all the rows and then delete the row Now what we can do is that we can fetch the table in our cache and delete the row
// So now what we do is we create a list of note which consists of all the rows and the stream acts as a pipeline between the UI and the note_service. If on the UI the user tries to add a new note
// the new note is added to the note_list we created and the stream will tell the note_service that a new note is added by the user so add it to the list.And all the streams are controlled by the stream controller.
class NotesService {
  Database? _db;//Here _db is our local database
  List<DatabaseNote> _notes= [];//We created an empty list of notes which will have elements of type DatabaseNote
  //Creating singleton
  DatabaseUser? _user;
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance(){
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(//Here after calling the StreamController we need to specify the type of data our stream contains
      //The Stream returned by stream is a broadcast stream. It can be listened to more than once.Stream Controller basically reflect the change we do in our local cache to our UI in
      //response to the actions performed by the user on the UI
      //_cacheNotes() caches our database to the local variable _notes
      onListen: (){
        _notesStreamController.sink.add(_notes);
      }
    );
  }
  factory NotesService() => _shared;

  late  final StreamController<List<DatabaseNote>> _notesStreamController ;
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note){
    final currentUser=_user;
    if(currentUser!=null){
      return note.userId == currentUser.id;
    }else{
      throw UserShouldBeSetBeforeReadingAllNotes();
    }
  });//This is a getter which gets all the notes from streamController and store it into allNotes
  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentuser = true,
  }) async {
    try{
      final user = await getUser(email: email);
      if(setAsCurrentuser){
        _user = user;//THis sets the value of user to _user and the database now knows who the current user is
      }
      return user;
    }on UserDoesNotExistsException{
      final createdUser =await createUser(email: email);
      if(setAsCurrentuser){
        _user = createdUser;//THis sets the value of user to _user and the database now knows who the current user is
      }
      return createdUser;
    }catch(e){
      rethrow;
    }
  }
  Future<void> _cacheNotes() async{
    final allNotes=await getAllNote();//Here getAllNote() returns all the notes in the form of iterable
    _notes = allNotes.toList();//Here _notes is in the form of List and we are assigning allNotes of the type iterable to it.
    // So either we can change the type of _notes to iterable or we can convert allNotes to list using .toList() and then assign it to _notes
    _notesStreamController.add(_notes);
  }
  //In every funcion we need to check if the database is open or not only if the database is open we can perform getNote(),createNote(),etc and if it is not open we'll open it
  Future<void> _ensureDbIsOpen() async{
    try{
      await open();
    }on DatabaseAlreadyOpenException{
      //empty
    }
  }
  Database _getDatabaseOrThrow(){
    final db=_db;
    if(db==null){
      throw DatabaseIsNotOpenException();
    }
    else{
      return db;
    }
  }
  //opening our database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path,dbName);
      final db= await openDatabase(dbPath);
      _db = db;
      //creating user table
      await db.execute(createUserTable);
      //creating notes table
      await db.execute(createNotesTable);
      await _cacheNotes();//We call this function in our open() so that it can open the database and cache its data locally
    }
    on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectoryException();
    }
  }
  //Deleting user from table
  Future<void> deleteUser({required String email}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(deletedCount!=1){
      throw CouldNotDeleteUserException();
    }
  }
  //creating new user in our table
  Future<DatabaseUser> createUser({required String email}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    //Below we check if the email is already present in our table or not coz we have made our email unique and no two user can have the same email
    final results = await db.query(
        userTable,
        limit: 1,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()]
    );
    if(results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    //Now since we have checked our email if it is already present or not we can insert the new user's email
    final UserId=await db.insert(//This method helps insert a map of values into the specified table and returns the id of the last inserted row.
        userTable, {
      ColumnEmail: email.toLowerCase()
    });
    return DatabaseUser(
        id: UserId,
        email: email);
  }
  //get the user
  Future<DatabaseUser> getUser({required String email}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    //Below we check if the email is already present in our table or not coz we have made our email unique and no two user can have the same email
    final results = await db.query(
        userTable,
        limit: 1,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()]
    );
    if(results.isEmpty) {
      throw UserDoesNotExistsException();
    }
    else{
      return DatabaseUser.fromRow(results.first);//results.first returns the first row that was fetched
      //  and since we have set limit to 1 it will return either the first row or the exception
    }
  }
  //create a new note
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    //Now we make sure that the owner exists in the database with the correct id
    final dbUser=await getUser(email: owner.email);
    if(dbUser!=owner){
      throw UserDoesNotExistsException();
    }
    const text='';
    //create the note
    final noteId = await db.insert(noteTable, {
      ColumnUserId: owner.id,
      ColumnText:text,
      ColumnIsSyncedWithCloud:1
    });
    final note=DatabaseNote(id: noteId,
        userId: owner.id,
        text: text,
        isSyncedWithCloud: true);
    _notes.add(note);//This caches the newly created note in our local list _notes
    _notesStreamController.add(_notes);//This adds the updated list to  _notesStreamController
    return note;
  }
  //delete a note
  Future<void> deleteNote({required int id}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if(deletedCount==0){
      throw CouldNotDeleteNoteException();
    }
    else{
      _notes.removeWhere((note) => note.id == id);//It removes the note from our local cache
      _notesStreamController.add(_notes);
    }
  }
  //get note from the database(When the user clicks on some note the id must go to the database and the note corresponding to that id must be retrieved
  Future<DatabaseNote> getNote({required int id}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    //Below we check if the note is already present in our table or not coz we have made our id unique and no two notes can have the same id
    final notes = await db.query(
        noteTable,
        limit: 1,
        where: 'id = ?',
        whereArgs: [id]
    );
    if(notes.isEmpty) {
      throw NoteDoesNotExistsException();
    }
    else{
      final note =DatabaseNote.fromRow(notes.first);//results.first returns the first row that was fetched
      //  and since we have set limit to 1 it will return either the first row or the exception
      _notes.removeWhere((note) => note.id==id);//Here we the note we r getting might already be present in
      // our local database so we first remove the outdated note from the database and then add the new note
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }
  //update note
  Future<DatabaseNote> updateNote({required DatabaseNote note,required String text}) async {
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    //make sure that the note exists
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      ColumnText: text,
      ColumnIsSyncedWithCloud: 0
    },
    where: 'id = ?',
      whereArgs: [note.id]
    );
    if(updatesCount==0){
      throw CouldNotUpdateNoteException();
    }
    else{
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }
  //get all notes
  Future<Iterable<DatabaseNote>> getAllNote() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }
  //delete all notes
  Future<int> deleteAllNotes() async{
    await _ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    _notes.clear();
    _notesStreamController.add(_notes);
    return await db.delete(noteTable);
  }//Returns the number of rows affected
  //close the database
  Future<void> close() async{
    final db=_getDatabaseOrThrow();
    await db.close();
    _db=null;
  }
}
class DatabaseUser{//This is our user table which has two columns id and email
  final int id;
  final String email;
  DatabaseUser({
    required this.id,
    required this.email
  });
  DatabaseUser.fromRow(Map<String, Object?> map):
        id = map[ColumnId] as int,
        email = map[ColumnEmail]  as String;//In Dart programming, Maps are dictionary-like data types that exist in key-value form (known as lock-key).
// There is no restriction on the type of data that goes in a map data type. Maps are very flexible and can mutate their size based on the requirements.
// However, it is important to note that all locks (keys) need to be unique inside a map data type.Curly braces are used for Maps.
  @override
  String toString() => 'Person,ID=$id,email=$email';
  @override
  bool operator == (covariant DatabaseUser other) => id == other.id;
  int get hashcode => id.hashCode;
}
class DatabaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud
  });
  DatabaseNote.fromRow(Map<String, Object?> map):
        id = map[ColumnId] as int,
        userId= map[ColumnUserId]  as int,
        text = map[ColumnText] as String,
        isSyncedWithCloud= (map[ColumnIsSyncedWithCloud]  as int)==1 ? true : false ;
  @override
  String toString() =>
      'Note, ID=$id, userId=$userId, text=$text, isSyncedWithCloud=$isSyncedWithCloud';
  @override
  bool operator == (covariant DatabaseNote other) => id == other.id;
  int get hashcode => id.hashCode;
}
const dbName='notes.db';
const noteTable='note';
const userTable='user';
const ColumnId='id';
const ColumnEmail='email';
const ColumnUserId='user_id';
const ColumnText='text';
const ColumnIsSyncedWithCloud='is_synced_with_cloud';
const createUserTable = '''
          CREATE TABLE IF NOT EXISTS "user" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
      ''';
const createNotesTable = '''
          CREATE TABLE IF NOT EXISTS "note" (
            "id"	INTEGER NOT NULL,
            "user_id"	INTEGER NOT NULL,
            "text"	TEXT NOT NULL, 
            "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("user_id") REFERENCES "user"("id")
          );
      ''';
