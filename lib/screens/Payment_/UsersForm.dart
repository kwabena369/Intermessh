// ignore_for_file: unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//  handling of the input of name and other users info

class UsersForm extends StatefulWidget{
const UsersForm({Key? key }) : super(key:key );
// creation of the state

@override
_UsersForm createState() => _UsersForm();

} 

class _UsersForm extends State<UsersForm>{
//  creating a FormKey
final _User_form_key = GlobalKey<FormState>();

//  the basic users information that we would need
//  are the FollowerLayer
String userName = "";
String userEmail = "";
String Password = "";
String ConfirmPassword = "";


//  the designing of the page
@override
  Widget build(BuildContext context) {
// building it using scafold
  return Scaffold(
    appBar:   AppBar(
      title:  Center(
        child: const Text("Ghost House"),
      ),
    ),

// the input sections and other thing 
body: Padding(padding:EdgeInsets.all(20),
child:Form(
  key: _User_form_key
  ,child:  Column(
 children: <Widget>[
//  for userName

TextFormField(
 decoration: InputDecoration(labelText:"UserName" ), 
//   the validation of the input 
validator: (valueNow){
   if(valueNow! == null || valueNow.isEmpty){
     return "Enter you username please";
   }
   return null;
}, 

//  here we store the value
onSaved: (value)=>userName=value!,

)
,
TextFormField(
 decoration: InputDecoration(labelText:"UserEmail" ), 
//   the validation of the input 
validator: (valueNow){
   if(valueNow! == null || valueNow.isEmpty){
     return "Enter you your Email please";
   }
   return null;
}, 

//  here we store the value
onSaved: (value)=>userEmail=value!,

),
// the password  
TextFormField(
 decoration: InputDecoration(labelText:"Password" ), 
//   the validation of the input 
validator: (valueNow){
   if(valueNow! == null || valueNow.isEmpty){
     return "Enter you your Password please";
   }
   return null;
}, 
//  here we store the value
onSaved: (value)=>Password=value!,
obscureText: true,

)
,
//  the conformation of password
TextFormField(
 decoration: InputDecoration(labelText:" Confirm Password" ), 
//   the validation of the input 
validator: (valueNow){
   if(valueNow! == null || valueNow.isEmpty){
     return "Please enter again to Confirm password";
   }
   return null;
}, 
//  here we store the value
onSaved: (value)=>ConfirmPassword=value!,
obscureText: true,

)
,
// then the elevated btn
ElevatedButton(onPressed: (){
   

   if(_User_form_key.currentState!.validate()){
//  then saving of the whole thing 
_User_form_key.currentState!.save();
   print("$userEmail,Golden,$userName");
   }

}, child: const Text(" Send_Information"))



 ],
 
),
)


),


  );
  }
}