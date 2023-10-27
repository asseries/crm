import 'dart:async';

import 'package:blured_navigation_bar_x/blured_nav_bar_x_item.dart';
import 'package:blured_navigation_bar_x/blured_navigation_bar_x.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/providers/contact_provider.dart';
import 'package:crm/screen/call_log/call_log.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/view/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

import '../model/contact_model.dart';
import '../providers/theme_provider.dart';
import '../screen/contact/contacts_screen.dart';
import '../screen/dial/dial.dart';
import '../screen/favorite/favorite.dart';
import '../utils/pref_utils.dart';

List<Widget> screens = [
  const Dial(),
  const CallLogScreen(),
  const FavoriteScreen(),
  const ContactsScreen(),
];


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  List<Contact> contacts = [];
  List<ContactModel> myContacts = [];
  int _index = 0;
  StreamSubscription? busEventListener;
  PhoneStateStatus status = PhoneStateStatus.NOTHING;



  Future<void> _checkPermissions() async {
    if (!await Permission.contacts.status.isGranted || await Permission.contacts.status.isPermanentlyDenied) {
      Permission.contacts.request().then((value) async => {});
    } else {}
  }

  void setLastDate() {
    // PrefUtils.setLastDate(0);
    // PrefUtils.clearCallState();
    if (PrefUtils.getLastDate() == 0) {
      PrefUtils.setLastDate((DateTime.now().add(-19.minutes).millisecondsSinceEpoch / 1000).round());
    }
  }

  @override
  void initState() {
    super.initState();
    setLastDate();
    _checkPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await AndroidAlarmManager.oneShot(
      //   const Duration(seconds: 5),
      //   1234,
      //   runTicker,
      //   exact: true,
      //   wakeup: true,
      // );
      // print("AUDIO :${(await getAudioDuration(audioList[0].fullPath)/1000).ceil()} ${audioList[0].date}");
      // print("CALL LOG: ${callLogList[0].duration}  ${callLogList[0].timestamp}");
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("$state APPLIFECYCLE STATE");
    // Provider.of<ContactProvider>(context).getContactList();
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor:
                themeProvider.getThemeMode() == ThemeMode.dark ? AppColors.COLOR_PRIMARY : AppColors.WHITE,
            statusBarIconBrightness:
                themeProvider.getThemeMode() == ThemeMode.dark ? Brightness.light : Brightness.dark,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness: themeProvider.getThemeMode() == ThemeMode.dark
                ? Brightness.light
                : Brightness.dark) /* set Status bar icon color in iOS. */
        );

    return MaterialApp(
      theme:
          themeProvider.getThemeMode() == ThemeMode.dark ? themeProvider.darkTheme : themeProvider.lightTheme,
      themeMode: PrefUtils.getThemeMode(),
      darkTheme:
          themeProvider.getThemeMode() == ThemeMode.dark ? themeProvider.darkTheme : themeProvider.lightTheme,
      home: Scaffold(
        drawer: const DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: screens[_index],
        extendBody: true,
        bottomNavigationBar: BluredNavigationBarX(
          currentIndex: _index,
          labelStatus: LabelStatus.showSelected,
          backgroundColor: Colors.black87.withOpacity(.2),
          browColor:
              themeProvider.getThemeMode() == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
          border: Border.all(
            width: .2,
            color: themeProvider.getThemeMode() == ThemeMode.light
                ? AppColors.BLACK.withOpacity(.5)
                : AppColors.BLACK.withOpacity(.5),
          ),
          unselectedItemColor: themeProvider.getThemeMode() == ThemeMode.light
              ? AppColors.COLOR_PRIMARY2
              : AppColors.COLOR_PRIMARY2,
          selectedItemColor:
              themeProvider.getThemeMode() == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
          items: [
            BluredNavBarXItem(icon: Icons.dialpad_rounded, title: "Terish oynasi"),
            BluredNavBarXItem(icon: Icons.local_phone, title: "Qo'ng'iroqlar"),
            BluredNavBarXItem(icon: Icons.star_rounded, title: 'Saralangan'),
            BluredNavBarXItem(icon: Icons.contact_page_rounded, title: 'Kontaktlar'),
          ],
          onPressed: (int v) {
            setState(() {
              _index = v;
            });
            Provider.of<ContactProvider>(context,listen: false).displayText = "";
            Provider.of<ContactProvider>(context,listen: false).loadContacts();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    busEventListener?.cancel();
    super.dispose();
  }
}
