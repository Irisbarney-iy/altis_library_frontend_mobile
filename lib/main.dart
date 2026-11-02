import 'package:flutter/material.dart';
main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('Olá mundo')),
        ),
      ),
    ),
  );
}