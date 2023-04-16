import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main_screen/main_screen.dart';
import 'screens/receive_screen/receive_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: 'File Transfer',
      home: MainScreen(),
    );
  }
}