import 'dart:collection';
import 'dart:convert';

import 'package:catinder/model/cat.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class CatGetter {
  final Queue<Cat> _cats = Queue();
  static const int _max_length = 15;

  CatGetter() {
    _getCats(_max_length);
  }

  Cat getOneCat() {
    return _cats.first;
  }

  Future<Cat> getCat() async {
    if (_cats.length < 3) {
      await _getCats(_max_length - _cats.length);
    }
    Cat cat = _cats.first;
    _cats.removeFirst();
    return cat;
  }



  Future<void> _getCats(int numberOfCats) async {
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=1&limit=$numberOfCats',
    );

    final response = await http.get(url, headers: {'x-api-key': catApiKey});

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      for (int i = 0; i < numberOfCats; i++) {
        final cat = data[i];
        final breed =
            cat["breeds"].isNotEmpty ? cat["breeds"][0] : "Some Breed";
        Cat cat_i = Cat(
          breed: breed["name"],
          image: cat["url"],
          description:
              breed != null ? breed['description'] : 'No details available.',
        );
        _cats.add(cat_i);
      }
    } else {
      print('Error fetching cat data: ${response.statusCode}');
    }
  }
}
