import 'package:catinder/data/database.dart' as db;
import 'package:catinder/model/tinder.dart';
import 'package:catinder/navigation/routes.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final db.AppDatabase database = db.AppDatabase();
  runApp(ChangeNotifierProvider(
    create: (context) => TinderNotifier(Tinder(), database),
    child: MyApp(),
  ));
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
