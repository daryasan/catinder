import 'package:catinder/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          primary: Color(0xFFFD3A73),
          seedColor: Color(0xFF232323),
          outline: Color(0xFFF3F3F3),
        ),
        scaffoldBackgroundColor: Color(0xFFFD3A73),
      ),
      title: 'Catinder',
      initialRoute: RouteNames.home,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
    );
  }
}
