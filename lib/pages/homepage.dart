import 'package:first_app/models/catalog.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/item_widget.dart';
import '../widgets/drawer.dart';
class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Catalog App"),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),

        child: ListView.builder(
          itemCount: CatalogModel.items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ItemWidget(
                  item: CatalogModel.items[index]),
            );
          },
        ),
      ),
    );
  }
}