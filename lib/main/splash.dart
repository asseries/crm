// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:crm/main/main_screen.dart';
import 'package:crm/main/set_audio_folder_screen.dart';
import 'package:crm/main/set_ip_screen.dart';
import 'package:crm/screen/login/login_screen.dart';
import 'package:crm/utils/animations.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wave_transition/wave_transition.dart';

import '../providers/contact_provider.dart';
import '../providers/theme_provider.dart';
import '../screen/choose_theme/choose_theme.dart';
import '../screen/permission/permission.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? timer;
  double progress = 0;


  @override
  void initState() {
    // PrefUtils.setThemeMode(null);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Permission.notification.request();
    });
    next();
    timer = Timer.periodic(1.milliseconds, (timer) {
      progress += .05;
      setState(() {});
      if (progress > 100) {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
            backgroundColor:
                themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    asScaleAnimation(
                      duration: 1.seconds,
                      begin: 0.0,
                      end: 1.0,
                      child: asBouncingAnimation(
                          animationType: AnimationType.topToBottom,
                          animationForce: AnimationForce.light,
                          duration: 1.seconds,
                          child: Image.asset(
                            "assets/3d/help-desk.png",
                            fit: BoxFit.contain,
                            width: getScreenWidth(context) / 2.5,
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    asScaleAnimation(
                        child: Text(
                      "BDM CALL",
                      style: TextStyle(
                        fontFamily: "p_bold",
                        fontSize: 32,
                        color:
                            themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.COLOR_PRIMARY2,
                      ),
                    ))
                  ],
                ),
              ),
            )),
        Container(
          height: 15,
          margin: const EdgeInsets.symmetric(horizontal: 110, vertical: 16),
          child: progress >= 100
              ? CupertinoActivityIndicator(
                  radius: 14,
                  color: themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
                )
              : LiquidLinearProgressIndicator(
                  value: progress / 100,
                  // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(
                      themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT),
                  // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white,
                  // Defaults to the current Theme's backgroundColor.
                  borderColor:
                      themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY2,
                  borderWidth: 1.0,
                  borderRadius: 12.0,
                  center: Material(
                      color: Colors.transparent,
                      child: Text(
                        "Tizim ishga tushmoqda...",
                        style: TextStyle(
                            color: themeMode == ThemeMode.light ? AppColors.ACCENT : AppColors.COLOR_PRIMARY,
                            fontSize: 10),
                      )),
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                ),
        ),

        // LinearProgressIndicator(
        //   backgroundColor: AppColors.COLOR_PRIMARY,
        //   color: AppColors.COLOR_PRIMARY2,
        // ))
      ],
    );
  }

  Future<void> next() async {
    if (PrefUtils.getThemeMode() == null) {
      await Future.delayed(100.milliseconds,);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseThemeScreen(),
        ),
        (route) => false,
      );
    } else if (!await Permission.contacts.status.isGranted ||
        await Permission.contacts.status.isPermanentlyDenied ||
        !await Permission.phone.status.isGranted ||
        await Permission.phone.status.isPermanentlyDenied ||
        !await Permission.accessMediaLocation.status.isGranted ||
        await Permission.accessMediaLocation.status.isPermanentlyDenied ||
        !await Permission.mediaLibrary.status.isGranted ||
        await Permission.mediaLibrary.status.isPermanentlyDenied ||
        !await Permission.storage.status.isGranted ||
        await Permission.storage.status.isPermanentlyDenied ||
        !await Permission.notification.status.isGranted ||
        await Permission.notification.status.isPermanentlyDenied) {
      Navigator.pushAndRemoveUntil(
        context,
        WaveTransition(
            child: const PermissionScreen(),
            center: const FractionalOffset(0.0, 0.0),
            duration: const Duration(milliseconds: 1000),
            settings: const RouteSettings(arguments: "BDM")),
        (route) => false,
      );
      // startScreenWithAnimationAndRemoveUntil(context, screen: const PermissionScreen());
    }

    // else if(PrefUtils.getIp().isEmpty){
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       WaveTransition(
    //           child: const SetIpScreen(),
    //           center: const FractionalOffset(0.0, 0.0),
    //           duration: const Duration(milliseconds: 1000),
    //           settings: const RouteSettings(arguments: "BDM")),
    //           (route) => false,
    //     );
    //   }
    else if (PrefUtils.getRecFolder().isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        WaveTransition(
            child: const SetAudioFolder(),
            center: const FractionalOffset(0.0, 0.0),
            duration: const Duration(milliseconds: 1000),
            settings: const RouteSettings(arguments: "BDM")),
        (route) => false,
      );
      // startScreenWithAnimationAndRemoveUntil(context, screen: const SetAudioFolder());
    }

    else {
      Provider.of<ContactProvider>(context, listen: false).initContactsFromStorage();
      await Future.delayed(2.seconds);
      Navigator.pushAndRemoveUntil(
        context,
        WaveTransition(
            child: PrefUtils.getToken().isEmpty? const LoginScreen(): const MainScreen(),
            center: const FractionalOffset(0.0, 0.0),
            duration: const Duration(milliseconds: 1000),
            settings: const RouteSettings(arguments: "BDM")),
        (route) => false,
      );
      // startScreenWithAnimationAndRemoveUntil(context, screen: const MainScreen());
    }
  }
}

// Animate(
//
//     effects: [ScaleEffect(),MoveEffect()],
//     child: TextLiquidFill(
//       text: 'BDM CALL RECORDER',
//       waveColor: Colors.black,
//       boxBackgroundColor: Colors.green,
//       textAlign: TextAlign.center,
//       waveDuration: 3.seconds,
//       loadDuration: 2.seconds,
//       textStyle: const TextStyle(
//         fontSize: 50.0,
//         fontWeight: FontWeight.bold,
//       ),
//       boxHeight: getScreenHeight(context),
//       boxWidth: getScreenWidth(context),
//     ))

// Center(
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       // Text(
//       //   "C R M",
//       //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
//       // )
//       //     .animate()
//       //     .fadeIn() // uses `Animate.defaultDuration`
//       //     .scale() // inherits duration from fadeIn
//       //     .move(
//       //     delay: 1000.ms,
//       //     duration: 1000.ms) // runs after the above w/new duration
//       //     .blurXY(begin: 2, delay: 2000.microseconds, end: 0)
//       //     .then(delay: 1.seconds, curve: SawTooth(1000)),
//       TextLiquidFill(
//         text: 'BDM CALL RECORDER',
//         waveColor: Colors.black,
//         boxBackgroundColor: Colors.green,
//         textAlign: TextAlign.center,
//         waveDuration: 3.seconds,
//         loadDuration: 2.seconds,
//         textStyle: const TextStyle(
//           fontSize: 50.0,
//           fontWeight: FontWeight.bold,
//         ),
//         boxHeight: getScreenHeight(context),
//         boxWidth: getScreenWidth(context),
//       )
//     ],
//   ),
// )
//         )
//   }
// }
