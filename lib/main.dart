import 'package:flutter/material.dart';
import 'screens/movielist.dart';
import 'screens/welcomescreen.dart';
import 'screens/loginscreen.dart';
import 'screens/regscreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: WelcomeScreen.id ,
        routes:
        {WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          MovieList.id:(context)=> MovieList()
        }
    );
  }
}

