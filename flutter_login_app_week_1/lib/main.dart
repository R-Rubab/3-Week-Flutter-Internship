import 'package:flutter/material.dart';
import 'package:flutter_login_app_week_1/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}


 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:  LoginScreen(),
      home:  LoginView(),
    );
  }
}


