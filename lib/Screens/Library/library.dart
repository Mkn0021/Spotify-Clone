import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/Library/liked.dart';
import 'package:spotify/Screens/LocalMusic/downed_songs.dart';
import 'package:spotify/Screens/LocalMusic/downed_songs_desktop.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool showPlaylists = false;
  bool showDownloadedContent = false;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool rotated = MediaQuery.sizeOf(context).height < screenWidth;
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              toolbarHeight: 140,
              expandedHeight: 140,
              pinned: true,
              floating: true,
              title: Padding(
                padding: const EdgeInsets.only(
                  top: 45,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          backgroundImage: AssetImage('assets/profile_pic.jpg'),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: showPlaylists || showDownloadedContent,
                          child: Transform.translate(
                            offset: const Offset(0, -6.2),
                            child: SvgIconButton(
                              selectedSVG: 'assets/plus.svg',
                              unselectedColor: Colors.white,
                              angle: 45,
                              onTap: () {
                                setState(() {
                                  showPlaylists = false;
                                  showDownloadedContent = false;
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !showDownloadedContent,
                          child: CustomContainer(
                            text: 'Playlists',
                            stateCheck: showPlaylists,
                            onTap: () {
                              setState(() {
                                showPlaylists = !showPlaylists;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: !showPlaylists,
                          child: CustomContainer(
                            text: 'Downloaded',
                            stateCheck: showDownloadedContent,
                            onTap: () {
                              setState(() {
                                showDownloadedContent = !showDownloadedContent;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 15),
                  Visibility(
                    visible: !showDownloadedContent,
                    child: LibraryTile(
                      title: AppLocalizations.of(context)!.nowPlaying,
                      icon: Icons.queue_music_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/nowplaying');
                      },
                    ),
                  ),
                  Visibility(
                    visible: !showDownloadedContent,
                    child: LibraryTile(
                      title: AppLocalizations.of(context)!.favorites,
                      icon: Icons.favorite_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LikedSongs(
                              playlistName: 'Favorite Songs',
                              showName: AppLocalizations.of(context)!.favSongs,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: !showPlaylists,
                    child: LibraryTile(
                      title: 'Local Files',
                      icon: MdiIcons.folderMusic,
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
                    ),
                  ),
                  Visibility(
                    visible: !showPlaylists,
                    child: LibraryTile(
                      title: AppLocalizations.of(context)!.downs,
                      icon: Icons.download_done_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/downloads');
                      },
                    ),
                  ),
                  Visibility(
                    visible: !showDownloadedContent,
                    child: LibraryTile(
                      title: AppLocalizations.of(context)!.playlists,
                      icon: Icons.playlist_play_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/playlists');
                      },
                    ),
                  ),
                  Visibility(
                    visible: !showDownloadedContent && !showPlaylists,
                    child: LibraryTile(
                      title: AppLocalizations.of(context)!.stats,
                      icon: Icons.auto_graph_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/stats');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: rotated ? 0.0 : 70.0,
          left: rotated ? screenWidth / 2 : 2.0,
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
    this.subtitle,
  });

  final String title;
  final String? subtitle;
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
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
              ),
            )
          : null,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
