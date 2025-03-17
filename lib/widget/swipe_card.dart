import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/cupertino.dart';

class SwipeCard extends StatefulWidget {
  final Widget? child;

  const SwipeCard({super.key, this.child});

  @override
  State<StatefulWidget> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  Offset _position = Offset.zero;
  final _animationDuration = const Duration(microseconds: 300);

  double get screenWidth => MediaQuery.sizeOf(context).width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (detail) {
        setState(() {
          _position += detail.delta;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _onPanEnd();
        });
      },
      child: AnimatedContainer(
        duration: _animationDuration,
        transform:
            Matrix4.identity()
              ..rotateZ(_position.dx / screenWidth * 0.3)
              ..translate(_position.dx, _position.dx.abs() * -0.5),
        child: widget.child,
      ),
    );
  }

  void _onPanEnd() async {
    final notifier = TinderInheritedNotifier.of(context);

    if (!_position.dx.isNegative && _position.dx.abs() >= screenWidth / 4) {
      _position = Offset.zero;
      await Future.delayed(_animationDuration);
      notifier.likeCat();
      return;
    }

    if (_position.dx.isNegative && _position.dx.abs() >= screenWidth / 4) {
      _position = Offset.zero;
      await Future.delayed(_animationDuration);
      notifier.dislikeCat();
      return;
    }

    _position = Offset.zero;
  }
}
