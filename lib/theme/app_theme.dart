//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/Helpers/config.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static MyTheme get currentTheme => GetIt.I<MyTheme>();
  static ThemeMode get themeMode => GetIt.I<MyTheme>().currentTheme();

  static ThemeData lightTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Color(0xFF1DB954),
        cursorColor: Color(0xFF1DB954),
        selectionColor: Color(0xFF1DB954),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Color(0xFF1DB954)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1DB954),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: AppTheme.themeMode == ThemeMode.system
              ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark
              : AppTheme.themeMode == ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      disabledColor: Colors.grey[600],
      brightness: Brightness.light,
      indicatorColor: const Color(0xFF1DB954),
      progressIndicatorTheme: const ProgressIndicatorThemeData()
          .copyWith(color: const Color(0xFF1DB954)),
      iconTheme: IconThemeData(
        color: Colors.grey[800],
        opacity: 1.0,
        size: 24.0,
      ),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.grey[800],
            brightness: Brightness.light,
            secondary: const Color(0xFF1DB954),
          ),
    );
  }

  static ThemeData darkTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Color(0xFF18AC4D),
        cursorColor: Color(0xFF1ED760),
        selectionColor: Color(0XFF1A502D),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.transparent),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xffe7e7e7),
          fontSize: 16,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xffa7a7a7),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: currentTheme.getCanvasColor(),
        foregroundColor: Colors.white,
      ),
      canvasColor: currentTheme.getCanvasColor(),
      cardColor: currentTheme.getCardColor(),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      dialogBackgroundColor: currentTheme.getCardColor(),
      progressIndicatorTheme: const ProgressIndicatorThemeData()
          .copyWith(color: const Color(0xFF1ED760)),
      iconTheme: const IconThemeData(
        color: Colors.white,
        opacity: 1.0,
        size: 24.0,
      ),
      indicatorColor: const Color(0xFF1ED760),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color(0xff121212),
            secondary: const Color(0xFF1ED760),
            brightness: Brightness.dark,
          ),
    );
  }
}
