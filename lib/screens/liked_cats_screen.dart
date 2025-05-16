import 'package:catinder/navigation/routes.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TinderNotifier notifier = Provider.of<TinderNotifier>(context);
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: notifier.likedCats.isEmpty
                    ? Center(child: Text("No liked cats yet!"))
                    : ListView.builder(
                  itemCount: notifier.likedCats.length,
                  itemBuilder: (context, index) {
                    final likedCat = notifier.likedCats[index];
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            RouteNames.catDetails,
                            arguments: [notifier.currentCat],
                          );
                        },
                        leading: Image.network(likedCat.cat.image),
                        title: Text(likedCat.cat.breed),
                        subtitle: Text('Liked on: ${likedCat.likedAt}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              notifier.removeLikedCat(likedCat),
                        ),
                      ),
                    );
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
