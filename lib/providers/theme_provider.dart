import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  void setThemeMode(ThemeMode themeMode) {
    PrefUtils.setThemeMode(themeMode);
    print(themeMode.toString());
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return PrefUtils.getThemeMode() ?? ThemeMode.dark;
  }

  ThemeMode _systemTheme = ThemeMode.system;

  ThemeData get lightTheme => _lightTheme;

  ThemeData get darkTheme => _darkTheme;

  final ThemeData _lightTheme = ThemeData.light().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    shadowColor: Colors.black.withOpacity(.001),
    textTheme: ThemeData.light()
        .textTheme
        .apply(
          fontFamily: "p_med",
        )
        .copyWith(
          bodyLarge: const TextStyle(color: Colors.indigoAccent),
          bodyMedium: TextStyle(color: Colors.blueGrey.shade800),
          //oddiy text color
          bodySmall: const TextStyle(color: Colors.green),
          headlineLarge: const TextStyle(color: Colors.blue),

          titleLarge: const TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.w700),
          labelMedium: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
            height: 1.1,
            fontFamily: "p_med",
          ),
          labelSmall: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontFamily: "p_med",
          ),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: Colors.orange[600],
        ),
    iconTheme: const IconThemeData(color: Color(0xFF263238)),
    primaryColor: Colors.orange[600],
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme:
        ThemeData.light().bottomNavigationBarTheme.copyWith(backgroundColor: Colors.white, elevation: 0),
    cardColor: const Color.fromARGB(255, 241, 241, 241),
    hoverColor: const Color(0xFFFFE6E6),
    dividerColor: Colors.black12,
    secondaryHeaderColor: Colors.black38,
  );

  //
  //
  //

  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    shadowColor: Colors.black.withOpacity(.001),
    textTheme: ThemeData.dark()
        .textTheme
        .apply(
          fontFamily: "p_med",
        )
        .copyWith(
          bodyLarge: const TextStyle(color: Colors.indigoAccent),
          bodyMedium: TextStyle(color: Colors.grey.shade300),
          //oddiy text color
          bodySmall: const TextStyle(color: Colors.green),
          headlineLarge: const TextStyle(color: Colors.blue),

          // headlineSmall:
          // TextStyle(color: Colors.pink),

          titleLarge: const TextStyle(
            fontSize: 40,
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontFamily: "p_med",
          ),
          labelMedium: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
            color: Colors.green,
            height: 1.1,
            fontFamily: "p_med",
          ),
          labelSmall: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
            fontFamily: "p_med",
          ),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,

    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.orange[600],
        ),
    iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
    primaryColor: Colors.orange[600],
    scaffoldBackgroundColor: Colors.blueGrey.shade900,
    //const Color.fromARGB(255, 31, 41, 49),
    bottomNavigationBarTheme: ThemeData.dark()
        .bottomNavigationBarTheme
        .copyWith(backgroundColor: const Color.fromARGB(255, 24, 24, 24), elevation: 0),
    cardColor: const Color.fromARGB(255, 46, 46, 46),
    hoverColor: const Color.fromARGB(255, 122, 5, 5),
    dividerColor: Colors.white12,
    secondaryHeaderColor: Colors.white30,
  );
}
