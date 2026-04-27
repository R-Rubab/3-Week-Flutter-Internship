import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(email,style: TextStyle(color: Colors.white)), centerTitle: true, backgroundColor:  Colors.pink,),
      body: Container(
        decoration: BoxDecoration(
          
          gradient: LinearGradient(
            colors: [Colors.pink, const Color.fromARGB(255, 255, 106, 0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "   Welcome! 🏡",
        
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
