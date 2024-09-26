//  thing is the section for the user to change certain certianing in the application
import 'package:flutter/material.dart';
 
//   the wrapper 
class Setting  extends StatefulWidget{
  //  the constate constructor 
  const Setting({Key?key}) : super(key: key);
  @override
  //  the real deal 
  _SettingState createState() => _SettingState();
}
class _SettingState extends State<Setting>{
   @override
  Widget build(BuildContext context) {
//  the center 
//  massage_ display 
final custom_warming =  "";

    return Scaffold(
 appBar: AppBar(
  title: const Text("Setting",
  textAlign: TextAlign.center,
  ),
 ),
//  here is where the real deal happence
body: Column(
//  in here we make the box for the user
  children: [
     SizedBox(height: 12.0,),
     Container(
child: Center(
child: 
 Image.asset(
  "/assert/Profile_default.png",
  width: 12,
  height: 12,
)
),
     ),

    //   with the user of the forloop thing we are iterating through element more than one 
    for(int i = 4 ; i <= 4 ; i++)
    Container(
      child: const Text(
        "customer",
        style:  TextStyle(
          color: Color.fromARGB(255, 234, 188, 119)
        ),
      ),
    )
    
  ],

) ,
    );
  }
}