import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  static const String _baseUrl = 'https://localhost::3000';

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
//  the defination of the url 
 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Login successful
        final responseData = json.decode(response.body);
        // You might want to save the token or user data here
        print('Login successful: $responseData');
        return true;
      } else {
        // Login failed
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }


  }
}

// // In your _EnhancedLoginFormState class, modify _submitForm:
// void _submitForm() async {
//   if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
    
//     bool success = await LoginService.login(_email, _password);
//     if (success) {
//       // Navigate to home screen or show success message
//     } else {
//       // Show error message
//     }
//   }
// }

//  in making the url thing we do something like thiing 
//  We do something 
//  http.post(url there,
// header : {"content-Type":"application/json"}
// )
//  