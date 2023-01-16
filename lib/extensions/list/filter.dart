//This filter.dart file we have created so that we can define a functionality(extension stream) which can filter the
// current user who is currently logged in and get only the notes which is created by that user
extension Filter<T> on Stream<List<T>>{//extensions are used so that we can edit the library which we are
  // importing and use it acc. to our needs. Now we can extend the class also but when we run the app the API gives
  //the original class and not our extended class so we use extensions////
  //Here we could have done extension Filter on Stream but here we are making an extension of name
  //Filter which can hold some data of the Stream class which again contains some data of any type(T)
  //Now this extension named Filter has function named filter which returns a Stream of List of T
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}