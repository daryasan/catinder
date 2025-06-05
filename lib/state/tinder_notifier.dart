import 'dart:async';

import 'package:catinder/model/cat.dart';
import 'package:catinder/model/liked_cat.dart';
import 'package:catinder/model/tinder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:catinder/data/database.dart' as db;
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class TinderNotifier extends ChangeNotifier {
  final Tinder _tinder;
  final db.AppDatabase _db;

  TinderNotifier(this._tinder, this._db);

  Cat get currentCat => _tinder.currentCat;

  Cat get nextCat => _tinder.nextCat;

  int get likes => _tinder.likes;

  List<LikedCat> get likedCats => _tinder.likedCats;

  db.AppDatabase get database => _db;

  Future<void> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) throw TimeoutException("No connection!");
  }

  Future<void> likeCat() async {
    DateTime now = DateTime.now();
    _tinder.likedCats.add(LikedCat(_tinder.currentCat, now));
    await _db.insertCat(
      db.CatsCompanion(
        breed: Value(_tinder.currentCat.breed),
        description: Value(_tinder.currentCat.description),
        image: Value(_tinder.currentCat.image),
        liked: Value(true),
        likedAt: Value(now),
      ),
    );
    try {
      await _updateCats();
    } on TimeoutException catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> dislikeCat() async {
    await _db.insertCat(
      db.CatsCompanion(
        breed: Value(_tinder.currentCat.breed),
        description: Value(_tinder.currentCat.description),
        image: Value(_tinder.currentCat.image),
        liked: Value(false),
        likedAt: const Value(null),
      ),
    );
    try {
      await _updateCats();
    } on TimeoutException catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> _updateCats() async {
    try {
      _tinder.catGetter.removeFirst();
    }catch (e){
      rethrow;
    }
    _tinder.currentCat = await _tinder.catGetter.getCat();
    _tinder.nextCat = _tinder.catGetter.getNextCat();
    notifyListeners();
  }

  Future<void> initializeCats() async {
    _tinder.currentCat = await _tinder.catGetter.getCat();
    _tinder.nextCat = _tinder.catGetter.getNextCat();
    notifyListeners();
  }

  Future<List<LikedCat>> fetchLikedCats() async {
    final likedRecords = await _db.getLikedCats();
    List<LikedCat> likedCats =
        likedRecords.map((record) {
          final cat = Cat(
            breed: record.breed,
            description: record.description,
            image: record.image,
          );
          return LikedCat(cat, record.likedAt ?? DateTime.now());
        }).toList();
    _tinder.likedCats = likedCats;
    return likedCats;
  }

  Future<void> removeLikedCat(LikedCat likedCat) async {
    _tinder.likedCats.remove(likedCat);
    notifyListeners();
    await _db.deleteCatByData(
      likedCat.cat.breed,
      likedCat.cat.description,
      likedCat.cat.image,
    );
  }

  Future<void> clearLikedCats() async {
    _tinder.likedCats.clear();
    notifyListeners();
    await _db.clearLikedCats();
  }
}
