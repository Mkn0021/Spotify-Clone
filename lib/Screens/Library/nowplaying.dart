//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/CustomWidgets/empty_screen.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/CustomWidgets/with_bottomNavBar.dart';
import 'package:spotify/Screens/Player/audioplayer.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithBottomNavBar(
      selectedIndex: 2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0XFF79415D),
              Colors.black,
            ],
            stops: [0.0, 0.38],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (cntx, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    body: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 25,
                              left: 15.0,
                              right: 15.0,
                              bottom: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Now Playing',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  '1 Song',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0XFFA7A7A7),
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Spacer(),
                                    const SvgIconButton(
                                      selectedSVG: 'assets/shuffle.svg',
                                      selectedColor: Color(0XFFA7A7A7),
                                      unselectedColor: Color(0XFFA7A7A7),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Transform.scale(
                                      scale: 1.5,
                                      child: SvgIconButton(
                                        selectedSVG: 'assets/play_round.svg',
                                        unselectedSVG: 'assets/pause_round.svg',
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        unselectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        iconSize: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (processingState == AudioProcessingState.idle)
                            Padding(
                              padding: const EdgeInsets.only(top: 150),
                              child: emptyScreen(
                                context,
                                3,
                                AppLocalizations.of(context)!.nothingTo,
                                15.0,
                                AppLocalizations.of(context)!.showHere,
                                50,
                                AppLocalizations.of(context)!.addSomething,
                                23.0,
                              ),
                            )
                          else
                            Expanded(
                              child: NowPlayingStream(
                                audioHandler: audioHandler,
                              ),
                            ),
                        ],
                      ),
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
