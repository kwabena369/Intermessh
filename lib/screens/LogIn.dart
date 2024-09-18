import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: const [
            //  this is for the title of the whole tiing
            Text(
              " Welcome to Intermessh LogIn Page"
            ),

//  under here we show the vaious  option but first thing we make use of the logIn page 
//  InputDecorator(decoration: )
 
          ],
        ),
      ),
    );
  }
}