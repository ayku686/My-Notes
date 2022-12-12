import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget{

  String MyImage="https://www.rolls-roycemotorcars.com/content/dam/rrmc/marketUK/rollsroycemotorcars_com/black-badge-ghost-2021/page-components/BB_RR21_HERO_D.jpg/jcr:content/renditions/cq5dam.web.1242.webp";
  Widget build(BuildContext context){
    return Drawer(
        backgroundColor: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 4),
          children: [
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                child: UserAccountsDrawerHeader(

                  accountName: Text("Ayush Kumar",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
                  accountEmail: Text("ayku21cs@cmrit.ac.in"),
                  //We use NetworkImage to take images from the internet. Here MyImage is a string we created above which contains the web address of the image
                    // CircleAvatar we used to make our display our image in circular manner
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(MyImage),)

                ),
              margin: EdgeInsets.symmetric(vertical: 4)
            ),
            ListTile(
              leading: Icon(CupertinoIcons.home,color: Colors.white),
              title: Text("Home",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.profile_circled,color: Colors.white),
              title: Text("Profile",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            ),

            ListTile(
              leading: Icon(CupertinoIcons.arrow_down_to_line,color: Colors.white),
              title: Text("Downloads",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),)
            ),
            ListTile(
              leading: Icon(CupertinoIcons.settings,color: Colors.white),
              title: Text("Settings",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.mail_solid,color: Colors.white),
              title: Text("Contact Us",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            ),

          ],
        )
    );
  }
}