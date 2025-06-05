import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Cats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get breed => text()();
  TextColumn get description => text()();
  TextColumn get image => text()();
  BoolColumn get liked => boolean().withDefault(const Constant(false))();
  // null если не лайкнут
  DateTimeColumn get likedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Cats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Cat>> getAllCats() => select(cats).get();

  Future<int> insertCat(CatsCompanion cat) => into(cats).insert(cat);

  Future<List<Cat>> getLikedCats() async {
    return (select(cats)..where((tbl) => tbl.liked.equals(true))).get();
  }

  Future<int> deleteCatByData(String breed, String description, String image) {
    return (delete(cats)
      ..where((tbl) =>
      tbl.breed.equals(breed) &
      tbl.description.equals(description) &
      tbl.image.equals(image)))
        .go();
  }

  Future<int> clearLikedCats() {
    return (delete(cats)..where((tbl) => tbl.liked.equals(true))).go();
  }

  Future<int> updateLikeStatus({
    required int catId,
    required bool liked,
    DateTime? likedAt,
  }) {
    return (update(cats)..where((tbl) => tbl.id.equals(catId))).write(
      CatsCompanion(
        liked: Value(liked),
        likedAt: Value(liked ? likedAt : null),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'cats.sqlite'));
    return NativeDatabase(file);
  });
}
