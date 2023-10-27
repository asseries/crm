import 'package:as_toast_x/extensions.dart';
import 'package:as_toast_x/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../main/splash.dart';
import '../providers/theme_provider.dart';
import '../screen/report/report_screen.dart';
import '../screen/setting/setting.dart';
import '../screen/sync_screen/sync_screen.dart';
import '../utils/app_colors.dart';
import '../utils/pref_utils.dart';
import '../utils/utils.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
        width: getScreenWidth(context),
        backgroundColor: AppColors.TRANSPARENT,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: getScreenWidth(context) * 0.8,
                height: getScreenHeight(context) * .8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: themeProvider.getThemeMode() == ThemeMode.light
                      ? Colors.grey.shade100.withOpacity(.7)
                      : Colors.blueGrey.shade800.withOpacity(.7),
                ),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 41),
                child: Column(
                  children: [
                    getStatusBarWidget(context),
                    Container(
                      width: getScreenWidth(context),
                      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: themeProvider.getThemeMode() == ThemeMode.light
                              ? Colors.grey.shade300
                              : Colors.blueGrey.shade900),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    "assets/images/phone.png",
                                    width: 37,
                                    height: 37,
                                    color: themeProvider.getThemeMode() != ThemeMode.light
                                        ? Colors.grey.shade300
                                        : Colors.blueGrey.shade900,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PrefUtils.getUser()?.fullname ?? "Noma'lum",
                                      style: asTextStyle(
                                          fontFamily: "bold", size: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      PrefUtils.getUser()?.phone ?? "Noma'lum",
                                    )
                                  ],
                                )
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 21),
                            //   child: Image.asset(
                            //     "assets/images/logo.png",
                            //     height: 60,
                            //     width: 60,
                            //     color: themeProvider.getThemeMode() != ThemeMode.light
                            //         ? Colors.grey.shade300
                            //         : Colors.blueGrey.shade900,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    //theme
                    InkWell(
                      onTap: () {
                        vibrateLight();
                        ThemeMode? themeMode;
                        if (themeProvider.getThemeMode() == ThemeMode.light) {
                          themeMode = ThemeMode.dark;
                        } else if (themeProvider.getThemeMode() == ThemeMode.dark) {
                          themeMode = ThemeMode.light;
                        } else {
                          themeMode = ThemeMode.dark;
                        }
                        themeProvider.setThemeMode(themeMode);
                        PrefUtils.setThemeMode(themeMode);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  themeProvider.getThemeMode() == ThemeMode.dark
                                      ? CupertinoIcons.sun_min
                                      : CupertinoIcons.moon_stars,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  themeProvider.getThemeMode() == ThemeMode.light ? "Tun" : "Kun",
                                  style: asTextStyle(size: 14, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //sync
                    InkWell(
                      onTap: () async {
                        vibrateLight();
                        if (PrefUtils.getRecFolder().isEmpty) {
                          showWarning(context, "Iltimos avval yozuvlar papkasini tanlang");
                          await Future.delayed(3.seconds);
                          MyApp.openFolder(context);
                        } else {
                          startScreen(context, screen: const SyncScreen());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.sync,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Majburiy sinxronizatsiya",
                                  style: asTextStyle(size: 14, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //setting
                    InkWell(
                      onTap: () {
                        startScreen(context, screen: const SettingsScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.settings,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Sozlamalar",
                                  style: asTextStyle(size: 14, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //reports
                    InkWell(
                      onTap: () {
                        startScreen(context, screen: const ReportScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.chart_bar_square,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Hosobotlar",
                                  style: asTextStyle(size: 14, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //CHIQISH
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  finish(context);
                                },
                                child: Center(
                                  child: Container(

                                    decoration: BoxDecoration(
                                        color: themeProvider.getThemeMode() != ThemeMode.dark
                                            ? Colors.grey.shade300
                                            : Colors.blueGrey.shade900,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.all(16),
                                    width: getScreenWidth(context),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 8,),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/3d/sad.png",
                                              width: getScreenWidth(context) / 3,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Ishonchingiz komilmi?",
                                          style: TextStyle(fontFamily: "p_semi",
                                            color: themeProvider.getThemeMode() != ThemeMode.light
                                              ? Colors.grey.shade300
                                              : Colors.blueGrey.shade900,),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    PrefUtils.clearAll();
                                                    finish(context);
                                                    startScreen(context, screen: const Splash());
                                                  },
                                                  child: Text(
                                                    "Xa",
                                                    style: TextStyle(fontFamily: "p_semi", color: AppColors.ACCENT),
                                                  )),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    finish(context);
                                                  },
                                                  child: const Text(
                                                    "Yo'q",
                                                    style:
                                                        TextStyle(fontFamily: "p_semi", color: Colors.grey),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.getThemeMode() == ThemeMode.light
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Chiqish",
                                  style: asTextStyle(size: 14, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: isLandscape(context) ? getScreenWidth(context) * .81 : getScreenWidth(context) * .822,
              top: 64,
              child: InkWell(
                onTap: () {
                  finish(context);
                },
                child: Container(
                  width: 48,
                  height: 40,
                  decoration: BoxDecoration(
                      color: themeProvider.getThemeMode() == ThemeMode.light
                          ? Colors.grey.shade300.withOpacity(.9)
                          : Colors.blueGrey.shade900,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(36), bottomRight: Radius.circular(36))),
                  child: const Icon(
                    Icons.clear,
                    size: 16,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
