import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwipeCard extends StatefulWidget {
  final Widget? child;

  const SwipeCard({super.key, this.child});

  @override
  State<SwipeCard> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  Offset _position = Offset.zero;
  final _animationDuration = const Duration(milliseconds: 300);

  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _position += details.delta;
        });
      },
      onPanEnd: (_) async {
        await _onPanEnd();
        setState(() {}); // Обновление UI после сброса позиции
      },
      child: AnimatedContainer(
        duration: _animationDuration,
        transform: Matrix4.identity()
          ..rotateZ(_position.dx / screenWidth * 0.3)
          ..translate(_position.dx, _position.dx.abs() * -0.5),
        child: widget.child,
      ),
    );
  }

  Future<void> _onPanEnd() async {
    final notifier = Provider.of<TinderNotifier>(context, listen: false);

    if (!_position.dx.isNegative && _position.dx.abs() >= screenWidth / 4) {
      _position = Offset.zero;
      await Future.delayed(_animationDuration);
      await notifier.likeCat();
      return;
    }

    if (_position.dx.isNegative && _position.dx.abs() >= screenWidth / 4) {
      _position = Offset.zero;
      await Future.delayed(_animationDuration);
      await notifier.dislikeCat();
      return;
    }

    _position = Offset.zero;
  }
}
