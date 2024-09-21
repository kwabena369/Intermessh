//  page for the testing of our skills
//  statefull because something would change it it life time
import 'package:flutter/material.dart';
import 'package:outcome/services/FakeInfoService/InfoService.dart';

class Blog extends StatefulWidget{
  //  the const state
  const Blog({Key? key }) : super(key: key);
  @override
_BlogState createState()=>_BlogState();
}

// the real deal
class _BlogState extends State<Blog>{

//  infor in here
String Information = '';

   
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("AllWar"),
        ),
      ),
    
    // the body
    body: Padding(padding: EdgeInsets.all(20),
    child: Center(
       child: Column(
 
  children: <Widget>[
      
      //   like paragram
       Container(
        child: Text("Golden piece of Art is been used in making the glorious movement in the open space"),
        
       )
      ,
           Container(
        child: Text("Golden piece of Art is been used in making the glorious movement in the open space"),
        
       ),
            Container(
        child: Text("Golden piece of Art is been used in making the glorious movement in the open space"),
        
       )
       ,
            Container(
        child: Text("Golden piece of Art is been used in making the glorious movement in the open space"),
        
       )
       ,
            Container(
        child: Text("Golden piece of Art is been used in making the glorious movement in the open space"),
        
       ),

            Container(
        child: Column(
          children: [

 ElevatedButton(onPressed: ()async{
   final minInfo = await Bring_Info.Carry_Come();
            setState(() {
                    Information = minInfo;
                  });
 }, child: Text("Bring_Info"))

             ,
            Center(
              child:Text('$Information') ,
            ) 
          ],
        )
        
       )
  ],
         
       ),
    ),),
    
    );
  }
}