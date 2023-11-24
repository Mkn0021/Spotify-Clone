//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spotify/CustomWidgets/bottom_nav_bar.dart';
import 'package:spotify/CustomWidgets/custom_physics.dart';
import 'package:spotify/CustomWidgets/greetings.dart';
import 'package:spotify/CustomWidgets/icon_button_widget.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/Home/saavn.dart';
import 'package:spotify/Screens/Library/library.dart';
import 'package:spotify/Screens/Search/search_page.dart';
import 'package:spotify/Screens/Settings/settings_page.dart';
import 'package:spotify/Screens/YouTube/youtube_home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  DateTime? backButtonPressTime;
  //visibility
  bool showMusicContainer = false;
  bool showPodcastsContainer = false;

  void callback() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
    _pageController.jumpToPage(
      index,
    );
  }

  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        context,
        AppLocalizations.of(context)!.exitConfirm,
        duration: const Duration(seconds: 2),
        noAction: true,
      );
      return false;
    }
    return true;
  }

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            WillPopScope(
              onWillPop: () => handleWillPop(context),
              child: SafeArea(
                child: Row(
                  children: [
                    if (rotated)
                      ValueListenableBuilder(
                        valueListenable: _selectedIndex,
                        builder: (
                          BuildContext context,
                          int indexValue,
                          Widget? child,
                        ) {
                          return NavigationRail(
                            minWidth: 70.0,
                            groupAlignment: 0.0,
                            backgroundColor: Colors.transparent,
                            selectedIndex: indexValue,
                            onDestinationSelected: (int index) {
                              _onItemTapped(index);
                            },
                            labelType: screenWidth > 1050
                                ? NavigationRailLabelType.selected
                                : NavigationRailLabelType.none,
                            selectedLabelTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelTextStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                            ),
                            selectedIconTheme:
                                Theme.of(context).iconTheme.copyWith(
                                      color: Colors.white,
                                    ),
                            unselectedIconTheme: Theme.of(context).iconTheme,
                            useIndicator: screenWidth < 1050,
                            indicatorColor: Colors.transparent,
                            destinations: [
                              NavigationRailDestination(
                                icon: BottomNavBarIcon(
                                  selectedIcon: 'assets/home_fill.svg',
                                  unselectedIcon: 'assets/home_outline.svg',
                                  indexChecker: indexValue == 0,
                                ),
                                label: const Text('Home'),
                              ),
                              NavigationRailDestination(
                                icon: BottomNavBarIcon(
                                  selectedIcon: 'assets/search_fill.svg',
                                  unselectedIcon: 'assets/search_outline.svg',
                                  indexChecker: indexValue == 1,
                                ),
                                label: const Text('Search'),
                              ),
                              NavigationRailDestination(
                                icon: BottomNavBarIcon(
                                  selectedIcon: 'assets/library_fill.svg',
                                  unselectedIcon: 'assets/library_outline.svg',
                                  indexChecker: indexValue == 2,
                                ),
                                label: const Text('Your Library'),
                              ),
                              NavigationRailDestination(
                                icon: BottomNavBarIcon(
                                  selectedIcon: 'assets/yt_music_fill.svg',
                                  unselectedIcon: 'assets/yt_music_outline.svg',
                                  indexChecker: indexValue == 3,
                                ),
                                label: const Text('YT Music'),
                              ),
                            ],
                          );
                        },
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView(
                              physics: const CustomPhysics(),
                              onPageChanged: (indx) {
                                _selectedIndex.value = indx;
                              },
                              controller: _pageController,
                              children: [
                                Stack(
                                  children: [
                                    NestedScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      controller: _scrollController,
                                      headerSliverBuilder: (
                                        BuildContext context,
                                        bool innerBoxScrolled,
                                      ) {
                                        return <Widget>[
                                          SliverToBoxAdapter(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.black,
                                                    Colors.transparent,
                                                  ],
                                                  stops: [
                                                    0.0,
                                                    0.30,
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 30,
                                                  left: 22,
                                                  right: 16,
                                                  bottom: 30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    GreetingsManager
                                                        .getGreetingsText(),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    const SvgIconButton(
                                                      selectedSVG:
                                                          'assets/notification_on.svg',
                                                      unselectedSVG:
                                                          'assets/notification_off.svg',
                                                      iconSize: 20.0,
                                                    ),
                                                    IconButtonWidget(
                                                      icon: const Icon(
                                                          Icons.history,),
                                                      onTap: () {
                                                        // Open the RecentlyPlayed here
                                                        Navigator.pushNamed(context, '/recent');
                                                          
                                                      },
                                                    ),
                                                    SvgIconButton(
                                                      selectedSVG:
                                                          'assets/settings.svg',
                                                      unselectedColor:
                                                          Colors.white,
                                                      onTap: () {
                                                        // Open the NewSettingsPage here
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewSettingsPage(
                                                              callback:
                                                                  callback,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SliverAppBar(
                                            backgroundColor: Colors.black,
                                            expandedHeight: 30,
                                            floating: true,
                                            pinned: true,
                                            elevation: 0,
                                            flexibleSpace: FlexibleSpaceBar(
                                              titlePadding:
                                                  const EdgeInsets.only(
                                                left: 16,
                                              ),
                                              title: Row(
                                                children: [
                                                  Visibility(
                                                    visible:
                                                        showPodcastsContainer ||
                                                            showMusicContainer,
                                                    child: Transform.translate(
                                                      offset:
                                                          const Offset(0, -6.2),
                                                      child: SvgIconButton(
                                                        selectedSVG:
                                                            'assets/plus.svg',
                                                        unselectedColor:
                                                            Colors.white,
                                                        angle: 45,
                                                        onTap: () {
                                                          setState(() {
                                                            showPodcastsContainer =
                                                                false;
                                                            showMusicContainer =
                                                                false;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),

                                                  Visibility(
                                                    visible:
                                                        !showPodcastsContainer,
                                                    child: CustomContainer(
                                                      text: 'Music',
                                                      stateCheck:
                                                          showMusicContainer,
                                                      onTap: () {
                                                        setState(() {
                                                          showMusicContainer =
                                                              !showMusicContainer;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        !showMusicContainer,
                                                    child: CustomContainer(
                                                      text: 'Podcasts & Shows',
                                                      stateCheck:
                                                          showPodcastsContainer,
                                                      onTap: () {
                                                        setState(() {
                                                          showPodcastsContainer =
                                                              !showPodcastsContainer;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      body: SaavnHomePage(),
                                    ),
                                    Positioned(
                                      bottom: rotated ? 0.0 : 70.0,
                                      left: rotated ? screenWidth / 2 : 2.0,
                                      right: 2.0,
                                      child: MiniPlayer(),
                                    ),
                                  ],
                                ),
                                const SearchPageScreen(),
                                const LibraryPage(),
                                const YouTube(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //bottom Navigationbar
            if (!rotated)
              Positioned(
                bottom: 0,
                child: ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder:
                      (BuildContext context, int indexValue, Widget? child) {
                    return Container(
                      height: 70,
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
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: BottomNavBarIcon(
                              selectedIcon: 'assets/home_fill.svg',
                              unselectedIcon: 'assets/home_outline.svg',
                              indexChecker: indexValue == 0,
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: BottomNavBarIcon(
                              selectedIcon: 'assets/search_fill.svg',
                              unselectedIcon: 'assets/search_outline.svg',
                              indexChecker: indexValue == 1,
                            ),
                            label: 'Search',
                          ),
                          BottomNavigationBarItem(
                            icon: BottomNavBarIcon(
                              selectedIcon: 'assets/library_fill.svg',
                              unselectedIcon: 'assets/library_outline.svg',
                              indexChecker: indexValue == 2,
                            ),
                            label: 'Your Library',
                          ),
                          BottomNavigationBarItem(
                            icon: BottomNavBarIcon(
                              selectedIcon: 'assets/yt_music_fill.svg',
                              unselectedIcon: 'assets/yt_music_outline.svg',
                              indexChecker: indexValue == 3,
                            ),
                            label: 'YT Music',
                          ),
                        ],
                        currentIndex: indexValue,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: const Color(0xFFB3B3B3),
                        selectedFontSize: 10,
                        unselectedFontSize: 10,
                        backgroundColor: Colors.transparent,
                        onTap: _onItemTapped,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
