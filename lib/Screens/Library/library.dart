// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/Library/liked.dart';
import 'package:spotify/Screens/LocalMusic/downed_songs.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with AutomaticKeepAliveClientMixin {
  late ValueNotifier<bool> showDownloadedContentNotifier;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    showDownloadedContentNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool rotated = MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.black,
                toolbarHeight: 140,
                expandedHeight: 140,
                pinned: true,
                floating: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 45, bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            backgroundImage:
                                AssetImage('assets/profile_pic.jpg'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Your Library',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Raleway',
                              fontStyle: FontStyle.normal,
                              fontSize: 21.0,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          SvgIconButton(
                            selectedSVG: 'assets/search_outline.svg',
                            iconSize: 26,
                            unselectedColor: Colors.white,
                          ),
                          SvgIconButton(
                            selectedSVG: 'assets/plus.svg',
                            unselectedColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      ValueListenableBuilder<bool>(
                        valueListenable: showDownloadedContentNotifier,
                        builder: (context, showDownloadedContent, _) {
                          return Row(
                            children: [
                              if (showDownloadedContent)
                                Transform.translate(
                                  offset: Offset(0, -6.2),
                                  child: SvgIconButton(
                                    selectedSVG: 'assets/plus.svg',
                                    unselectedColor: Colors.white,
                                    angle: 45,
                                    onTap: () {
                                      setState(() {
                                        showDownloadedContentNotifier.value =
                                            false;
                                      });
                                    },
                                  ),
                                ),
                              if (!showDownloadedContent)
                                const CustomContainer(text: 'Playlists'),
                              if (!showDownloadedContent)
                                const CustomContainer(text: 'Artists'),
                              CustomContainer(
                                text: 'Downloaded',
                                stateCheck: showDownloadedContentNotifier.value,
                                onTap: () {
                                  setState(() {
                                    showDownloadedContentNotifier.value =
                                        !showDownloadedContentNotifier.value;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: ValueListenableBuilder<bool>(
            valueListenable: showDownloadedContentNotifier,
            builder: (context, showDownloadedContent, _) {
              return showDownloadedContent
                  ? const DownloadedSongs()
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const SizedBox(height: 15),
                              LibraryTile(
                                title: 'Now Playing',
                                icon: Icons.queue_music_rounded,
                                onTap: () {
                                  Navigator.pushNamed(context, '/nowplaying');
                                },
                              ),
                              /*
                          LibraryTile(
                            title: 'Last Session',
                            icon: Icons.history_rounded,
                            onTap: () {
                              Navigator.pushNamed(context, '/recent');
                            },
                          ),*/
                              LibraryTile(
                                title: 'Favorites',
                                icon: Icons.favorite_rounded,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LikedSongs(
                                        playlistName: 'Favorite Songs',
                                        showName: 'Favorite Songs',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              /*
                          LibraryTile(
                            title: 'My Music',
                            icon: Icons.music_video,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => (Platform.isWindows ||
                                          Platform.isLinux ||
                                          Platform.isMacOS)
                                      ? const DownloadedSongsDesktop()
                                      : const DownloadedSongs(
                                          showPlaylists: true,
                                        ),
                                ),
                              );
                            },
                          ),*/
                              LibraryTile(
                                title: 'Downloads',
                                icon: Icons.download_done_rounded,
                                onTap: () {
                                  Navigator.pushNamed(context, '/downloads');
                                },
                              ),
                              LibraryTile(
                                title: 'Playlists',
                                icon: Icons.playlist_play_rounded,
                                onTap: () {
                                  Navigator.pushNamed(context, '/playlists');
                                },
                              ),
                              LibraryTile(
                                title: 'Stats',
                                icon: Icons.auto_graph_rounded,
                                onTap: () {
                                  Navigator.pushNamed(context, '/stats');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
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

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
