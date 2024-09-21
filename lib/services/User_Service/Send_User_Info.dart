
import 'package:http/http.dart' as http;
import 'dart:convert';

//  this is the service for sending the information 
// ignore: camel_case_types
class User_Content_Service{
  //   here we make the statis const url 
  static const base_url = 'http://192.168.88.148:3000';

  //  the method for sending the actual content
  static Future<bool>forwardInfo(String Useremail,String  Userpassword, String Username) async{
//   the joining of the url
final Forwarding_url = Uri.parse("$base_url/Authentitcation");

try {
 final response = await
  http.post(Forwarding_url
 ,headers:{'Content-Type':'application/json'},
 body: json.encode({
  Useremail:Useremail,
  Userpassword:Userpassword,
  Username : Username
 }) 
 
 );

 if(response.statusCode == 200){
 final outcome = await json.decode(response.body);
    if(outcome['status']){
       print("it is done");
       return true;
    }else{
       print("no it is not done");
       return false;
    }
 }else{
   return false;
 }


} catch (e) {
  print(e);
  return false;
}
  }
}
