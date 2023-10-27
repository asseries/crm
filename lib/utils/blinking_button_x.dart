// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:crm/extensions/extensions.dart';
import 'package:flutter/material.dart';

class BlinkButtonX extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongTap;

  const BlinkButtonX({super.key, required this.child, required this.onTap, this.onLongTap});

  @override
  _BlinkButtonXState createState() => _BlinkButtonXState();
}

class _BlinkButtonXState extends State<BlinkButtonX> with TickerProviderStateMixin {
  double squareScaleAnimation = 1;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.74,
      upperBound: 1.0,
      value: 1,
      duration: 100.milliseconds,
    );
    _animationController.addListener(() {
      setState(() {
        squareScaleAnimation = _animationController.value;
      });
    });

    _animationController.drive(CurveTween(curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _animationController.reverse();
        if (widget.onTap != null) widget.onTap!();
      },
      onTapDown: (dp) {
        _animationController.reverse();
      },
      onTapUp: (dp) {
        Timer(100.milliseconds, () {
          _animationController.fling();
        });
      },
      onTapCancel: () {
        _animationController.fling();
      },
      onLongPress: () {
        if (widget.onLongTap != null) widget.onLongTap!();
      },
      child: Transform.scale(
        scale: squareScaleAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
