// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:spotify/CustomWidgets/bottom_nav_bar.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';

class WithBottomNavBar extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const WithBottomNavBar({
    required this.child,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bool rotated =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          child: child,
        ),
        if (!rotated)
          Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(145, 0, 0, 0),
                    Color.fromARGB(90, 0, 0, 0),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.3, 0.6, 0.75, 1.0],
                ),
              ),
              padding: const EdgeInsets.only(
                left: 15,
                top: 5,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/home_fill.svg',
                      unselectedIcon: 'assets/home_outline.svg',
                      indexChecker: selectedIndex == 0,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/search_fill.svg',
                      unselectedIcon: 'assets/search_outline.svg',
                      indexChecker: selectedIndex == 1,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/library_fill.svg',
                      unselectedIcon: 'assets/library_outline.svg',
                      indexChecker: selectedIndex == 2,
                    ),
                    label: 'Your Library',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/yt_music_fill.svg',
                      unselectedIcon: 'assets/yt_music_outline.svg',
                      indexChecker: selectedIndex == 3,
                    ),
                    label: 'YT Music',
                  ),
                ],
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color(0xFFB3B3B3),
                selectedFontSize: 10,
                unselectedFontSize: 10,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        Positioned(
          bottom: rotated ? 0.0 : 70.0,
          left: 2.0,
          right: 2.0,
          child: MiniPlayer(),
        ),
      ],
    );
  }
}
