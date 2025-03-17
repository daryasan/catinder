import 'package:catinder/navigation/routes.dart';
import 'package:catinder/widget/cat_widget.dart';
import 'package:catinder/widget/swipe_card.dart';
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
  late double tinderCardHeight;

  double get screenWidth => MediaQuery.sizeOf(context).width;

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
    _notifier.initializeCats();
    _Button buttonLike = _Button(like: true);
    _Button buttonDislike = _Button(like: false);
    tinderCardHeight = screenWidth * 1.1;

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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Center(
                            child: Stack(
                              children: [
                                SwipeCard(
                                  child: CatWidget(
                                    height: tinderCardHeight,
                                    cat: _notifier.getNextByCurrentCat(),
                                  ),
                                ),
                                SwipeCard(
                                  child: CatWidget(
                                    height: tinderCardHeight,
                                    cat: _notifier.getCurrentCat(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buttonDislike, buttonLike],
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
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
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
    return _ButtonState();
  }
}

class _ButtonState extends State<_Button> {
  bool _showLikeIcon = false;

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AnimatedOpacity(
              opacity: _showLikeIcon ? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: SvgPicture.asset(
                widget.like
                    ? "assets/images/calm-cat.svg"
                    : "assets/images/angry-cat.svg",
                height: 50,
                width: 50,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.like ? likeAction(context) : dislikeAction(context);
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
                widget.like ? "Like" : "Dislike",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void likeAction(BuildContext context) {
    final notifier = TinderInheritedNotifier.of(context);
    _triggerLikeAnimation();
    notifier.likeCat();
  }

  void dislikeAction(BuildContext context) {
    final notifier = TinderInheritedNotifier.of(context);
    _triggerLikeAnimation();
    notifier.dislikeCat();
  }
}
