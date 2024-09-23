//  for display of payment options
import 'package:flutter/material.dart';

//  creating of the stateless widget since nothing changes
class RealPayment  extends StatelessWidget{
const RealPayment({Key?key}): super(key:key);
// building the real deal
@override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Center(
    child: Text("Payment Options"),
  ),
),

    //   then the actional options

body: Center(
  child: Padding(padding: EdgeInsets.all(20),
  child: Container(
  
  child: Column(
     children: [
       
 Text("Mobile Money Payment"),
  Text("Google Pay "),
   Text("Paypal Payment"),
    Text("Credit Account Payment"),






     ],
  ),

  ),
  ),
),

    
    );
  }


}
