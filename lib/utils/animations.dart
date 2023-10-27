import 'package:crm/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum AnimationType { leftToRight, rightToLeft, topToBottom, bottomToTop }

enum AnimationForce { hight, medium, light }

class asBouncingAnimation extends StatefulWidget {
  Widget child;
  Curve? curve;
  Duration? duration;
  AnimationType? animationType;
  AnimationForce? animationForce;

  asBouncingAnimation(
      {Key? key,
      required this.child,
      this.duration,
      this.curve,
      this.animationType,
      this.animationForce})
      : super(key: key);

  @override
  State<asBouncingAnimation> createState() => _asBouncingAnimationState();
}

class _asBouncingAnimationState extends State<asBouncingAnimation> {
  @override
  void initState() {
    widget.animationType ??= AnimationType.leftToRight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        duration: widget.duration ?? 1.seconds,
        curve: widget.curve ?? Curves.bounceOut,
        tween: Tween(begin: setAnimationForce(widget.animationForce??AnimationForce.medium), end: 0.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: setAnimationType(
                widget.animationType ?? AnimationType.leftToRight,value),
            child: child,
          );
        },
        child: widget.child);
  }

  Offset setAnimationType(AnimationType animationType, double value) {
    if (animationType == AnimationType.leftToRight) {
      return Offset(value * 60, 0.0);
    } else if (animationType == AnimationType.rightToLeft) {
      return Offset(value * (-60), 0.0);
    } else if (animationType == AnimationType.bottomToTop) {
      return Offset(0.0, value * 60);
    } else if (animationType == AnimationType.topToBottom) {
      return Offset(0.0, value * (-60));
    }
    return Offset(0.0, value * 100);
  }

  double setAnimationForce(AnimationForce animationForce) {
    if (animationForce == AnimationForce.hight) {
      return 8.0;
    } else if (animationForce == AnimationForce.light) {
      return 2.0;
    } else {
      return 4.0;
    }
  }
}

///Animates the child
///
///using TweenAnimationBuilder
class asScaleAnimation extends StatelessWidget {
  const asScaleAnimation({
    Key? key,
    required this.child,
    this.begin = 0.4,
    this.end = 1,
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  ///Animate from value
  ///
  ///[default value 0.4]
  final double begin;

  ///Animate to value
  ///
  ///[default value 1]
  final double end;

  ///Animation Duration
  ///
  ///[default is 750ms]
  final Duration duration;

  ///Animation delay
  ///
  ///[default is 0]
  final double intervalStart;

  ///Animation delay
  ///
  ///[default is 1]
  final double intervalEnd;

  ///Animation Curve
  ///
  ///[default is Curves.fastOutSlowIn]
  final Curve curve;

  ///This widget will be animated
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: Interval(intervalStart, intervalEnd, curve: curve),
      child: child,
      builder: (BuildContext context, double? value, Widget? child) {
        return Transform.scale(
          scale: value!,
          child: child,
        );
      },
    );
  }
}
