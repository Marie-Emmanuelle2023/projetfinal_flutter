// import 'package:flutter/material.dart';
// import 'package:projet_final/config/router.dart';
// import 'package:projet_final/pages/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Miamm App',
//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//       ),
//       initialRoute: AppRouter.rootRouter, // La première page (HomePage)
//       onGenerateRoute: AppRouter.onGenerateRoute,
      
      
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:projet_final/config/router.dart';
import 'package:projet_final/pages/splash_screen.dart';
import 'package:projet_final/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final fakeUser = User(
      id: 1,
      name: 'Marie',
      pseudo: 'miammiam',
      email: 'marie@example.com',
      password: 'password123', 
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miamm App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: SplashScreen(user: fakeUser), 
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}