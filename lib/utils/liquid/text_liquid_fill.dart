import 'dart:math';
import 'package:flutter/material.dart';

class TextLiquidFill extends StatefulWidget {
  final TextStyle textStyle;
  final TextAlign textAlign;
  final Duration loadDuration;
  final Duration waveDuration;
  final double boxHeight;
  final double boxWidth;
  final String text;
  final Color boxBackgroundColor;
  final Color waveColor;
  final double loadUntil;

  const TextLiquidFill({
    Key? key,
    required this.text,
    this.textStyle =
        const TextStyle(fontSize: 140, fontWeight: FontWeight.bold),
    this.textAlign = TextAlign.left,
    this.loadDuration = const Duration(seconds: 6),
    this.waveDuration = const Duration(seconds: 2),
    this.boxHeight = 250,
    this.boxWidth = 400,
    this.boxBackgroundColor = Colors.black,
    this.waveColor = Colors.blueAccent,
    this.loadUntil = 1.0,
  })  : assert(loadUntil > 0 && loadUntil <= 1.0),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TextLiquidFillState createState() => _TextLiquidFillState();
}

class _TextLiquidFillState extends State<TextLiquidFill>
    with TickerProviderStateMixin {
  final _textKey = GlobalKey();

  late AnimationController _waveController, _loadController;
  late Animation<double> _loadValue;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );
    _loadValue = Tween<double>(
      begin: 0.0,
      end: widget.loadUntil,
    ).animate(_loadController);
    if (1.0 == widget.loadUntil) {
      _loadValue.addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          // Stop the repeating wave when the load has completed to 100%
          _waveController.stop();
        }
      });
    }

    _waveController.repeat();
    _loadController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: _WavePainter(
                  textKey: _textKey,
                  waveValue: _waveController.value,
                  loadValue: _loadValue.value,
                  boxWidth: widget.boxWidth,
                  waveColor: widget.waveColor,

                ),
              );
            },
          ),
        ),
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) => LinearGradient(
              colors: [widget.boxBackgroundColor],
              stops: const [0.0],
            ).createShader(bounds),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  widget.text,
                  key: _textKey,
                  style: widget.textStyle,
                  textAlign: widget.textAlign,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  static const _pi2 = 2 * pi;
  final GlobalKey textKey;
  final double waveValue;
  final double loadValue;
  final double boxWidth;
  final Color waveColor;

  _WavePainter({
    required this.textKey,
    required this.waveValue,
    required this.loadValue,
    required this.boxWidth,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox textBox =
        textKey.currentContext!.findRenderObject() as RenderBox;
    if (textBox == null) return;
    final textWidth = textBox.size.width;
    final baseHeight =
        (boxWidth / 2) + (textWidth / 2) - (loadValue * textWidth);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(baseHeight,0.0);
    for (var i = 0.0; i < height; i++) {
      path.lineTo(baseHeight + cos(_pi2 * (i / height + waveValue)) * 8,i);
    }

    path.lineTo(height,width);
    path.lineTo(height,0.0);
    path.close();
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


//import 'dart:math';
// import 'package:flutter/material.dart';
//
// class TextLiquidFill extends StatefulWidget {
//   final TextStyle textStyle;
//   final TextAlign textAlign;
//   final Duration loadDuration;
//   final Duration waveDuration;
//   final double boxHeight;
//   final double boxWidth;
//   final String text;
//   final Color boxBackgroundColor;
//   final Color waveColor;
//   final double loadUntil;
//
//   const TextLiquidFill({
//     Key? key,
//     required this.text,
//     this.textStyle =
//         const TextStyle(fontSize: 140, fontWeight: FontWeight.bold),
//     this.textAlign = TextAlign.left,
//     this.loadDuration = const Duration(seconds: 6),
//     this.waveDuration = const Duration(seconds: 2),
//     this.boxHeight = 250,
//     this.boxWidth = 400,
//     this.boxBackgroundColor = Colors.black,
//     this.waveColor = Colors.blueAccent,
//     this.loadUntil = 1.0,
//   })  : assert(loadUntil > 0 && loadUntil <= 1.0),
//         super(key: key);
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _TextLiquidFillState createState() => _TextLiquidFillState();
// }
//
// class _TextLiquidFillState extends State<TextLiquidFill>
//     with TickerProviderStateMixin {
//   final _textKey = GlobalKey();
//
//   late AnimationController _waveController, _loadController;
//   late Animation<double> _loadValue;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _waveController = AnimationController(
//       vsync: this,
//       duration: widget.waveDuration,
//     );
//
//     _loadController = AnimationController(
//       vsync: this,
//       duration: widget.loadDuration,
//     );
//     _loadValue = Tween<double>(
//       begin: 0.0,
//       end: widget.loadUntil,
//     ).animate(_loadController);
//     if (1.0 == widget.loadUntil) {
//       _loadValue.addStatusListener((status) {
//         if (AnimationStatus.completed == status) {
//           // Stop the repeating wave when the load has completed to 100%
//           _waveController.stop();
//         }
//       });
//     }
//
//     _waveController.repeat();
//     _loadController.forward();
//   }
//
//   @override
//   void dispose() {
//     _waveController.dispose();
//     _loadController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         SizedBox(
//           height: widget.boxHeight,
//           width: widget.boxWidth,
//           child: AnimatedBuilder(
//             animation: _waveController,
//             builder: (BuildContext context, Widget? child) {
//               return CustomPaint(
//                 painter: _WavePainter(
//                   textKey: _textKey,
//                   waveValue: _waveController.value,
//                   loadValue: _loadValue.value,
//                   boxHeight: widget.boxHeight,
//                   waveColor: widget.waveColor,
//
//                 ),
//               );
//             },
//           ),
//         ),
//         SizedBox(
//           height: widget.boxHeight,
//           width: widget.boxWidth,
//           child: ShaderMask(
//             blendMode: BlendMode.srcOut,
//             shaderCallback: (bounds) => LinearGradient(
//               colors: [widget.boxBackgroundColor],
//               stops: const [0.0],
//             ).createShader(bounds),
//             child: Container(
//               color: Colors.transparent,
//               child: Center(
//                 child: Text(
//                   widget.text,
//                   key: _textKey,
//                   style: widget.textStyle,
//                   textAlign: widget.textAlign,
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
//
// class _WavePainter extends CustomPainter {
//   static const _pi2 = 2 * pi;
//   final GlobalKey textKey;
//   final double waveValue;
//   final double loadValue;
//   final double boxHeight;
//   final Color waveColor;
//
//   _WavePainter({
//     required this.textKey,
//     required this.waveValue,
//     required this.loadValue,
//     required this.boxHeight,
//     required this.waveColor,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final RenderBox textBox =
//         textKey.currentContext!.findRenderObject() as RenderBox;
//     if (textBox == null) return;
//     final textHeight = textBox.size.height;
//     final baseHeight =
//         (boxHeight / 2) + (textHeight / 2) - (loadValue * textHeight);
//
//     final width = size.width;
//     final height = size.height;
//     final path = Path();
//     path.moveTo(0.0, baseHeight);
//     for (var i = 0.0; i < width; i++) {
//       path.lineTo(i, baseHeight + sin(_pi2 * (i / width + waveValue)) * 8);
//     }
//
//     path.lineTo(width, height);
//     path.lineTo(0.0, height);
//     path.close();
//     final wavePaint = Paint()..color = waveColor;
//     canvas.drawPath(path, wavePaint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
