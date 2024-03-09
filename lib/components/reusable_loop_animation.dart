import 'package:flutter/material.dart';

class ReusableLoopAnimation extends StatefulWidget {
  const ReusableLoopAnimation({
    super.key,
    this.duration = const Duration(seconds: 10),
    this.deltaX = 50.0,
    this.curve = Curves.easeInOut,
    required this.child,
  });

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  @override
  State<ReusableLoopAnimation> createState() => _ReusableLoopAnimationState();
}

class _ReusableLoopAnimationState extends State<ReusableLoopAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(widget.deltaX * shake(controller.value), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
