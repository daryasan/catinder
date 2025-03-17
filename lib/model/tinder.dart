import 'dart:collection';

import 'package:catinder/model/cat.dart';
import 'package:catinder/model/cat_getter.dart';

class Tinder {
  int likes;
  late Cat currentCat = Cat(
    breed: 'Loading...',
    image: 'assets/images/loading-cat.svg',
    description: 'Fetching a new cat...',
  );

  late Cat nextCat = Cat(
    breed: 'Loading...',
    image: 'assets/images/loading-cat.svg',
    description: 'Fetching a new cat...',
  );

  final CatGetter catGetter = CatGetter();

  Tinder({int? likes}) : likes = likes ?? 0;


}

