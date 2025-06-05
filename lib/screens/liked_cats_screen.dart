import 'package:catinder/model/liked_cat.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:catinder/widget/cat_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  String selectedBreed = "All";

  @override
  Widget build(BuildContext context) {
    TinderNotifier notifier = Provider.of<TinderNotifier>(context);
    notifier.fetchLikedCats();

    List<String> breeds = ["All", ...notifier.likedCats.map((cat) => cat.cat.breed).toSet()];

    List<LikedCat> filteredCats = selectedBreed == "All"
        ? notifier.likedCats
        : notifier.likedCats.where((cat) => cat.cat.breed == selectedBreed).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: DropdownButton<String>(
                  value: selectedBreed,
                  items: breeds.map((breed) {
                    return DropdownMenuItem(
                      value: breed,
                      child: Text(breed),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBreed = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredCats.isEmpty
                    ? const Center(child: Text("No liked cats yet!"))
                    : ListView.builder(
                  itemCount: filteredCats.length,
                  itemBuilder: (context, index) {
                    final likedCat = filteredCats[index];
                    return CatItem(cat: likedCat);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
