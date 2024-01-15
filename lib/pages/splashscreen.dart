import 'dart:async';
import 'package:bookbyte/pages/userloginpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {
  @override
    void initState() {
    super.initState();
    Timer(const Duration(seconds: 6),
    () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())));
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center, 
              children: [
                Image.asset('assets/images/books.jpg'),  
              const SizedBox(height: 35),
              const Text(
              'Welcome to 3B BookBytes!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),
            const CircularProgressIndicator(),
            const SizedBox(height: 90),
            const Text("Version 0.1 Beta", style: TextStyle(fontSize: 13)),
            
          ],
        ),
      ),
    );
  }
}