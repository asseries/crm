// ignore_for_file: use_build_context_synchronously

import 'package:crm/main/main_screen.dart';
import 'package:crm/screen/permission/permission.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wave_transition/wave_transition.dart';

import '../../main/set_audio_folder_screen.dart';
import '../../providers/contact_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/pref_utils.dart';
import '../login/login_screen.dart';

class ChooseThemeScreen extends StatefulWidget {
  const ChooseThemeScreen({Key? key}) : super(key: key);

  @override
  State<ChooseThemeScreen> createState() => _ChooseThemeScreenState();
}

class _ChooseThemeScreenState extends State<ChooseThemeScreen> {
  int _groupValue = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<ContactProvider>(context, listen: false).initContactsFromStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          PrefUtils.getThemeMode() == ThemeMode.light ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/3d/help-desk.png",
                width: getScreenWidth(context) / 2.5,
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ilova mavzusini tanlang!",
                      style: TextStyle(
                        fontFamily: "p_bold",
                        fontSize: 24,
                        color: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.COLOR_PRIMARY2,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY
                                  : AppColors.COLOR_PRIMARY2,
                              width: 1)),
                      width: getScreenWidth(context) / 1.1,
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: 0,
                              groupValue: _groupValue,
                              activeColor: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY
                                  : AppColors.ACCENT,
                              onChanged: (v) {
                                _groupValue = 0;
                                themeService.setThemeMode(ThemeMode.dark);
                                PrefUtils.setThemeMode(ThemeMode.dark);
                                setState(() {});
                              },
                              title: Text(
                                "Qorong'u",
                                style: TextStyle(
                                  color: PrefUtils.getThemeMode() == ThemeMode.light
                                      ? AppColors.COLOR_PRIMARY
                                      : AppColors.COLOR_PRIMARY2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.BLACK,
                              ),
                              child: Image.asset(
                                "assets/images/light_t.png",
                                height: 24,
                                width: 24,
                                color: AppColors.WHITE,
                              ))
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY
                                  : AppColors.COLOR_PRIMARY2,
                              width: 1)),
                      width: getScreenWidth(context) / 1.1,
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              groupValue: _groupValue,
                              activeColor: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY
                                  : AppColors.ACCENT,
                              onChanged: (v) {
                                _groupValue = 1;
                                themeService.setThemeMode(ThemeMode.light);
                                PrefUtils.setThemeMode(ThemeMode.light);
                                setState(() {});
                              },
                              title: Text(
                                "Kunduzgi",
                                style: TextStyle(
                                  color: PrefUtils.getThemeMode() == ThemeMode.light
                                      ? AppColors.COLOR_PRIMARY
                                      : AppColors.COLOR_PRIMARY2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.WHITE,
                              ),
                              child: Image.asset(
                                "assets/images/dark_t.png",
                                height: 24,
                                width: 24,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    //KIRISH
                    asButton(context, onPressed: () async {
                      if (_groupValue == 0) {
                        themeService.setThemeMode(ThemeMode.dark);
                        PrefUtils.setThemeMode(ThemeMode.dark);
                      }
                      onNext();
                    },
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 48,
                        child: Text(
                          "KIRISH",
                          style: TextStyle(
                              color: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY2
                                  : AppColors.COLOR_PRIMARY,
                              fontFamily: "p_bold",
                              fontSize: 18),
                        ),
                        width: getScreenWidth(context) / 1.1)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onNext() async {
    if (!await Permission.contacts.status.isGranted ||
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
    }
    else if (PrefUtils.getRecFolder().isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SetAudioFolder()));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        WaveTransition(
            child: PrefUtils.getToken().isEmpty? const LoginScreen(): const MainScreen(),
            center: const FractionalOffset(0.0, 0.0),
            duration: const Duration(milliseconds: 1000),
            settings: const RouteSettings(arguments: "BDM")),
            (route) => false,
      );
    }
  }
}
