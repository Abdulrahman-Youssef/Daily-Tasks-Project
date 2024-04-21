
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home_Page_Drawer extends StatelessWidget {  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Drawer(
     child: Container(
       padding: EdgeInsets.all(15),
       child: ListView(
         children: [
           Row(
             children: [
               Container(
                   width: 70,
                   height: 150,
                   child: Image.network(
                       "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg")),
               Expanded(
                 child: ListTile(
                   title: Text('abdulrahman'),
                   subtitle: Text('abdooyossef@gamil.com'),
                 ),
               )
             ],
           ),
           InkWell(
             onTap: (){},
             child: ListTile(
               title: Text('home'),
               leading: Icon(Icons.home),
             ),
           ),
           GestureDetector(
             onTap: (){},
             child: ListTile(
               title: Text('account'),
               leading: Icon(Icons.account_balance),
             ),
           ),
           ListTile(
             title: Text('tasks history'),
             leading: Icon(Icons.content_paste_search),
           ),
           ListTile(
             title: Text('about us'),
             leading: Icon(Icons.groups),
           ),
           ListTile(
             title: Text('countact us'),
             leading: Icon(Icons.phone_iphone_rounded),
           ),
           ListTile(
             title: Text('sign out'),
             leading: Icon(Icons.output_rounded),
           ),
         ],
       ),
     ),
   );
  }
}
