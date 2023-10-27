// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:as_toast_x/functions.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/screen/records/records_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/pref_utils.dart';
import '../../utils/utils.dart';
import '../sync_screen/sync_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen>  {
  final service = FlutterBackgroundService();
  bool isRunning = false;
  Directory? selectedDirectory;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final service = FlutterBackgroundService();
      // isRunning = await service.isRunning();

      var status = await Permission.manageExternalStorage.status;
      if (status.isRestricted) {
        status = await Permission.manageExternalStorage.request();
      }

      if (status.isDenied) {
        status = await Permission.manageExternalStorage.request();
      }
      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Please add permission for app to manage external storage'),
        ));
      }
    });

    super.initState();
  }

  _calling(String phone) async {
    // String url = "tel:$phone";
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getStatusBarWidget(context),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.maxFinite,
              height: 56,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
              ]),
              child: Row(
                children: [
                  InkResponse(
                    onTap: () {
                      vibrateLight();
                      finish(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "Sozlamalar",
                    style: TextStyle(fontSize: 18, fontFamily: "p_bold"),
                  )
                ],
              ),
            ),
            // Container(width: getScreenWidth(context),height: 1,color: Colors.grey.withOpacity(.1),),
            InkWell(
              onTap: () async {
                vibrateLight();
                if(PrefUtils.getRecFolder().isEmpty){
                  showWarning(context, "Iltimos avval yozuvlar papkasini tanlang");
                  await Future.delayed(3.seconds);
                  await MyApp.openFolder(context);
                  setState(() {

                  });
                }else{
                  startScreen(context, screen: const SyncScreen());
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            Container(
              width: getScreenWidth(context),
              height: 1,
              color: Colors.grey.withOpacity(.1),
            ),
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
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                          CupertinoIcons.moon_stars_fill,
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
            Container(
              width: getScreenWidth(context),
              height: 1,
              color: Colors.grey.withOpacity(.1),
            ),
            InkWell(
              onTap: () async {
                vibrateLight();
                isRunning = await service.isRunning();
                if (isRunning) {
                  service.invoke("stopService");
                } else {
                  service.startService();
                }
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeProvider.getThemeMode() == ThemeMode.light
                        ? Colors.grey.shade300
                        : Colors.blueGrey.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            !isRunning
                                ? CupertinoIcons.waveform_path_ecg
                                : CupertinoIcons.waveform_path_badge_minus,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              isRunning ? "Servisni ishga tushurish" : "Servisni to'xtatish",
                              style: asTextStyle(
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: getScreenWidth(context),
              height: 1,
              color: Colors.grey.withOpacity(.1),
            ),
            InkWell(
              onTap: () async {
                vibrateLight();
                await MyApp.openFolder(context);
                setState(() {

                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeProvider.getThemeMode() == ThemeMode.light
                        ? Colors.grey.shade300
                        : Colors.blueGrey.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            PrefUtils.getRecFolder().isEmpty
                                ? Icons.folder_off_outlined
                                : CupertinoIcons.folder_solid,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              PrefUtils.getRecFolder().isEmpty ? "(Bo'sh)" : PrefUtils.getRecFolder(),
                              style: asTextStyle(
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            // Container(width: getScreenWidth(context),height: 1,color: Colors.grey.withOpacity(.1),),
            Container(
              width: getScreenWidth(context),
              height: 1,
              color: Colors.grey.withOpacity(.1),
            ),
            InkWell(
              onTap: () async {
                if (PrefUtils.getRecFolder().isEmpty) {
                  showWarning(context, "Iltimos avval yozuvlar papkasini tanlang");
                  await Future.delayed(3.seconds);
                  await MyApp.openFolder(context);
                  setState(() {

                  });
                  return;
                }
                startScreen(context, screen: const RecordsScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeProvider.getThemeMode() == ThemeMode.light
                        ? Colors.grey.shade300
                        : Colors.blueGrey.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.music_albums,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Yozuvlar",
                              style: asTextStyle(
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: getScreenWidth(context),
              height: 1,
              color: Colors.grey.withOpacity(.1),
            ),
            // InkWell(
            //   onTap: () async {
            //       startScreen(context, screen: SavedStatesScreen());
            //       },
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //     margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: themeProvider.getThemeMode() == ThemeMode.light
            //             ? Colors.grey.shade300
            //             : Colors.blueGrey.shade900),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //           child: Row(
            //             children: [
            //               const Icon(
            //                 CupertinoIcons.timer_fill,
            //                 size: 16,
            //               ),
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //               Expanded(
            //                 child: Text(
            //                   "Jo'natilmagan yozuvlar arxivi",
            //                   style: asTextStyle(
            //                     size: 14,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //         const Icon(
            //           Icons.arrow_forward_ios_rounded,
            //           size: 14,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
