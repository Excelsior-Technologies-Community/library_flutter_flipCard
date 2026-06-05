import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:library_flutter_flipcardview/flipCardView/flipdirection.dart';

class Flipcardview extends StatefulWidget {
  final Widget back;
  final Widget front;
  final Duration duration;
  final Flipdirection flipDirection;
  final Curve curve;

  const Flipcardview({
    super.key,
    required this.back,
    required this.front,
    this.duration = const Duration(milliseconds: 600),
    required this.flipDirection,
    this.curve = Curves.easeInOut,
  });

  @override
  State<Flipcardview> createState() => _FlipcardviewState();
}

class _FlipcardviewState extends State<Flipcardview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this, duration: widget.duration);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  Animation<double> get _animaition => Tween(
    begin: 0.0,
    end: math.pi,
  ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _animaition,
        builder: (context, child) {
          final angle = _animaition.value;
          final isFront = angle < math.pi / 2;

          final matrix = Matrix4.identity()..setEntry(3, 2, 0.001);

          if (widget.flipDirection == Flipdirection.horizontal) {
            matrix.rotateY(angle);
          } else {
            matrix.rotateX(angle);
          }

          return ClipRect(
            child: Transform(
              alignment: Alignment.center,
              transform: matrix,
              child: isFront
                  ? widget.front
                  : Transform(
                      alignment: Alignment.center,
                      transform:
                          widget.flipDirection == Flipdirection.horizontal
                          ? Matrix4.rotationY(math.pi)
                          : Matrix4.rotationX(math.pi),
                      child: widget.back,
                    ),
            ),
          );
        },
      ),
    );
  }
}
