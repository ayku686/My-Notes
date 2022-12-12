import 'package:flutter/cupertino.dart';
class CatalogModel{
  static final items =[
    Item(
        id:2,
        name:"Manali",
        desc:"One of the most popular hill stations in Himachal, Manali offers the most magnificent views of the Pir Panjal and the Dhauladhar ranges covered with snow for most parts of the year. ",
        price:55,
        color:"#FFFFF",
        image:('https://www.holidify.com/images/bgImages/MANALI.jpg')
    ),
    Item(
        id:3,
        name:"Leh Ladakh",
        desc:"Ladakh is a union territory in the Kashmir region of India. Formerly falling in the state of Jammu & Kashmir, Ladakh was administered a union territory on 31st October 2019.",
        price:80,
        color:"#FFFFF",
        image:('https://www.holidify.com/images/bgImages/LADAKH.jpg')
    ),
    Item(
        id:2,
        name:"Manali",
        desc:"One of the most popular hill stations in Himachal, Manali offers the most magnificent views of the Pir Panjal and the Dhauladhar ranges covered with snow for most parts of the year. ",
        price:55,
        color:"#FFFFF",
        image:('https://www.holidify.com/images/bgImages/MANALI.jpg')
    ),
    Item(
        id:3,
        name:"Leh Ladakh",
        desc:"Ladakh is a union territory in the Kashmir region of India. Formerly falling in the state of Jammu & Kashmir, Ladakh was administered a union territory on 31st October 2019.",
        price:80,
        color:"#FFFFF",
        image:('https://www.holidify.com/images/bgImages/LADAKH.jpg')
    )
  ];


}
class Item{
  final int id;
  final String name;
  final String desc;
  final num price;
  final String color;
  final String image;
  Item({required  this.id,required this.name,required this.color,required this.desc,required this.image,required this.price});
}

