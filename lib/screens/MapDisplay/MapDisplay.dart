//  in here we are going to be dealing with the displaying of the users that are close by or what ever

import 'package:flutter/material.dart';

class Mapdisplay extends StatefulWidget {
  const Mapdisplay({super.key});

  @override
  State<Mapdisplay> createState() => _MapdisplayState();
}

class _MapdisplayState extends State<Mapdisplay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 12,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(
                    'assets/Fun/Cat.png',
                  ),
                  fit: BoxFit.cover)),
          child: SafeArea(
              child: Column(
//  the first thing is the image
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
//  the location of the person
              Center(
                child: Container(
                    child: Row(
                  children: const <Widget> [
                    SizedBox(
                      height: 12,
                    ),
                    Text('Latitude :  34.00',style:TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ) ,),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Latitude :  34.00'),
                  ],
                )),
              )
            ],
          )),
        ),
      ),
    );
  }
}
