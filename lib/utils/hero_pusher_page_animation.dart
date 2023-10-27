import 'package:flutter/material.dart';

class _HeroPusherController {
  Key pageKey = const ValueKey("hero_pusher");

  final Duration scaleAnimationDuration = const Duration(milliseconds: 250);
  AnimationController? scaleAnimationController;
  Animation<double>? scaleAnimation;

  initializeAnimationController({required TickerProvider vsync}) {
    scaleAnimationController = AnimationController(
      vsync: vsync,
      duration: scaleAnimationDuration,
    );

    scaleAnimation = Tween(begin: 1.0, end: .85).animate(
      CurvedAnimation(
          parent: scaleAnimationController!.view, curve: Curves.easeInExpo),//easeInExpo
    );
  }

  animateScaleTransition(
      {required BuildContext context, required Widget routePage}) {
    scaleAnimationController!.forward().then(
          (value) {
        scaleAnimationController!.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => routePage,
          ),
        );
      },
    );
  }
}

class HeroPusher extends StatefulWidget {
  const HeroPusher({
    Key? key,
    required this.vsync,
    required this.child,
    required this.nextPage,
  }) : super(key: key);

  final TickerProvider vsync;
  final Widget child;
  final Widget nextPage;

  @override
  State<HeroPusher> createState() => _HeroPusherState();
}

class _HeroPusherState extends State<HeroPusher> {
  final _HeroPusherController _heroPusherController =
  _HeroPusherController();

  @override
  void initState() {
    super.initState();
    _heroPusherController.initializeAnimationController(vsync: widget.vsync);
  }

  @override
  void dispose() {
    super.dispose();
    _heroPusherController.scaleAnimationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _heroPusherController.scaleAnimation!,
      child: Hero(
        tag: /*"page_transition"*/ _heroPusherController.pageKey,
        child: GestureDetector(
          onTap: () => _heroPusherController.animateScaleTransition(
              context: context, routePage: widget.nextPage),
          child: widget.child,
        ),
      ),
    );
  }
}

class HeroPusherReceiver extends StatelessWidget {
  HeroPusherReceiver({Key? key, required this.scaffold}) : super(key: key);
  final Scaffold scaffold;

  final _HeroPusherController _heroPusherController =
  _HeroPusherController();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _heroPusherController.pageKey,
      child: scaffold,
    );
  }
}