import 'dart:async';
import 'dart:io';

import 'package:crm/providers/contact_provider.dart';
import 'package:crm/providers/filter_provider.dart';
import 'package:crm/providers/theme_provider.dart';
import 'package:crm/service/b_service.dart';
import 'package:crm/utils/local_notification.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:crm/utils/utils.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'main/splash.dart';
import 'model/state_model.dart';

import 'package:alice/alice.dart';

Future<void> main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //     statusBarColor: AppColors.COLOR_PRIMARY, /* set Status bar color in Android devices. */
  //     statusBarIconBrightness: Brightness.light,
  //     statusBarBrightness: Brightness
  //         .dark) /* set Status bar icon color in iOS. */
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StateModelAdapter());
  await PrefUtils.initInstance();
  LocalNotification.initialize();
  initializeDateFormatting();
  EventBus(sync: true);
  await initializeService(); //  background services
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static const platform = MethodChannel('asser/channel');
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // static Alice alice = Alice(
  //   showNotification: true,
  //   showInspectorOnShake: true,
  // );

  static Future<void> openFolder(BuildContext context) async {
    Directory? directory = Directory(FolderPicker.rootPath);

    Directory? newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))));
    if (newDirectory != null) PrefUtils.setRecFolder("${newDirectory.path}/");
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  Offset _offset = Offset.zero;

  @override
  void initState() {
    initializeDateFormatting("uz", "uz");
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // navigatorKey: MyApp.alice.getNavigatorKey(),
        title: 'BDM',
        home: const Splash(),
        builder: (context, child) {
          if (_offset.dx == 0) {
            _offset = Offset(getScreenWidth(context) * .8, getScreenHeight(context) * .85);
          }
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Stack(
                children: [
                  child!,
                  // Positioned(
                  //   left: _offset.dx,
                  //   top: _offset.dy,
                  //   child: GestureDetector(
                  //     onPanUpdate: (d) => setState(() => _offset += Offset(d.delta.dx, d.delta.dy)),
                  //     child: FloatingActionButton(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(56),
                  //       ),
                  //       onPressed: () {
                  //         MyApp.alice.showInspector();
                  //       },
                  //       backgroundColor: Colors.white.withOpacity(.5),
                  //       child: const Icon(Icons.http, color: Colors.green, size: 32),
                  //     ),
                  //   ),
                  // ),
                ],
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
