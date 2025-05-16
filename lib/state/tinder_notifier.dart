import 'package:catinder/model/cat.dart';
import 'package:catinder/model/liked_cat.dart';
import 'package:catinder/model/tinder.dart';
import 'package:flutter/cupertino.dart';

class TinderNotifier extends ChangeNotifier {
  final Tinder _tinder;

  TinderNotifier(this._tinder);

  Cat get currentCat => _tinder.currentCat;

  Cat get nextCat => _tinder.nextCat;

  int get likes => _tinder.likes;

  List<LikedCat> get likedCats => _tinder.likedCats;

  Future<void> likeCat() async {
    _tinder.likedCats.add(LikedCat(_tinder.currentCat, DateTime.now()));
    await _updateCats();
    notifyListeners();
  }

  Future<void> dislikeCat() async {
    await _updateCats();
    notifyListeners();
  }

  Future<void> _updateCats() async {
    _tinder.catGetter.removeFirst();
    _tinder.currentCat = await _tinder.catGetter.getCat();
    _tinder.nextCat = _tinder.catGetter.getNextCat();
    notifyListeners();
  }

  Future<void> initializeCats() async {
    _tinder.currentCat = await _tinder.catGetter.getCat();
    _tinder.nextCat = _tinder.catGetter.getNextCat();
    notifyListeners();
  }

  void removeLikedCat(LikedCat likedCat) {
    _tinder.likedCats.remove(likedCat);
    notifyListeners();
  }

  void clearLikedCats() {
    _tinder.likedCats.clear();
    notifyListeners();
  }
}
