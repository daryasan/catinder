import 'package:catinder/navigation/routes.dart';
import 'package:catinder/widget/cat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../state/tinder_notifier.dart';

import '../model/tinder.dart';

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  State<TinderScreen> createState() => TinderScreenState();
}

class TinderScreenState extends State<TinderScreen> {
  late final TinderNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = TinderNotifier(Tinder());
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier.getNewCat();

    return TinderInheritedNotifier(
      notifier: _notifier,
      child: Scaffold(
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
                LikedCatsWidget(),
                Expanded(
                  child: ValueListenableBuilder<Tinder>(
                    valueListenable: _notifier,
                    builder: (context, tinder, child) {
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            RouteNames.catDetails,
                            arguments: [_notifier.getCurrentCat()],
                          );
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: CatWidget(
                                  height: 450,
                                  cat: _notifier.getCurrentCat(),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onHorizontalDragEnd: (details) async {
                                  if (details.primaryVelocity! > 0) {
                                    // правый свайп
                                    await _notifier.dislikeCat();
                                  } else if (details.primaryVelocity! < 0) {
                                    // левый свайп
                                    await _notifier.likeCat();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                      child: _Button(like: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                      child: _Button(like: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikedCatsWidget extends StatelessWidget {
  const LikedCatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = TinderInheritedNotifier.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: ValueListenableBuilder<Tinder>(
        valueListenable: notifier,
        builder: (context, tinder, child) {
          return Text(
            'Liked Cats: ${tinder.likes}',
            style: const TextStyle(fontSize: 35),
          );
        },
      ),
    );
  }
}

class _Button extends StatefulWidget {
  final bool like;

  const _Button({required this.like});

  @override
  _ButtonState createState() {
    return _ButtonState(like: like);
  }
}

class _ButtonState extends State<_Button> {
  final bool like;
  bool _showLikeIcon = false;

  _ButtonState({required this.like});

  void _triggerLikeAnimation() {
    setState(() {
      _showLikeIcon = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showLikeIcon = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedOpacity(
            opacity: _showLikeIcon ? 1.0 : 0.0,
            duration: Duration(milliseconds: 100),
            child: SvgPicture.asset(
              like
                  ? "assets/images/calm-cat.svg"
                  : "assets/images/angry-cat.svg",
              height: 50,
              width: 50,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            like ? _like(context) : _dislike(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Color(0xFF232323),
            fixedSize: const Size(150, 60),
          ),
          child: Center(
            child: Text(
              like ? "Like" : "Dislike",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _like(BuildContext context) {
    final notifier = TinderInheritedNotifier.of(context);
    _triggerLikeAnimation();
    notifier.likeCat();
  }

  void _dislike(BuildContext context) {
    final notifier = TinderInheritedNotifier.of(context);
    _triggerLikeAnimation();
    notifier.dislikeCat();
  }
}
