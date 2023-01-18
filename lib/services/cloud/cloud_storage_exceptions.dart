//Since we are now switching to cloud storage we need to create exceptions for cloud so that
//if a user's action is not performed by the cloud it throws an exception
class CloudStorageExceptions implements Exception{
  const CloudStorageExceptions();
}
//C in CRUD
class CouldNotCreateNoteException extends CloudStorageExceptions{}

//R in CRUD
class CouldNotGetAllNotesException extends CloudStorageExceptions{}

//U in CRUD
class CouldNotUpdateNoteException extends CloudStorageExceptions{}

//D in CRUD
class CouldNotDeleteNoteException extends CloudStorageExceptions{}