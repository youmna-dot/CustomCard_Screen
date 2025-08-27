// main.dart
import 'package:api/home/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:api1/home/';
void main() {
  runApp(  MyApp());
}
//https://api.themoviedb.org/3/person/53?api_key=2dfe23358236069710a379edd4c65a6b
//https://api.themoviedb.org/3/person/53/images?api_key=2dfe23358236069710a379edd4c65a6b
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}