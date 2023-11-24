//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotify/Helpers/dominant_color.dart';
import 'package:spotify/Screens/Player/audioplayer.dart';

class MiniPlayer extends StatefulWidget {
  static const MiniPlayer _instance = MiniPlayer._internal();

  factory MiniPlayer() {
    return _instance;
  }

  const MiniPlayer._internal();

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();

  Future<List<Color?>?> getArtworkColors(MediaItem mediaItem) async {
    return mediaItem.artUri.toString().startsWith('file:')
        ? getColors(
            imageProvider: FileImage(File(mediaItem.artUri!.toFilePath())),
          )
        : getColors(
            imageProvider:
                CachedNetworkImageProvider(mediaItem.artUri.toString()),
          );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool rotated = screenHeight < screenWidth;

    Color compareColors(
      Color color1,
      Color color2, {
      double threshold = 0.01,
    }) {
      final double luminance1 = color1.computeLuminance();
      final double luminance2 = color2.computeLuminance();

      if (luminance1 < luminance2 && luminance1 < threshold) {
        // Color1 is darker and almost black, return color2
        return color2;
      } else if (luminance2 < luminance1 && luminance2 < threshold) {
        // Color2 is darker and almost black, return color1
        return color1;
      } else {
        // Either both colors are not almost black or only one of them is almost black,
        // return the darkest color
        return luminance1 < luminance2 ? color1 : color2;
      }
    }
    
    return SafeArea(
      top: false,
      child: StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          if (processingState == AudioProcessingState.idle) {
            return const SizedBox();
          }
          return StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const SizedBox();
              }
              final mediaItem = snapshot.data;
              if (mediaItem == null) return const SizedBox();
              return FutureBuilder<List<Color?>?>(
                future: getArtworkColors(mediaItem),
                builder: (context, snapshotColors) {
                  final List<Color> artworkColors = (snapshotColors.data ??
                          [const Color(0xFF262626), const Color(0xFF202020)])
                      .where((color) => color != null)
                      .cast<Color>()
                      .toList();
                  return Dismissible(
                    key: const Key('miniplayer'),
                    direction: DismissDirection.down,
                    onDismissed: (_) {
                      Feedback.forLongPress(context);
                      audioHandler.stop();
                    },
                    child: Dismissible(
                      key: Key(mediaItem.id),
                      confirmDismiss: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          audioHandler.skipToPrevious();
                        } else {
                          audioHandler.skipToNext();
                        }
                        return Future.value(false);
                      },
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('settings').listenable(),
                        child: StreamBuilder<Duration>(
                          stream: AudioService.position,
                          builder: (context, snapshot) {
                            final position = snapshot.data;
                            return position == null
                                ? const SizedBox()
                                : (position.inSeconds.toDouble() < 0.0 ||
                                        (position.inSeconds.toDouble() >
                                            mediaItem.duration!.inSeconds
                                                .toDouble()))
                                    ? const SizedBox()
                                    : SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.white,
                                          inactiveTrackColor:
                                              const Color(0xFF3E3E3E),
                                          trackHeight: 0.5,
                                          thumbColor: Colors.white,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                            enabledThumbRadius: 1.0,
                                          ),
                                          overlayColor: Colors.transparent,
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                            overlayRadius: 2.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Slider(
                                            inactiveColor: Colors.transparent,
                                            // activeColor: Colors.white,
                                            value:
                                                position.inSeconds.toDouble(),
                                            max: mediaItem.duration!.inSeconds
                                                .toDouble(),
                                            onChanged: (newPosition) {
                                              audioHandler.seek(
                                                Duration(
                                                  seconds: newPosition.round(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                          },
                        ),
                        builder:
                            (BuildContext context, Box box1, Widget? child) {
                          final bool useDense = box1.get(
                                'useDenseMini',
                                defaultValue: false,
                              ) as bool ||
                              rotated;
                          final List preferredMiniButtons =
                              Hive.box('settings').get(
                            'preferredMiniButtons',
                            defaultValue: ['Like', 'Play/Pause', 'Next'],
                          )?.toList() as List;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical: 1.0,
                            ),
                            elevation: 0,
                            child: SizedBox(
                              height: useDense ? 68.0 : 76.0,
                              child: ColoredBox(
                                color: compareColors(
                                    artworkColors[1], artworkColors[0],),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      dense: useDense,
                                      onTap: () {
                                        Navigator.pushNamed(context, '/player');
                                      },
                                      title: Text(
                                        mediaItem.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        mediaItem.artist ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: Hero(
                                        tag: 'currentArtwork',
                                        child: Card(
                                          elevation: 8,
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: (mediaItem.artUri
                                                  .toString()
                                                  .startsWith('file:'))
                                              ? SizedBox.square(
                                                  dimension:
                                                      useDense ? 40.0 : 50.0,
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                      File(
                                                        mediaItem.artUri!
                                                            .toFilePath(),
                                                      ),
                                                    ),
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Image(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          'assets/cover.jpg',
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : SizedBox.square(
                                                  dimension:
                                                      useDense ? 40.0 : 50.0,
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    errorWidget: (
                                                      BuildContext context,
                                                      _,
                                                      __,
                                                    ) =>
                                                        const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/cover.jpg',
                                                      ),
                                                    ),
                                                    placeholder: (
                                                      BuildContext context,
                                                      _,
                                                    ) =>
                                                        const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/cover.jpg',
                                                      ),
                                                    ),
                                                    imageUrl: mediaItem.artUri
                                                        .toString(),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      trailing: ControlButtons(
                                        audioHandler,
                                        miniplayer: true,
                                        buttons: mediaItem.artUri
                                                .toString()
                                                .startsWith('file:')
                                            ? ['Like', 'Play/Pause', 'Next']
                                            : preferredMiniButtons,
                                      ),
                                    ),
                                    child!,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
