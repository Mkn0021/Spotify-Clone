import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify/CustomWidgets/collage.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Helpers/import_export_playlist.dart';
import 'package:spotify/Screens/Library/import.dart';
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
  final Box settingsBox = Hive.box('settings');
  final List playlistNames =
      Hive.box('settings').get('playlistNames')?.toList() as List? ??
          ['Favorite Songs'];
  Map playlistDetails =
      Hive.box('settings').get('playlistDetails', defaultValue: {}) as Map;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Open the SettingsPage here
                        Navigator.pushNamed(
                          context,
                          '/setting',
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        backgroundImage: AssetImage('assets/profile_pic.jpg'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Your Library',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.normal,
                        fontSize: 21.0,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    const SvgIconButton(
                      selectedSVG: 'assets/search_outline.svg',
                      iconSize: 26,
                      unselectedColor: Colors.white,
                    ),
                    SvgIconButton(
                      selectedSVG: 'assets/plus.svg',
                      unselectedColor: Colors.white,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportPlaylist(),
                          ),
                        );
                      },
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
                  boxColor: const Color(0XFF79415D),
                  onTap: () {
                    Navigator.pushNamed(context, '/nowplaying');
                  },
                ),
              ),
              /*Visibility(
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
              ),*/
              Visibility(
                visible: !showPlaylists,
                child: LibraryTile(
                  title: 'Local Files',
                  icon: MdiIcons.folderMusic,
                  boxColor: const Color(0XFF30554A),
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
                  boxColor: const Color(0XFF192459),
                  onTap: () {
                    Navigator.pushNamed(context, '/downloads');
                  },
                ),
              ),
              /*Visibility(
                visible: !showDownloadedContent,
                child: LibraryTile(
                  title: AppLocalizations.of(context)!.playlists,
                  icon: Icons.playlist_play_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/playlists');
                  },
                ),
              ),*/
              Visibility(
                visible: !showDownloadedContent && !showPlaylists,
                child: LibraryTile(
                  title: AppLocalizations.of(context)!.stats,
                  subtitle: 'Music',
                  icon: Icons.auto_graph_rounded,
                  boxColor: const Color(0xFF59503C),
                  onTap: () {
                    Navigator.pushNamed(context, '/stats');
                  },
                ),
              ),
              Visibility(
                visible: !showDownloadedContent,
                child: ValueListenableBuilder(
                  valueListenable: settingsBox.listenable(),
                  builder: (
                    BuildContext context,
                    Box box,
                    Widget? child,
                  ) {
                    final List playlistNamesValue = box.get(
                          'playlistNames',
                          defaultValue: ['Favorite Songs'],
                        )?.toList() as List? ??
                        ['Favorite Songs'];
                    return Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: playlistNamesValue.length,
                        itemBuilder: (context, index) {
                          final String name =
                              playlistNamesValue[index].toString();
                          final String showName =
                              playlistDetails.containsKey(name)
                                  ? playlistDetails[name]['name']?.toString() ??
                                      name
                                  : name;
                          return ListTile(
                            leading: (playlistDetails[name] == null ||
                                    playlistDetails[name]['imagesList'] ==
                                        null ||
                                    (playlistDetails[name]['imagesList']
                                            as List)
                                        .isEmpty)
                                ? Card(
                                    elevation: 4,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: name == 'Liked Songs'
                                          ? const Image(
                                              image: AssetImage(
                                                'assets/cover.jpg',
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                'assets/album.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  )
                                : Collage(
                                    imageList: playlistDetails[name]
                                        ['imagesList'] as List,
                                    showGrid: true,
                                    placeholderImage: 'assets/cover.jpg',
                                  ),
                            title: Text(
                              showName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: playlistDetails[name] == null ||
                                    playlistDetails[name]['count'] == null ||
                                    playlistDetails[name]['count'] == 0
                                ? null
                                : Text(
                                    '${playlistDetails[name]['count']} ${AppLocalizations.of(context)!.songs}',
                                  ),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert_rounded),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              onSelected: (int? value) async {
                                if (value == 1) {
                                  exportPlaylist(
                                    context,
                                    name,
                                    playlistDetails.containsKey(name)
                                        ? playlistDetails[name]['name']
                                                ?.toString() ??
                                            name
                                        : name,
                                  );
                                }
                                if (value == 2) {
                                  sharePlaylist(
                                    context,
                                    name,
                                    playlistDetails.containsKey(name)
                                        ? playlistDetails[name]['name']
                                                ?.toString() ??
                                            name
                                        : name,
                                  );
                                }
                                if (value == 0) {
                                  ShowSnackBar().showSnackBar(
                                    context,
                                    '${AppLocalizations.of(context)!.deleted} $showName',
                                  );
                                  playlistDetails.remove(name);
                                  await settingsBox.put(
                                    'playlistDetails',
                                    playlistDetails,
                                  );
                                  await playlistNames.removeAt(index);
                                  await settingsBox.put(
                                    'playlistNames',
                                    playlistNames,
                                  );
                                  await Hive.openBox(name);
                                  await Hive.box(name).deleteFromDisk();
                                }
                                if (value == 3) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final controller = TextEditingController(
                                        text: showName,
                                      );
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!
                                                      .rename,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              autofocus: true,
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              controller: controller,
                                              onSubmitted: (value) async {
                                                Navigator.pop(context);
                                                playlistDetails[name] == null
                                                    ? playlistDetails.addAll({
                                                        name: {
                                                          'name': value.trim(),
                                                        },
                                                      })
                                                    : playlistDetails[name]
                                                        .addAll({
                                                        'name': value.trim(),
                                                      });

                                                await settingsBox.put(
                                                  'playlistDetails',
                                                  playlistDetails,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!
                                                  .cancel,
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              playlistDetails[name] == null
                                                  ? playlistDetails.addAll({
                                                      name: {
                                                        'name': controller.text
                                                            .trim(),
                                                      },
                                                    })
                                                  : playlistDetails[name]
                                                      .addAll({
                                                      'name': controller.text
                                                          .trim(),
                                                    });

                                              await settingsBox.put(
                                                'playlistDetails',
                                                playlistDetails,
                                              );
                                            },
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!
                                                  .ok,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary ==
                                                        Colors.white
                                                    ? Colors.black
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                if (name != 'Favorite Songs')
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.edit_rounded),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          AppLocalizations.of(context)!.rename,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (name != 'Favorite Songs')
                                  PopupMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.delete_rounded),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          AppLocalizations.of(context)!.delete,
                                        ),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(MdiIcons.export),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        AppLocalizations.of(context)!.export,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(MdiIcons.share),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        AppLocalizations.of(context)!.share,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await Hive.openBox(name);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LikedSongs(
                                    playlistName: name,
                                    showName: playlistDetails.containsKey(name)
                                        ? playlistDetails[name]['name']
                                                ?.toString() ??
                                            name
                                        : name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
    this.boxColor,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? boxColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: 17,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                color: Color(0xFFA7A7A7),
              ),
            )
          : const Text(
              'Playlist',
              style: TextStyle(
                color: Color(0xFFA7A7A7),
              ),
            ),
      leading: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: boxColor ?? const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
