import 'package:catinder/model/liked_cat.dart';
import 'package:catinder/navigation/routes.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CatItem extends StatefulWidget {
  final LikedCat cat;

  const CatItem({super.key, required this.cat});

  @override
  State<CatItem> createState() => _CatItemState();
}

class _CatItemState extends State<CatItem> {
  @override
  Widget build(BuildContext context) {
    final TinderNotifier notifier = Provider.of<TinderNotifier>(context);

    final String formattedDate = DateFormat(
      'dd MMMM HH:mm',
    ).format(widget.cat.likedAt);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Card(
        child: ListTile(
          onTap: () async {
            await Navigator.of(context).pushNamed(
              RouteNames.catDetails,
              arguments: [widget.cat.cat],
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                widget.cat.cat.image,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(child: const CircularProgressIndicator()),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Ops, no internet!"),
                              content: const Text(
                                "You have a bad connection. Please, try again later!",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                      );
                    }
                  });
                  return const Icon(Icons.error, size: 50, color: Colors.black);
                },
              ),
            ),
          ),
          title: Text(widget.cat.cat.breed),
          subtitle: Text('Liked on: $formattedDate'),
          trailing: IconButton(
            icon: SvgPicture.asset("assets/images/delete_icon.svg"),
            onPressed: () => notifier.removeLikedCat(widget.cat),
          ),
        ),
      ),
    );
  }
}
