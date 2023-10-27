// ignore_for_file: use_build_context_synchronously

import 'package:crm/main/splash.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave_transition/wave_transition.dart';

import '../providers/contact_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/utils.dart';

class SetIpScreen extends StatefulWidget {
  const SetIpScreen({Key? key}) : super(key: key);

  @override
  State<SetIpScreen> createState() => _SetIpScreenState();
}

class _SetIpScreenState extends State<SetIpScreen> {
  var ipController = TextEditingController();

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: Center()),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/3d/drive.png",
                width: getScreenWidth(context) / 2.5,
              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Ip va portni kiriting:",
                style: TextStyle(
                  color: themeProvider.getThemeMode() == ThemeMode.dark
                      ? Colors.grey.shade300
                      : Colors.blueGrey.shade900,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: asTextField(
                context,
                borderVisibility: false,
                hintText: "194.113.153.92:63022",
                controller: ipController,
                textInputType: TextInputType.multiline,
                textStyle: TextStyle(
                    color: themeProvider.getThemeMode() == ThemeMode.dark
                        ? Colors.grey.shade300
                        : Colors.blueGrey.shade900,
                    fontSize: 16
                ),
                hintStyle: TextStyle(
                  color: themeProvider.getThemeMode() == ThemeMode.dark
                      ? Colors.grey.withOpacity(.2)
                      : Colors.blueGrey.withOpacity(.2),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Expanded(child: Center()),
            asButton(context, width: 400, onPressed: () {
              PrefUtils.setIp(ipController.text);
              Navigator.pushAndRemoveUntil(
                context,
                WaveTransition(
                    child: const Splash(),
                    center: const FractionalOffset(0.0, 0.0),
                    duration: const Duration(milliseconds: 1000),
                    settings: const RouteSettings(arguments: "BDM")),
                (route) => false,
              );
            },
                child: const Text(
                  "Saqlash",
                  style: TextStyle(fontFamily: "p_semi"),
                )),
            const SizedBox(
              height: 32,
            ),
          ],
        ));
  }
}
