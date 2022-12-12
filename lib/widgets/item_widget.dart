import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first_app/models/catalog.dart';
class ItemWidget extends StatelessWidget{
  final Item item;

  const ItemWidget({super.key, required this.item}):assert(item != null);//Here we have made item as required now assert checks if the user doesn't give null as input. requuired needs a value nd will accept null as value
    Widget build(BuildContext context){
          return Card(
            child: ListTile(
              leading: Image.network(item.image),
              title: Text(item.name,style: TextStyle(
                  fontWeight: FontWeight.bold
              )),
              subtitle: Text(item.desc),
              trailing: Text("\$${item.price}",style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 1.5),

            ),
          );
  }
}