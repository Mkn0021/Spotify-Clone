//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spotify/APIs/api.dart';
import 'package:spotify/CustomWidgets/bottom_nav_bar.dart';
import 'package:spotify/CustomWidgets/bouncy_playlist_header_scroll_view.dart';
import 'package:spotify/CustomWidgets/copy_clipboard.dart';
import 'package:spotify/CustomWidgets/download_button.dart';
import 'package:spotify/CustomWidgets/like_button.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/playlist_popupmenu.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Helpers/extensions.dart';
import 'package:spotify/Helpers/image_resolution_modifier.dart';
import 'package:spotify/Services/player_service.dart';

class SongsListPage extends StatefulWidget {
  final Map listItem;

  const SongsListPage({
    super.key,
    required this.listItem,
  });

  @override
  _SongsListPageState createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  int page = 1;
  bool loading = false;
  List songList = [];
  bool fetched = false;
  bool isSharePopupShown = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSongs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          widget.listItem['type'].toString() == 'songs' &&
          !loading) {
        page += 1;
        _fetchSongs();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  void _fetchSongs() {
    loading = true;
    try {
      switch (widget.listItem['type'].toString()) {
        case 'songs':
          SaavnAPI()
              .fetchSongSearchResults(
            searchQuery: widget.listItem['id'].toString(),
            page: page,
          )
              .then((value) {
            setState(() {
              songList.addAll(value['songs'] as List);
              fetched = true;
              loading = false;
            });
            if (value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'album':
          SaavnAPI()
              .fetchAlbumSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });
            if (value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'playlist':
          SaavnAPI()
              .fetchPlaylistSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });
            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'mix':
          SaavnAPI()
              .getSongFromToken(
            widget.listItem['perma_url'].toString().split('/').last,
            'mix',
          )
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });

            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'show':
          SaavnAPI()
              .getSongFromToken(
            widget.listItem['perma_url'].toString().split('/').last,
            'show',
          )
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });

            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        default:
          setState(() {
            fetched = true;
            loading = false;
          });
          ShowSnackBar().showSnackBar(
            context,
            'Error: Unsupported Type ${widget.listItem['type']}',
            duration: const Duration(seconds: 3),
          );
          break;
      }
    } catch (e) {
      setState(() {
        fetched = true;
        loading = false;
      });
      Logger.root.severe(
        'Error in song_list with type ${widget.listItem["type"]}: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool rotated = MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.black,
                body: BouncyPlaylistHeaderScrollView(
                  scrollController: _scrollController,
                  actions: [
                    if (songList.isNotEmpty)
                      MultiDownloadButton(
                        data: songList,
                        playlistName:
                            widget.listItem['title']?.toString() ?? 'Songs',
                      ),
                    if (songList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 3, right: 5),
                        child: SvgIconButton(
                          selectedSVG: 'assets/download_button.svg',
                          iconSize: 23,
                          selectedColor: Colors.grey,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.share_rounded,
                        size: 18,
                      ),
                      tooltip: AppLocalizations.of(context)!.share,
                      onPressed: () {
                        if (!isSharePopupShown) {
                          isSharePopupShown = true;

                          Share.share(
                            widget.listItem['perma_url'].toString(),
                          ).whenComplete(() {
                            Timer(const Duration(milliseconds: 500), () {
                              isSharePopupShown = false;
                            });
                          });
                        }
                      },
                    ),
                    PlaylistPopupMenu(
                      data: songList,
                      title: widget.listItem['title']?.toString() ?? 'Songs',
                    ),
                  ],
                  title: widget.listItem['title']?.toString().unescape() ??
                      'Songs',
                  subtitle: '${songList.length} Songs',
                  secondarySubtitle: widget.listItem['subTitle']?.toString() ??
                      widget.listItem['subtitle']?.toString(),
                  onPlayTap: () => PlayerInvoke.init(
                    songsList: songList,
                    index: 0,
                    isOffline: false,
                  ),
                  onShuffleTap: () => PlayerInvoke.init(
                    songsList: songList,
                    index: 0,
                    isOffline: false,
                    shuffle: true,
                  ),
                  placeholderImage: 'assets/album.png',
                  imageUrl: getImageUrl(widget.listItem['image']?.toString()),
                  sliverList: SliverList(
                    delegate: SliverChildListDelegate([
                      if (!fetched)
                        const Padding(
                          padding: EdgeInsets.only(top: 150.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (songList.isNotEmpty)
                        //list start from here
                        ...songList.map((entry) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 15.0),
                            title: Text(
                              '${entry["title"]}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onLongPress: () {
                              copyToClipboard(
                                context: context,
                                text: '${entry["title"]}',
                              );
                            },
                            subtitle: Text(
                              '${entry["subtitle"]}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Card(
                              margin: EdgeInsets.zero,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                errorWidget: (context, _, __) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/cover.jpg',
                                  ),
                                ),
                                imageUrl:
                                    '${entry["image"].replaceAll('http:', 'https:')}',
                                placeholder: (context, url) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/cover.jpg',
                                  ),
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DownloadButton(
                                  data: entry as Map,
                                  icon: 'download',
                                ),
                                LikeButton(
                                  mediaItem: null,
                                  data: entry,
                                ),
                                SongTileTrailingMenu(data: entry),
                              ],
                            ),
                            onTap: () {
                              PlayerInvoke.init(
                                songsList: songList,
                                index: songList.indexWhere(
                                  (element) => element == entry,
                                ),
                                isOffline: false,
                              );
                            },
                          );
                        }),
                    ]),
                  ),
                ),
              ),
            ),
          ],
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
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/home_fill.svg',
                      unselectedIcon: 'assets/home_outline.svg',
                      indexChecker: true,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/search_fill.svg',
                      unselectedIcon: 'assets/search_outline.svg',
                      indexChecker: false,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/library_fill.svg',
                      unselectedIcon: 'assets/library_outline.svg',
                      indexChecker: false,
                    ),
                    label: 'Your Library',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      selectedIcon: 'assets/yt_music_fill.svg',
                      unselectedIcon: 'assets/yt_music_outline.svg',
                      indexChecker: false,
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
