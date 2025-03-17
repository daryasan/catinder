import 'package:catinder/model/cat.dart';
import 'package:flutter/cupertino.dart';
import '../model/tinder.dart';

class TinderNotifier extends ValueNotifier<Tinder> {
  TinderNotifier(super.value);

  Future<void> likeCat() async {
    value.likes++;
    getNewCat();
    notifyListeners();
  }

  Future<void> dislikeCat() async {
    getNewCat();
    notifyListeners();
  }

  Cat getCurrentCat() => value.currentCat;

  // Queue<Cat> get cats => value.catGetter.cats;

  Cat getNextByCurrentCat() => value.nextCat;

  Future<void> getNewCat() async {
    value.catGetter.removeFirst();
    value.currentCat = (await value.catGetter.getCat());
    value.nextCat = value.catGetter.getNextCat();
    notifyListeners();
  }

  Future<void> initializeCats() async {
    value.currentCat = (await value.catGetter.getCat());
    value.nextCat = value.catGetter.getNextCat();
    notifyListeners();
  }

  int getLikes() => value.likes;
}

class TinderInheritedNotifier extends InheritedNotifier<TinderNotifier> {
  const TinderInheritedNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static TinderNotifier of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<TinderInheritedNotifier>();

    final notifier = result?.notifier;
    if (notifier == null) {
      throw StateError('No TinderInheritedNotifier found in context');
    }

    return notifier;
  }
}
