import 'package:catinder/data/cat_getter.dart';
import 'package:catinder/model/cat.dart';
import 'package:catinder/model/liked_cat.dart';

class Tinder {
  final List<LikedCat> _likedCats = [];

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

  Tinder();

  get likes => _likedCats.length;
  get likedCats => _likedCats;
}
