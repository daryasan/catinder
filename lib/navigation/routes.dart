import 'package:catinder/model/cat.dart';
import 'package:catinder/widget/cat_screen.dart';
import 'package:catinder/widget/tinder_screen.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = '/';
  static const catDetails = 'cat';
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
    }

    return null;
  }
}
