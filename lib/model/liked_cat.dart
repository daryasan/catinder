import 'package:catinder/model/cat.dart';

class LikedCat {
  final Cat _cat;
  final DateTime _likedAt;

  LikedCat(this._cat, this._likedAt);

  get cat => _cat;

  get likedAt => _likedAt;
}
