import 'package:catinder/navigation/routes.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:catinder/widget/cat_widget.dart';
import 'package:catinder/widget/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TinderScreen extends StatelessWidget {
  const TinderScreen({super.key});

  double getTinderCardHeight(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * 1.1;
  }

  @override
  Widget build(BuildContext context) {
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
            children: const [
              LikedCatsWidget(),
              SeeLikedButton(),
              TinderCardsWidget(),
              ActionButtonsRow(),
            ],
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
    final TinderNotifier notifier = Provider.of<TinderNotifier>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Text(
        'LIKED CATS: ${notifier.likes}',
        style: const TextStyle(fontSize: 35),
      ),
    );
  }
}

class SeeLikedButton extends StatelessWidget {
  const SeeLikedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(RouteNames.likedCats);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color(0xFF232323),
          fixedSize: const Size(300, 40),
        ),
        child: const Center(
          child: Text(
            "See liked cats",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class TinderCardsWidget extends StatelessWidget {
  const TinderCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double tinderCardHeight = MediaQuery.of(context).size.width;
    final TinderNotifier notifier = Provider.of<TinderNotifier>(context);
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).pushNamed(
            RouteNames.catDetails,
            arguments: [notifier.currentCat],
          );
        },
        child: Center(
          child: Stack(
            children: [
              SwipeCard(
                child: CatWidget(
                  height: tinderCardHeight,
                  cat: notifier.nextCat,
                ),
              ),
              SwipeCard(
                child: CatWidget(
                  height: tinderCardHeight,
                  cat: notifier.currentCat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [_ActionButton(like: false), _ActionButton(like: true)],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final bool like;

  const _ActionButton({required this.like});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _showLikeIcon = false;

  void _triggerLikeAnimation() {
    setState(() {
      _showLikeIcon = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
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
              duration: const Duration(milliseconds: 100),
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
              _triggerLikeAnimation();
              final TinderNotifier notifier =
              Provider.of<TinderNotifier>(context, listen: false);
              widget.like ? notifier.likeCat() : notifier.dislikeCat();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: const Color(0xFF232323),
              fixedSize: const Size(150, 60),
            ),
            child: Center(
              child: Text(
                widget.like ? "Like" : "Dislike",
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
