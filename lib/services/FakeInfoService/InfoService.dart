//  the function for getting information from the 
import 'dart:convert';

import 'package:http/http.dart' as http;

//  the class to do the Job
class Bring_Info {
  //   the base url 
  static const base_url = 'http://192.168.51.104:3000';

  //  the real function to do the getting of info
  static Future<String>Carry_Come() async{
      // the call to the back
   
  //   combinding of the url
  final real_deal = Uri.parse('$base_url/info');

 final responce = await http.get(real_deal);
  
   if(responce.statusCode ==200){
//  getting the content in there
 final content_Wrapper = await json.decode(responce.body);
//  then we check the information 

return content_Wrapper['Information'];
   }else{
     return 'Ghost';
   }

  }
}