import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

//  the first stage
class Payment_Info_Form extends StatefulWidget{
  const Payment_Info_Form({Key? key}) : super(key: key);

  //   then we create the state
  @override
  _Payment_Info_FormState createState() => _Payment_Info_FormState();
}

// then the real deal
class _Payment_Info_FormState extends State<Payment_Info_Form>{

//  the keyForControl and access
final  _Payment_Form_key = GlobalKey<FormState>();

//   storing of the content
String Phone_Number = "";


//   the building of the Widget
@override
  Widget build(BuildContext context) {

 return Scaffold(
  appBar: AppBar(
    title:  Text("GHOST"),
  ),

body:
Center(
  child:  Form(
  key: _Payment_Form_key,
  child: Column(
    children: [

      // for the number of the person
 
   TextFormField(
    autocorrect: true,
//  for the validation sake
 validator: (Value){
  //   then we do the checking
   if(Value == null || Value.isEmpty){
     return "Please enter something in the input section please";
   }
 },
// for the decoration sake
decoration:  InputDecoration(labelText: "Password"),
// the storing of the value
onSaved: (newValue) => Phone_Number=newValue!,

   ),

  //  for the btn
   ElevatedButton(onPressed: ()=>{
     print(Phone_Number)
   }, child: Text("SaveNo")
   ,
   
   )
 
    ],
  )
  ),
)



 );
  }
}