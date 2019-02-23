import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './pages/launch_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '香饽饽博客',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey
      ),
      home: LaunchScreen(),
    );
  }
}