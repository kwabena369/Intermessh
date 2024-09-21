// ignore_for_file: unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outcome/services/User_Service/Send_User_Info.dart';

// import '../../services/User_Service/Send_User_Info.dart';
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

//  this function would send the information 
//  this function to do the actual thing 
Future Process_Info() async{
   if(_User_form_key.currentState!.validate()){
    //  we do the saving of the form  
     _User_form_key.currentState!.save();   
    final value =  await  User_Content_Service.forwardInfo(userEmail, Password, userName);
    //   the classic
    

   }else{
 
 return "Enter_";
   }
}


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
ElevatedButton(onPressed: ()async{
   

   if(_User_form_key.currentState!.validate()){
//  then saving of the whole thing 
_User_form_key.currentState!.save();
await Process_Info();
   }

}, child: const Text(" Send_Information"))



 ],
 
),
)


),


  );
  }
}