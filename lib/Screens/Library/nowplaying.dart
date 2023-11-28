//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/CustomWidgets/empty_screen.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
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
    return Container(
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
                  appBar: processingState != AudioProcessingState.idle
                      ? null
                      : AppBar(
                          title: Text(AppLocalizations.of(context)!.nowPlaying),
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                  body: processingState == AudioProcessingState.idle
                      ? emptyScreen(
                          context,
                          3,
                          AppLocalizations.of(context)!.nothingIs,
                          18.0,
                          AppLocalizations.of(context)!.playingCap,
                          60,
                          AppLocalizations.of(context)!.playSomething,
                          23.0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
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
                                    const SizedBox(height: 8,),
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
                                        const Icon(
                                          Icons.shuffle_rounded,
                                          color: Color(0XFFA7A7A7),
                                        ),
                                        const SizedBox(width: 10,),
                                        Transform.scale(
                                          scale: 1.5,
                                          child: SvgIconButton(
                                            selectedSVG:
                                                'assets/pause_round.svg',
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
          MiniPlayer(),
        ],
      ),
    );
  }
}
