import 'package:catinder/model/cat.dart';
import 'package:catinder/screens/cat_screen.dart';
import 'package:catinder/screens/liked_cats_screen.dart';
import 'package:catinder/screens/tinder_screen.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = '/';
  static const catDetails = 'cat';
  static const likedCats = 'liked';
}

class RoutesBuilder {
  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const TinderScreen(),
          settings: settings,
        );

      case RouteNames.catDetails:
        final args = settings.arguments as List<dynamic>;
        final cat = args[0] as Cat;
        return MaterialPageRoute(
          builder: (_) => CatScreen(cat: cat),
          settings: settings,
        );

      case RouteNames.likedCats:
        return MaterialPageRoute(
          builder: (_) => LikedCatsScreen(),
          settings: settings,
        );
    }

    return null;
  }
}
