//  checking  the communication with the vercel real time thing
import 'package:http/http.dart' as http;
import 'dart:convert';

//  the function for various debug function
class Classic_debug {
//   the base url
  static const String base_url = 'https://intermessh-backend.vercel.app';

//  method for basic console.log
  Future<void> Check_try_two() async {
    //  makng the get called
    final http.Response responce =
        await http.get(Uri.parse('$base_url/testing'));
    print(responce);
  }
}
