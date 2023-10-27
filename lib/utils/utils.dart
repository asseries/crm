import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wave_transition/wave_transition.dart';

import '../main.dart';
import 'app_colors.dart';

//theme
ThemeData lightTheme = ThemeData.light();

ThemeData darkBlueTheme = ThemeData(
  primaryColor: const Color(0xFF1E1E2C),
  scaffoldBackgroundColor: const Color(0xFF2D2D44),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: Color(0xFF33E1Ed),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark();

List<LinearGradient> gradientList = [
  LinearGradient(
    colors: [
      Colors.cyanAccent.withOpacity(.7),
      Colors.green.withOpacity(.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [
      Colors.green.withOpacity(.7),
      Colors.blue.withOpacity(.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [
      Colors.greenAccent.withOpacity(.7),
      Colors.blue.withOpacity(.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [
      Colors.lightBlueAccent.withOpacity(.7),
      Colors.teal.withOpacity(.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [
      Colors.lightBlueAccent.withOpacity(.7),
      Colors.yellow.withOpacity(.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];

final RANDOM_COLORS = [
  AppColors.TEAL,
  AppColors.CYAN,
  AppColors.BASIC_BLACK,
  AppColors.RED,
  AppColors.PUMPKIN,
  AppColors.YELLOW,
  AppColors.GREEN,
  AppColors.BLUE
];

final RANDOM_TASKS_COLORS = [
  AppColors.RANDOM1,
  AppColors.RANDOM2,
  AppColors.RANDOM3,
  AppColors.RANDOM4,
  AppColors.RANDOM5,
  AppColors.RANDOM6,
  AppColors.RANDOM7,
  AppColors.RANDOM8,
  AppColors.RANDOM9,
  AppColors.RANDOM10,
];

//types
double? typeToDouble(dynamic number) {
  if (number is int) {
    return number.toDouble();
  } else if (number is String) {
    return double.parse(number);
  } else {
    return number;
  }
}

void setOrientation(bool or) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          or ? [DeviceOrientation.portraitUp] : [DeviceOrientation.landscapeLeft])
      .then((_) {});
}

double random(int max) {
  var rng = Random();
  return rng.nextInt(max).toDouble();
}

Future startScreen(BuildContext context, {required StatefulWidget screen}) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

Future startScreenSS(BuildContext context, {required StatelessWidget screen}) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

//  @optionalTypeArgs
//   static Future<T?> push<T extends Object?>(BuildContext context, Route<T> route) {
//     return Navigator.of(context).push(route);
//   }

@optionalTypeArgs
Future startScreenWithAnimation(BuildContext context, {required StatefulWidget screen}) {
  return Navigator.push(
    context,
    WaveTransition(
        child: screen,
        center: const FractionalOffset(0.0, 0.0),
        duration: const Duration(milliseconds: 1000),
        settings: const RouteSettings(arguments: "BDM")),
  );
}

// @optionalTypeArgs
// Future startScreenWithAnimationAndRemoveUntil(BuildContext context, {required StatefulWidget screen}) {
//   return Navigator.pushAndRemoveUntil(
//     context,
//     WaveTransition(
//         child: screen,
//         center: const FractionalOffset(0.0, 0.0),
//         duration: const Duration(milliseconds: 1000),
//         settings: const RouteSettings(arguments: "BDM")),
//     (route) => false,
//   );
// }

@optionalTypeArgs
void finish<T extends Object?>(BuildContext context, [T? result]) {
  return Navigator.of(context).pop<T>(result);
}

class CirclePainter extends CustomPainter {
  Color color = AppColors.ACCENT;
  final Paint _paint = Paint()
    ..color = AppColors.COLOR_PRIMARY_DARK
    ..strokeWidth = 1
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void clearFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode()); //remove focus
}

TextStyle asTextStyle(
    {String? fontFamily,
    // Color? color,
    double? size,
    double? height,
    TextDecoration? decoration,
    FontWeight? fontWeight,
    List<Shadow>? shadow,
    TextOverflow? overflow}) {
  return TextStyle(
      fontFamily: fontFamily ?? "p_reg",
      // color: color,
      fontSize: size ?? 14,
      shadows: shadow,
      overflow: overflow,
      height: height,
      fontWeight: fontWeight,
      decoration: decoration);
}

String getChars(String words, int limitTo) {
  List<String> names = words.split(" ");
  String initials = '';
  for (var i = 0; i < names.length; i++) {
    initials += names[i][0];
    if (i >= limitTo - 1) return initials;
  }
  return initials;
}

String getCurrentDateTime() {
  var now = DateTime.now();
  var formatter = DateFormat('dd.MM.yyyy HH:mm');
  String formattedDate = formatter.format(now);
  print(formattedDate); // 2016-01-25
  return formattedDate;
}

String asDateFormater(DateTime dateTime) {
  var formatter = DateFormat('dd.MM.yyyy HH:mm');
  return formatter.format(dateTime);
}

double getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

void vibrateMedium() {
  HapticFeedback.mediumImpact();
}

void vibrateLight() {
  HapticFeedback.lightImpact();
}

void vibrateHeavy() {
  HapticFeedback.heavyImpact();
}

void showSnackeBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
}

void showCustomDialog(BuildContext context, Widget child, {Alignment? alignment}) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        alignment ??= Alignment.center;
        return Align(
          alignment: alignment!,
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: [],
                  border: Border.all(
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: child),
        );
      });
}

asTextField(
  BuildContext context, {
  TextEditingController? controller,
  String? label,
  String? fontFamily,
  Color? textColor,
  // String? hintText,
  TextStyle? hintStyle,
  BorderRadius? borderRadius,
  // Color? fillColor,
  // Color? focusedBorderColor,
  // Color? borderColor,
  // Color? labelColor,
  double? borderWidth,
  int? minLines,
  int? maxLines,
  double? focusedBorderWidth,
  bool? borderVisibility,
  EdgeInsetsGeometry? contentPadding,
  bool? enabled,
  TextInputType? textInputType,
  ValueChanged<String>? onChanged,
  List<TextInputFormatter>? inputFormatters,
  TextStyle? textStyle,
  FocusNode? focusNode,
  int? maxLength,
  String? hintText,
  bool? readOnly,
  TextAlign? textAlign,
}) {
  borderVisibility ??= true;
  borderWidth ??= borderVisibility ? 1 : 0;
  // borderColor ??= borderVisibility ? Colors.black26 : fillColor;
  focusedBorderWidth ??= borderVisibility ? 1 : 0;
  inputFormatters ??= [];
  hintStyle ??= asTextStyle();
  textStyle ??= const TextStyle(
    // color: Colors.black,
    fontSize: 14,
  );
  readOnly ??= false;
  textAlign ??= TextAlign.left;
  // fillColor ??= Provider.of<AppTheme>(context).getThemeMode() == ThemeMode.dark?AppColors.WHITE:AppColors.COLOR_PRIMARY;
  // focusedBorderColor ??= Provider.of<AppTheme>(context).getThemeMode() == ThemeMode.dark?AppColors.WHITE:AppColors.COLOR_PRIMARY;

  return TextFormField(
    textAlign: textAlign,
    enabled: enabled ?? true,
    controller: controller,
    obscureText: false,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    maxLength: maxLength,
    readOnly: readOnly,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: textInputType ?? TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      border: InputBorder.none,
      hintText: hintText,
      counterText: "",
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        // color: labelColor ?? textColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // hintText: hintText,
      hintStyle: hintStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          // color: borderColor!,
          width: borderWidth,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          // color: focusedBorderColor!,
          width: focusedBorderWidth,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      filled: true,
      // fillColor: fillColor,
      contentPadding: contentPadding ?? const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
    ),
    style: textStyle,
    focusNode: focusNode,
  );
}

Widget asButton(
  BuildContext context, {
  required Function onPressed,
  required Widget child,
  EdgeInsets? margin,
  EdgeInsets? padding,
  double? height,
  double? width,
  Alignment? alignment,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  double? elevation,
}) {
  elevation ??= 0.5;
  return Container(
    height: height,
    width: width,
    margin: margin,
    padding: padding,
    alignment: alignment,
    child: ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: child,
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: MaterialStateProperty.all(backgroundColor ?? AppColors.COLOR_PRIMARY),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(8)))),
    ),
  );
}

showAsBottomSheet(
  BuildContext context,
  Widget child, {
  EdgeInsets? margin,
  double? topRadiuses,
  Color? backgroundColor,
  Color? borderColor,
  double? borderWidth,
  double? minHeight,
  double? maxHeight,
  double? shapeHeight,
  double? shadowBlurRadius,
  // Color? barrierColor
}) {
  topRadiuses ??= 16;
  // backgroundColor ??= AppColors.BACKGROUND_COLOR;
  margin ??= const EdgeInsets.all(12);
  // borderColor ??= AppColors.ACCENT;
  borderWidth ??= 1.0;
  minHeight ??= 100;
  // barrierColor ??= AppColors.BLACK.withOpacity(.7);
  maxHeight ??= MediaQuery.of(context).size.height * .9;
  shapeHeight ??= 10;
  shadowBlurRadius ??= 8;
  showModalBottomSheet(
    context: context,
    // barrierColor: barrierColor,
    isScrollControlled: true,
    // only work on showModalBottomSheet function
    shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(topRadiuses), topRight: Radius.circular(topRadiuses)),
        side: BorderSide(
          width: borderWidth,
          // color: borderColor,
        )),
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              // color: AppColors.ACCENT,
              blurRadius: shadowBlurRadius ?? 8,
              offset: const Offset(1, 1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(topRadiuses!), topLeft: Radius.circular(topRadiuses)),
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.AppColors.WHITE70),
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("       "),
                  Container(
                    width: 60,
                    height: shapeHeight,
                    decoration: BoxDecoration(
                        // color: AppColors.ACCENT.withOpacity(.4),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: AppColors.RED,
                      ))
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight!, maxHeight: maxHeight!
                  // minWidth: 5.0,
                  // maxWidth: 30.0,
                  ),
              child: Container(margin: margin, child: child),
            ),
          ],
        ),
      ),
    ),
  );
}

showAnimatedBlinkDialog(BuildContext context,
    {required Widget child, Duration? duration, Color? barrierColor, bool? closeIconEnabled}) {
  duration ??= const Duration(milliseconds: 700);
  barrierColor ??= Colors.black.withOpacity(.5);
  closeIconEnabled ??= true;
  showGeneralDialog(
    context: context,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        alignment: Alignment.center,
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
          reverseCurve: Curves.bounceIn,
        ),
        child: child,
      );
    },
    transitionDuration: duration,
    barrierColor: barrierColor,
    useRootNavigator: true,
    pageBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    child,
                    if (closeIconEnabled ?? true)
                      Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              finish(context);
                            },
                            icon: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 16,
                                ))),
                      )
                  ],
                )),
          ),
        ),
      );
    },
  );
}

showMyGeneralDialog(
  BuildContext context,
  Widget child, {
  Alignment? alignment,
  Color? backgraoundColor,
}) {
  backgraoundColor ??= AppColors.COLOR_PRIMARY_DARK.withOpacity(.7);
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      alignment ??= Alignment.center;
      backgraoundColor ??= Colors.white;
      return Align(
        alignment: alignment!,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: backgraoundColor!.withAlpha(80),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: backgraoundColor!.withAlpha(80),
                  spreadRadius: -4,
                  blurRadius: 5,
                )
              ],
              color: backgraoundColor!,
              border: Border.all(width: 0.5, color: backgraoundColor!.withAlpha(200)),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.3, color: AppColors.WHITE)),
            child: Material(
                color: backgraoundColor!,
                child: Stack(
                  children: [
                    child,
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(""),
                            Container(
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(32), boxShadow: [
                                  BoxShadow(
                                    color: AppColors.WHITE.withAlpha(70),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  )
                                ]),
                                child: Icon(
                                  Icons.clear,
                                  size: 14,
                                  color: AppColors.RED,
                                )),
                          ],
                        ))
                  ],
                )),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}

Widget showAsProgress({Color? backColor}) {
  backColor ??= AppColors.BLACK.withOpacity(.2);
  return Container(
      alignment: Alignment.center,
      color: backColor,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: AppColors.ACCENT, blurRadius: 150, spreadRadius: 1, blurStyle: BlurStyle.normal)
          ],
          // border: Border.all(color: AppColors.WHITE, width: 1),
          color: AppColors.COLOR_PRIMARY.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: AppColors.WHITE,
          backgroundColor: AppColors.MIDDLE_GREY,
        ),
      ));
}

//NuemText
// Text(
//                   "Торговые программы",
//                   style: TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.AppColors.GREY.shade50,
//                       shadows: [
//                         Shadow(
//                             color: Colors.AppColors.GREY.shade300,
//                             offset: Offset(3.0, 3.0),
//                             blurRadius: 3),
//                         Shadow(
//                             color: Colors.AppColors.WHITE,
//                             offset: Offset(-3.0, 3.0),
//                             blurRadius: 3),
//                       ]),
//                 ),

//neum Decoration

// BoxDecoration(
//                         borderRadius: BorderRadius.circular(6.0),
//                         color: Colors.AppColors.WHITE,
//                         shape: BoxShape.rectangle,
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.AppColors.GREY.shade300,
//                               spreadRadius: 0.0,
//                               blurRadius: 1,
//                               offset: Offset(3.0, 3.0)),
//                           BoxShadow(
//                               color: Colors.AppColors.GREY.shade400,
//                               spreadRadius: 0.0,
//                               blurRadius: 1 / 2.0,
//                               offset: Offset(3.0, 3.0)),
//                           BoxShadow(
//                               color: Colors.AppColors.WHITE,
//                               spreadRadius: 2.0,
//                               blurRadius: 1,
//                               offset: Offset(-3.0, -3.0)),
//                           BoxShadow(
//                               color: Colors.AppColors.WHITE,
//                               spreadRadius: 2.0,
//                               blurRadius: 1 / 2,
//                               offset: Offset(-3.0, -3.0)),
//                         ],
//                       ),

//neum Container
//    Container(
//                   margin: EdgeInsets.all(8),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: LIGHT_AppColors.GREY,
//                       border: Border.all(width: 1, color: AppColors.MIDDLE_AppColors.GREY.withOpacity(.2)),
//                       boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 4, color: AppColors.MIDDLE_AppColors.GREY,
//                           offset: Offset(5, 5))]),
//                   child: Column(children: [
//                     SvgPicture.asset("assets/images/delivery.svg", height: 48),
//                     Text(
//                       "Торговые программы",
//                       style: asTextStyle(fontFamily: "as_thin"),
//                     ),
//                   ]),
//                 )

String formatHHMMSS(int seconds) {
  // int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  // String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(1, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  // if (hours == 0) {
  //   return "$minutesStr:$secondsStr";
  // }
//$hoursStr:
  return "$minutesStr:$secondsStr";
}

// String dayBetween(String end_date) {
//   DateTime now = DateTime.now(); // 30/09/2021 15:54:30
//   DateTime startDate = DateTime.parse(now.toString().substring(0,10).replaceAll("/", "-"));
//   DateTime endDate = DateTime.parse(fixDateFormat(end_date)); //DateTime.now();
//   return endDate.difference(startDate).inDays.toString();
// }

String dayBetween(String end_date) {
  try {
    DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    DateTime startDate = DateTime.parse(now.toString().substring(0, 10).replaceAll("/", "-"));
    DateTime endDate = DateTime.parse(fixDateFormat(end_date)); //DateTime.now();
    return endDate.difference(startDate).inDays.toString();
  } catch (e) {
    return "NAN ";
  }
}

String dateFormatter(String date) {
  final _inputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  final DateFormat _dateFormatter = DateFormat('dd.MM.yyyy');
  // final DateFormat _timeFormatter = DateFormat('HH:mm:ss');
  final String formatted = _dateFormatter.format(_inputFormat.parse(date));
  return formatted;
}

String fixDateFormat(String date) {
  //23.08.2022 0:00:00

  // format  --> '2019-9-11'
  var year = date.substring(6, 10);
  var month = date.substring(3, 5);
  var day = date.substring(0, 2);
  return "${year}-${month}-${day}";
}

String fixReverseDateFormat(String date) {
  //2023-12-14 0:00:00
  var year = date.substring(0, 4);
  var month = date.substring(5, 7);
  var day = date.substring(8, 10);
  return "$day.$month.$year";
}

class getDate {
  var _date;
  final _inputFormat = DateFormat('dd.MM.yyyy');
  final _dayFormat = DateFormat('dd');
  final _monthFormat = DateFormat('MMMM', "uz-UZ");
  final _monthInNumberFormat = DateFormat('MM');
  final _yearFormat = DateFormat('yyyy');
  final _weekFormat = DateFormat('EEE', "uz-UZ");

  getDate(String this._date);

  String getDay() {
    return _dayFormat.format(_inputFormat.parse(_date));
  }

  int getWeekInNumber() {
    return int.parse(_monthInNumberFormat.format(_inputFormat.parse(_date)));
  }

  String getWeek() {
    return _weekFormat.format(_inputFormat.parse(_date));
  }

  String getMonth() {
    return _monthFormat.format(_inputFormat.parse(_date)).capitalize();
  }

  String getYear() {
    return _yearFormat.format(_inputFormat.parse(_date));
  }
}

// Widget asCardButton(
//     {required Widget child,
//     EdgeInsets? padding,
//     // Color? backgroundColor,
//     // Color? pressedColor,
//     // Color? splashColor,
//     bool? absorbing,
//     BorderRadius? borderRadius,
//     EdgeInsets? margin,
//     required Function onPressed,
//     // Color? shadowColor,
//     double? width,
//     double? height,
//     List<BoxShadow>? boxShadow}) {
//   padding ??= const EdgeInsets.all(8);
//   // shadowColor ??= Colors.white;
//   // backgroundColor ??= Colors.white;
//   // pressedColor ??= Colors.black12;
//   // splashColor ??= Colors.white;
//   margin ??= const EdgeInsets.all(0);
//   borderRadius ??= BorderRadius.circular(8);
//   absorbing ??= false;
//   boxShadow ??= [
//     BoxShadow(
//         // color: shadowColor,
//         blurRadius: 6,
//         spreadRadius: 1,
//         blurStyle: BlurStyle.outer)
//   ];
//   return AbsorbPointer(
//     absorbing: absorbing,
//     child: Card(
//         shape: RoundedRectangleBorder(borderRadius: borderRadius),
//         elevation: 4,
//         // color: backgroundColor,
//         //.withOpacity(.7),
//         margin: margin,
//         child: InkWell(
//           onTap: () {
//             onPressed();
//           },
//           // highlightColor: pressedColor,
//           // splashColor: splashColor,
//           borderRadius: borderRadius,
//           child: Container(
//             width: width,
//             height: height,
//             decoration: BoxDecoration(
//               // color: backgroundColor.withOpacity(.2),
//               borderRadius: borderRadius,
//               boxShadow: boxShadow,
//             ),
//             padding: padding,
//             child: child,
//           ),
//         )),
//   );
// }

bool isLandscape(BuildContext context) {
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    return true;
  } else {
    return false;
  }
}

Widget asDoubledText(String firstText, String secondText, {TextStyle? textStyle1, TextStyle? textStyle2}) {
  textStyle1 ??= asTextStyle();
  textStyle2 ??= asTextStyle();
  return RichText(
      text: TextSpan(
          text: firstText, style: textStyle1, children: [TextSpan(text: secondText, style: textStyle2)]));
}

Widget asCachedNetworkImage(String? url, {double? height, double? width, BoxFit? fit}) {
  return CachedNetworkImage(
    imageUrl: PrefUtils.getBaseImageUrl() + (url ?? ""),
    placeholder: (context, url) => const Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.grey,
            ))),
    errorWidget: (context, url, error) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
            color: Colors.grey.shade50,
            child: Center(
                child: Image.asset(
              "assets/images/logo.png",
              width: 32,
              height: 32,
            )))),
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
  );
}

Widget asAssetImage(String assetImage, {double? size, BoxFit? fit, AlignmentGeometry? alignment}) {
  assetImage = "assets/images/${assetImage}";
  alignment ??= Alignment.center;
  return Image.asset(
    assetImage,
    height: size,
    width: size,
    fit: fit,
    alignment: alignment,
  );
}

Widget asBluredForeground({
  double? height,
  double? width,
  required Widget child,
  AlignmentGeometry? alignmet,
  BorderRadius? borderRadius,
  double? sigma,
  EdgeInsetsGeometry? margin,
  EdgeInsets? padding,
  Border? border,
  List<BoxShadow>? boxShadow,
  Color? color,
}) {
  borderRadius ??= BorderRadius.circular(0);
  sigma ??= 1;
  margin ??= EdgeInsets.zero;
  return Padding(
    padding: margin,
    child: ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
            width: width,
            height: height,
            padding: padding,
            clipBehavior: Clip.antiAlias,
            alignment: alignmet,
            decoration: BoxDecoration(
              boxShadow: boxShadow,
              color: color,
              borderRadius: borderRadius,
              border: border,
            ),
            child: child),
      ),
    ),
  );
}

class AsPopupMenu extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<AsMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  bool? menuUnderLine;

  /// Open with tap insted of long press.
  final bool openWithTap;

  AsPopupMenu(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false,
      this.menuUnderLine = true})
      : super(key: key);

  @override
  _AsPopupMenuState createState() => _AsPopupMenuState();
}

class _AsPopupMenuState extends State<AsPopupMenu> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: AsMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    menuUnderline: widget.menuUnderLine ?? true,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class AsMenuDetails extends StatelessWidget {
  final List<AsMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool? menuUnderline;

  AsMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.menuUnderline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) < size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                  child: Container(
                    color: (blurBackgroundColor ?? Colors.black),
                  ),
                )),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 200),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)
                          ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        AsMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: menuUnderline!
                                    ? const EdgeInsets.only(bottom: 0.5)
                                    : const EdgeInsets.only(bottom: 0),
                                color: item.backgroundColor ?? Colors.white,
                                //menu item height
                                height: itemExtent ?? 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item.title,
                                      if (item.trailingIcon != null) ...[item.trailingIcon!]
                                    ],
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            //Tanlangan item, bulursiz chiqishi uchun ustida boshqattan chaqirilgan
            Positioned(
                top: childOffset.dy,
                left: childOffset.dx,
                child: AbsorbPointer(
                    absorbing: true,
                    child: Container(width: childSize!.width, height: childSize!.height, child: child))),
          ],
        ),
      ),
    );
  }
}

class AsMenuItem {
  Color? backgroundColor;
  Widget title;
  Icon? trailingIcon;
  Function onPressed;

  AsMenuItem({this.backgroundColor, required this.title, this.trailingIcon, required this.onPressed});
}

// asBluredForeground(
//                   height: 103,
//                   child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(32),
//                           border: Border.all(
//                               color: AppColors.COLOR_PRIMARY,
//                               width: .5)),
//                       padding: EdgeInsets.symmetric(
//                           vertical: 2, horizontal: 12),
//                       child: Text(
//                         "Ishlab\nchiqilmoqda...",
//                         style: asTextStyle(
//                             color: AppColors.COLOR_PRIMARY
//                                 .withOpacity(.6),
//                             fontFamily: "p_semi",
//                             size: 12),
//                         textAlign: TextAlign.center,
//                       )),
//                   sigma: 3,
//                   width: getScreenWidth(context) / 2.0 - 25.0,
//                   alignmet: Alignment.bottomCenter,
//                   padding: const EdgeInsets.only(bottom: 16),
//                   margin: const EdgeInsets.all(8),
//                   border: Border.all(
//                     color: AppColors.COLOR_PRIMARY.withOpacity(.2),
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(12)),

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

String uint8ListTobase64(Uint8List? uint8list) {
  if (uint8list != null) {
    return base64Encode(uint8list);
  }
  return "";
}

String uint8ListToString(Uint8List someData) {
  List<int> list = someData;
  Uint8List bytes = Uint8List.fromList(list);
  return String.fromCharCodes(bytes);
}

void showScaffoldMessage(BuildContext context, {String? message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message ?? "AAAA")));
}

void postLocalNotify(String title, String body, bool updateCurrent) {
  MyApp.platform
      .invokeMethod('showNotification', {'title': title, 'body': body, 'updateCurrent': updateCurrent});
}

String intToTimeLeft(int value) {
  int h, m, s;
  h = value ~/ 3600;
  m = ((value - h * 3600)) ~/ 60;
  s = value - (h * 3600) - (m * 60);
  String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();
  String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();
  String result = "$hourLeft:$minuteLeft:$secondsLeft";
  return h == 0 ? result.substring(3, 8) : result;
}

SizedBox getStatusBarWidget(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).viewPadding.top);
}

var now = DateTime.now();
var now_1w = now.subtract(7.days);
var now_1m = DateTime(now.year, now.month - 1, now.day);
var now_1y = DateTime(now.year - 1, now.month, now.day);

//use
//where((element) {
//            final date = element.date;
//            return now_1w.isBefore(date);
//          }

// Format File Size
String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["Bayt", "KB", "MB", "GB", "TB"];
  var i = 1;
  try {
    i = (log(bytes) / log(1024)).floor();
  } catch (e) {
    i = 2;
  }
  return "${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
}

