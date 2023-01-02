import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:first_app/services/crud/crud_exceptions.dart';
class NotesService {
  Database? _db;//Here _db is our local database
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
    if (_db == null) {
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
    }
    on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectoryException();
    }
  }
  //Deleting user from table
  Future<void> deleteUser({required String email}) async{
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
    return note;
  }
  //delete a note
  Future<void> deleteNote({required int id}) async{
    final db=_getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if(deletedCount!=1){
      throw CouldNotDeleteNoteException();
    }
  }
  //get note from the database(When the user clicks on some note the id must go to the database and the note corresponding to that id must be retrieved
  Future<DatabaseNote> getNote({required int id}) async{
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
      return DatabaseNote.fromRow(notes.first);//results.first returns the first row that was fetched
      //  and since we have set limit to 1 it will return either the first row or the exception
    }
  }
  //update note
  Future<DatabaseNote> updateNote({required DatabaseNote note,required String text}) async {
    final db=_getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      ColumnText: text,
      ColumnIsSyncedWithCloud: 0
    });
    if(updatesCount==0){
      throw CouldNotUpdateNoteException();
    }
    else{
      return await getNote(id: note.id);
    }
  }
  //get all notes
  Future<Iterable<DatabaseNote>> getAllNote() async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }
  //delete all notes
  Future<int> deleteAllNotes() async{
    final db=_getDatabaseOrThrow();
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
  bool operator ==(covariant DatabaseUser other) => id == other.id;
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
      'Note,ID=$id,userId=$userId,text=$text,isSyncedWithCloud=$isSyncedWithCloud';
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;
  int get hashcode => id.hashCode;
}
const dbName='notes.db';
const noteTable='note';
const userTable='user';
const ColumnId='id';
const ColumnEmail='email';
const ColumnUserId='userId';
const ColumnText='text';
const ColumnIsSyncedWithCloud='isSyncedWithCloud';
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
            "is_synced_with"	INTEGER NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("user_id") REFERENCES "user"("id")
          );
      ''';
