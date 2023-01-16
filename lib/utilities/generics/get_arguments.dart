//This section we have created so that we can create the functionality that the user can get to the full note on tapping a certain note on the notes view tab
//What we'll do here is that we create an argument which can go to the database and search if the note we tapped exists or not and instead of creating a new
//note it will return the existing note. This argument we'll pass to our navigator so that on tap it calls this argument. Also on the createOrUpdateNote we can
// read our argument by passing ModalRoute.of(context)?.settings.arguments. This argument can be of any type an array,a string, a database or any other thing
// Now here we can create a generic way of extracting arguments from the BuildContext and to do this we create a GetArgument extension on BuildContext
import 'package:flutter/cupertino.dart';

extension GetArgument on BuildContext{
  T? getArgument<T>(){//T represents that this function can return anything(i.e, it is generic data type)
    //generics are a way to code a class or function so that it works with a range of data types instead of just one while remaining type-safe
    // By the use of generics, type safety is ensured in the Dart language.
    final modalRoute = ModalRoute.of(this);
    if(modalRoute != null){
      final args=modalRoute.settings.arguments;
      if(args != null ){
        return args as T;
      }
    }
    return null;
  }
}