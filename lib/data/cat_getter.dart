import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:catinder/model/cat.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class CatGetter {
  final Queue<Cat> _cats = Queue();
  static const int _maxLength = 15;

  CatGetter() {
    _getCats(_maxLength);
  }

  Queue<Cat> get cats => _cats;

  Future<Cat> getCat() async {
    if (_cats.length < 3) {
      await _getCats(_maxLength - _cats.length);
    }
    Cat cat = _cats.first;
    return cat;
  }

  Cat removeFirst() {
    if (_cats.isEmpty) throw TimeoutException("Queue empty!");
    return _cats.removeFirst();
  }

  Cat getNextCat() {
    if (_cats.isEmpty) throw TimeoutException("Queue empty!");
    return _cats.elementAt(1);
  }

  Future<void> _getCats(int numberOfCats) async {
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=1&limit=$numberOfCats',
    );

    final response = await http.get(url, headers: {'x-api-key': catApiKey});

    final List data = json.decode(response.body);
    for (int i = 0; i < numberOfCats; i++) {
      final cat = data[i];
      final breed = cat["breeds"].isNotEmpty ? cat["breeds"][0] : "Some Breed";
      Cat catI = Cat(
        breed: breed["name"],
        image: cat["url"],
        description:
            breed != null ? breed['description'] : 'No details available.',
      );
      _cats.add(catI);
    }
  }
}
