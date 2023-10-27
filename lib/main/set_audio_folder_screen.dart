// ignore_for_file: use_build_context_synchronously

import 'package:crm/extensions/extensions.dart';
import 'package:crm/main/main_screen.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wave_transition/wave_transition.dart';

import '../main.dart';
import '../providers/contact_provider.dart';
import '../providers/theme_provider.dart';
import '../screen/login/login_screen.dart';
import '../screen/permission/permission.dart';
import '../utils/utils.dart';

class SetAudioFolder extends StatefulWidget {
  const SetAudioFolder({Key? key}) : super(key: key);

  @override
  State<SetAudioFolder> createState() => _SetAudioFolderState();
}

class _SetAudioFolderState extends State<SetAudioFolder> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<ContactProvider>(context, listen: false).initContactsFromStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.getThemeMode() == ThemeMode.light ? Colors.grey.shade300 : Colors.blueGrey.shade900,
      body: Container(
        height: getScreenHeight(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(child: Center()),
            Image.asset(
              "assets/3d/folder.png",
              width: getScreenWidth(context) / 2.5,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Iltimos avval audioni topish uchun audiolar saqlangan papkani tanlang",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "p_semi",
                color: themeProvider.getThemeMode() == ThemeMode.dark
                    ? Colors.grey.shade100
                    : Colors.blueGrey.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: Center(
              child: Text(
                PrefUtils.getRecFolder().isEmpty ? "(Bo'sh)" : PrefUtils.getRecFolder(),
                style: TextStyle(fontFamily: "p_semi", color: Colors.grey.shade600),
              ),
            )),
            InkWell(
              onTap: () async {
                vibrateLight();
                await MyApp.openFolder(context);
                setState(() {});
                await Future.delayed(1.seconds);
                if (PrefUtils.getRecFolder().isNotEmpty) {
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
                    // startScreenWithAnimationAndRemoveUntil(context, screen: const PermissionScreen());
                  }else{
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
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeProvider.getThemeMode() == ThemeMode.dark
                        ? Colors.grey.shade300
                        : Colors.blueGrey.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
                            size: 16,
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Papkani izlash".toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.getThemeMode() == ThemeMode.light
                                  ? Colors.grey.shade300
                                  : Colors.blueGrey.shade900),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: themeProvider.getThemeMode() == ThemeMode.light
                            ? Colors.grey.shade300
                            : Colors.blueGrey.shade900),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
