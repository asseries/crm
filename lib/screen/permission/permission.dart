// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:as_toast_x/functions.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/main/set_audio_folder_screen.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave_transition/wave_transition.dart';

import '../../main/main_screen.dart';
import '../../utils/app_colors.dart';
import '../login/login_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        vsync: this, length: 6); // This would best not to be hard coded, but I saw that you had two tabs...
    _tabController.addListener(() {
      print('my index is${_tabController.index}');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("${PrefUtils.getThemeMode()} AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    return Scaffold(
      body: DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
              ? AppColors.COLOR_PRIMARY2
              : AppColors.COLOR_PRIMARY,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                getStatusBarWidget(context),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (_tabController.index > 0) {
                              _tabController.animateTo(_tabController.index - 1);
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "6 tadan ${6 - _tabController.index} ta".toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w600,
                              color: PrefUtils.getThemeMode() == ThemeMode.light
                                  ? AppColors.COLOR_PRIMARY
                                  : AppColors.COLOR_PRIMARY2
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            width: getScreenWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: PrefUtils.getThemeMode() == ThemeMode.light
                                    ? AppColors.ACCENT
                                    : AppColors.GREY.withOpacity(.5)),
                          ),
                          Container(
                            height: 8,
                            width: getScreenWidth(context) * _tabController.index / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: PrefUtils.getThemeMode() == ThemeMode.light
                                    ? AppColors.ACCENT
                                    : AppColors.ACCENT),
                          )
                        ],
                      )
                    ],
                  ),
                )),
                // TabBar(
                //   controller: _tabController,
                //   tabs: const [Text("Lunches"), Text("Cart")],
                // ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(), //tabbar swipe disable
            children: [
              //notification
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/notify.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Bildirishnomalarni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Bu sizga kelgan bildirishnomalarni o'z vaqtida olishga yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.notification.status.isGranted ||
                          await Permission.notification.status.isPermanentlyDenied) {
                        Permission.notification.request().then((value) async => {
                              if (await Permission.notification.isGranted)
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                }
                              else
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        _tabController.animateTo(_tabController.index + 1);
                        setState(() {});
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),

              //mediaLibrary
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/movies-app.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Media kutubxonalariga ruhsatni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Bu sizga fayllar bilan ishlashga yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.mediaLibrary.status.isGranted ||
                          await Permission.mediaLibrary.status.isPermanentlyDenied) {
                        Permission.mediaLibrary.request().then((value) async => {
                              if (await Permission.mediaLibrary.isGranted)
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                }
                              else
                                {
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        _tabController.animateTo(_tabController.index + 1);
                        setState(() {});
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),

              //storage
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/folder.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Smartfon papkalariga kirish ruhsatni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Smartfon papkalari bilan ishlashga yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.storage.status.isGranted ||
                          await Permission.storage.status.isPermanentlyDenied) {
                        Permission.storage.request().then((value) async => {
                              if (await Permission.storage.isGranted)
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                }
                              else
                                {
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        _tabController.animateTo(_tabController.index + 1);
                        setState(() {});
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),

              //accessMediaLocation
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/lock.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Fayllar joylashuviga ruhsatni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Fayllar joylashuvi manzillarini olish yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.accessMediaLocation.status.isGranted ||
                          await Permission.accessMediaLocation.status.isPermanentlyDenied) {
                        Permission.accessMediaLocation.request().then((value) async => {
                              if (await Permission.accessMediaLocation.isGranted)
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                }
                              else
                                {
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        _tabController.animateTo(_tabController.index + 1);
                        setState(() {});
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),

              //phone
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/call.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Qo'ng'iroqlarga ruhsatni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Dasturdan chiqmay turib qo'ng'iroqni amalga oshirishga yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.phone.status.isGranted ||
                          await Permission.phone.status.isDenied ||
                          await Permission.phone.status.isRestricted ||
                          await Permission.phone.status.isLimited ||
                          await Permission.phone.status.isPermanentlyDenied) {
                        Permission.phone.request().then((value) async => {
                              if (await Permission.phone.isGranted)
                                {
                                  _tabController.animateTo(_tabController.index + 1),
                                  setState(() {}),
                                }
                              else
                                {
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        _tabController.animateTo(_tabController.index + 1);
                        setState(() {});
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),

              //contacts
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/3d/contacts.png",
                              width: getScreenWidth(context) / 1.3,
                            ))),
                    Text(
                      "Kontaktlar ro'yhati ruhsatni yoqish",
                      style: TextStyle(
                          fontSize: 24,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Kontakltlat ro'yhatini oshirishga yordam beradi!",
                      style: TextStyle(
                          fontSize: 16,
                          color: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.COLOR_PRIMARY2,
                          fontFamily: "p_semi"),
                    ),
                    const Expanded(flex: 1, child: Center()),
                    asButton(context,
                        backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                            ? AppColors.COLOR_PRIMARY
                            : AppColors.ACCENT,
                        height: 60,
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(12), onPressed: () async {
                      if (!await Permission.contacts.status.isGranted ||
                          await Permission.contacts.status.isPermanentlyDenied) {
                        Permission.contacts.request().then((value) async => {
                              if (await Permission.contacts.isGranted && await Permission.phone.isGranted)
                                {
                                  setState(() {}),
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    WaveTransition(
                                        child: PrefUtils.getRecFolder().isEmpty
                                            ? const SetAudioFolder()
                                            : PrefUtils.getToken().isEmpty
                                                ? const LoginScreen()
                                                : const MainScreen(),
                                        center: const FractionalOffset(0.0, 0.0),
                                        duration: const Duration(milliseconds: 1000),
                                        settings: const RouteSettings(arguments: "BDM")),
                                    (route) => false,
                                  )
                                }
                              else
                                {
                                  showWarning(context, "Ruhsat olinmagan!"),
                                }
                            });
                      } else {
                        showSuccess(context, "Ruhsat allaqachon olingan!");
                        if (await Permission.phone.isGranted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            WaveTransition(
                                child:
                                    PrefUtils.getToken().isEmpty ? const LoginScreen() : const MainScreen(),
                                center: const FractionalOffset(0.0, 0.0),
                                duration: const Duration(milliseconds: 1000),
                                settings: const RouteSettings(arguments: "BDM")),
                            (route) => false,
                          );
                        } else {
                          showWarning(context, "phone permission denied");
                          await Future.delayed(3.seconds);
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
                      }
                    },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ruhsatni yoqish".toUpperCase(),
                              style: const TextStyle(fontFamily: "p_bold"),
                            )),
                            const Icon(Icons.navigate_next_outlined)
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
