//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole) 

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spotify/Screens/About/about.dart';
import 'package:spotify/Screens/Home/home.dart';
import 'package:spotify/Screens/Library/downloads.dart';
import 'package:spotify/Screens/Library/nowplaying.dart';
import 'package:spotify/Screens/Library/playlists.dart';
import 'package:spotify/Screens/Library/recent.dart';
import 'package:spotify/Screens/Library/stats.dart';
import 'package:spotify/Screens/Login/auth.dart';
import 'package:spotify/Screens/Login/pref.dart';
import 'package:spotify/Screens/Settings/new_settings_page.dart';

Widget initialFuntion() {
  return Hive.box('settings').get('userId') != null ? HomePage() : AuthScreen();
}

final Map<String, Widget Function(BuildContext)> namedRoutes = {
  '/': (context) => initialFuntion(),
  '/pref': (context) => const PrefScreen(),
  '/setting': (context) => const NewSettingsPage(),
  '/about': (context) => AboutScreen(),
  '/playlists': (context) => PlaylistScreen(),
  '/nowplaying': (context) => NowPlaying(),
  '/recent': (context) => RecentlyPlayed(),
  '/downloads': (context) => const Downloads(),
  '/stats': (context) => const Stats(),
};
