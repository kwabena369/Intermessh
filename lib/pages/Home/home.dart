

import 'package:flutter/material.dart';
class Home_page extends StatelessWidget {

  const Home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child:  Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 224, 114),
            borderRadius: BorderRadius.circular(20),
          
            
          ),
padding: const EdgeInsets.only(left: 30, right:40 ),
          child: const Text("Welcome to Intermessh",style: TextStyle(color: Colors.cyan),),

        ),
       ),
           drawer:  Drawer(
        child: Column(
          children: const [
            DrawerHeader(
              child: Text(
                "Golde",
                style: TextStyle(fontSize: 24 ),
              ),
            ),
            // Add more drawer items here
          ],
        ),
      ),
    );
    
  }
}