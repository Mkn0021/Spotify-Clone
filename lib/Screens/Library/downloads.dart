//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotify/CustomWidgets/data_search.dart';
import 'package:spotify/CustomWidgets/empty_screen.dart';
import 'package:spotify/CustomWidgets/playlist_head.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/with_bottomNavBar.dart';
import 'package:spotify/Helpers/picker.dart';
import 'package:spotify/Services/player_service.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads>
    with SingleTickerProviderStateMixin {
  Box downloadsBox = Hive.box('downloads');
  bool added = false;
  List _songs = [];
  final Map<String, List<Map>> _albums = {};
  final Map<String, List<Map>> _artists = {};
  final Map<String, List<Map>> _genres = {};
  List _sortedAlbumKeysList = [];
  List _sortedArtistKeysList = [];
  List _sortedGenreKeysList = [];
  // int currentIndex = 0;
  // String? tempPath = Hive.box('settings').get('tempDirPath')?.toString();
  int sortValue = Hive.box('settings').get('sortValue', defaultValue: 1) as int;
  int orderValue =
      Hive.box('settings').get('orderValue', defaultValue: 1) as int;
  int albumSortValue =
      Hive.box('settings').get('albumSortValue', defaultValue: 2) as int;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getDownloads();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // void changeTitle() {
  //   setState(() {
  //     currentIndex = _tcontroller!.index;
  //   });
  // }

  Future<void> getDownloads() async {
    _songs = downloadsBox.values.toList();
    setArtistAlbum();
  }

  void setArtistAlbum() {
    for (final element in _songs) {
      try {
        if (_albums.containsKey(element['album'])) {
          final List<Map> tempAlbum = _albums[element['album']]!;
          tempAlbum.add(element as Map);
          _albums
              .addEntries([MapEntry(element['album'].toString(), tempAlbum)]);
        } else {
          _albums.addEntries([
            MapEntry(element['album'].toString(), [element as Map]),
          ]);
        }

        if (_artists.containsKey(element['artist'])) {
          final List<Map> tempArtist = _artists[element['artist']]!;
          tempArtist.add(element);
          _artists
              .addEntries([MapEntry(element['artist'].toString(), tempArtist)]);
        } else {
          _artists.addEntries([
            MapEntry(element['artist'].toString(), [element]),
          ]);
        }

        if (_genres.containsKey(element['genre'])) {
          final List<Map> tempGenre = _genres[element['genre']]!;
          tempGenre.add(element);
          _genres
              .addEntries([MapEntry(element['genre'].toString(), tempGenre)]);
        } else {
          _genres.addEntries([
            MapEntry(element['genre'].toString(), [element]),
          ]);
        }
      } catch (e) {
        // ShowSnackBar().showSnackBar(
        //   context,
        //   'Error: $e',
        // );
        Logger.root.severe('Error while setting artist and album: $e');
      }
    }

    sortSongs(sortVal: sortValue, order: orderValue);

    _sortedAlbumKeysList = _albums.keys.toList();
    _sortedArtistKeysList = _artists.keys.toList();
    _sortedGenreKeysList = _genres.keys.toList();

    sortAlbums();

    added = true;
    setState(() {});
  }

  void sortSongs({required int sortVal, required int order}) {
    switch (sortVal) {
      case 0:
        _songs.sort(
          (a, b) => a['title']
              .toString()
              .toUpperCase()
              .compareTo(b['title'].toString().toUpperCase()),
        );
        break;
      case 1:
        _songs.sort(
          (a, b) => a['dateAdded']
              .toString()
              .toUpperCase()
              .compareTo(b['dateAdded'].toString().toUpperCase()),
        );
        break;
      case 2:
        _songs.sort(
          (a, b) => a['album']
              .toString()
              .toUpperCase()
              .compareTo(b['album'].toString().toUpperCase()),
        );
        break;
      case 3:
        _songs.sort(
          (a, b) => a['artist']
              .toString()
              .toUpperCase()
              .compareTo(b['artist'].toString().toUpperCase()),
        );
        break;
      case 4:
        _songs.sort(
          (a, b) => a['duration']
              .toString()
              .toUpperCase()
              .compareTo(b['duration'].toString().toUpperCase()),
        );
        break;
      default:
        _songs.sort(
          (b, a) => a['dateAdded']
              .toString()
              .toUpperCase()
              .compareTo(b['dateAdded'].toString().toUpperCase()),
        );
        break;
    }

    if (order == 1) {
      _songs = _songs.reversed.toList();
    }
  }

  void sortAlbums() {
    switch (albumSortValue) {
      case 0:
        _sortedAlbumKeysList.sort(
          (a, b) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        _sortedArtistKeysList.sort(
          (a, b) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        _sortedGenreKeysList.sort(
          (a, b) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        break;
      case 1:
        _sortedAlbumKeysList.sort(
          (b, a) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        _sortedArtistKeysList.sort(
          (b, a) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        _sortedGenreKeysList.sort(
          (b, a) =>
              a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
        );
        break;
      case 2:
        _sortedAlbumKeysList
            .sort((b, a) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((b, a) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((b, a) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
      case 3:
        _sortedAlbumKeysList
            .sort((a, b) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((a, b) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((a, b) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
      default:
        _sortedAlbumKeysList
            .sort((b, a) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((b, a) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((b, a) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
    }
  }

  Future<void> deleteSong(Map song) async {
    await downloadsBox.delete(song['id']);
    final audioFile = File(song['path'].toString());
    final imageFile = File(song['image'].toString());
    if (_albums[song['album']]!.length == 1) {
      _sortedAlbumKeysList.remove(song['album']);
    }
    _albums[song['album']]!.remove(song);

    if (_artists[song['artist']]!.length == 1) {
      _sortedArtistKeysList.remove(song['artist']);
    }
    _artists[song['artist']]!.remove(song);

    if (_genres[song['genre']]!.length == 1) {
      _sortedGenreKeysList.remove(song['genre']);
    }
    _genres[song['genre']]!.remove(song);

    _songs.remove(song);
    try {
      audioFile.delete();
      if (await imageFile.exists()) {
        imageFile.delete();
      }
      ShowSnackBar().showSnackBar(
        context,
        '${AppLocalizations.of(context)!.deleted} ${song['title']}',
      );
    } catch (e) {
      Logger.root.severe('Failed to delete $audioFile.path', e);
      ShowSnackBar().showSnackBar(
        context,
        '${AppLocalizations.of(context)!.failedDelete}: ${audioFile.path}\nError: $e',
      );
    }
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
              Color(0XFF192459),
              Colors.black,
            ],
            stops: [0.0, 0.38],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.search),
                      tooltip: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DownloadsSearch(
                            data: _songs,
                            isDowns: true,
                          ),
                        );
                      },
                    ),
                    if (_songs.isNotEmpty)
                      PopupMenuButton(
                        icon: const Icon(Icons.sort_rounded),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        onSelected:
                            // (currentIndex == 0)
                            // ?
                            (int value) {
                          if (value < 5) {
                            sortValue = value;
                            Hive.box('settings').put('sortValue', value);
                          } else {
                            orderValue = value - 5;
                            Hive.box('settings').put('orderValue', orderValue);
                          }
                          sortSongs(sortVal: sortValue, order: orderValue);
                          setState(() {});
                          //   }
                          // : (int value) {
                          //     albumSortValue = value;
                          //     Hive.box('settings')
                          //         .put('albumSortValue', value);
                          //     sortAlbums();
                          //     setState(() {});
                        },
                        itemBuilder:
                            // (currentIndex == 0)
                            // ?
                            (context) {
                          final List<String> sortTypes = [
                            AppLocalizations.of(context)!.displayName,
                            AppLocalizations.of(context)!.dateAdded,
                            AppLocalizations.of(context)!.album,
                            AppLocalizations.of(context)!.artist,
                            AppLocalizations.of(context)!.duration,
                          ];
                          final List<String> orderTypes = [
                            AppLocalizations.of(context)!.inc,
                            AppLocalizations.of(context)!.dec,
                          ];
                          final menuList = <PopupMenuEntry<int>>[];
                          menuList.addAll(
                            sortTypes
                                .map(
                                  (e) => PopupMenuItem(
                                    value: sortTypes.indexOf(e),
                                    child: Row(
                                      children: [
                                        if (sortValue == sortTypes.indexOf(e))
                                          Icon(
                                            Icons.check_rounded,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                          )
                                        else
                                          const SizedBox(),
                                        const SizedBox(width: 10),
                                        Text(
                                          e,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                          menuList.add(
                            const PopupMenuDivider(
                              height: 10,
                            ),
                          );
                          menuList.addAll(
                            orderTypes
                                .map(
                                  (e) => PopupMenuItem(
                                    value: sortTypes.length +
                                        orderTypes.indexOf(e),
                                    child: Row(
                                      children: [
                                        if (orderValue == orderTypes.indexOf(e))
                                          Icon(
                                            Icons.check_rounded,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                          )
                                        else
                                          const SizedBox(),
                                        const SizedBox(width: 10),
                                        Text(
                                          e,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                          return menuList;
                        },
                      ),
                  ],
                ),
                body: !added
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : DownSongsList(
                        onDelete: (Map item) {
                          deleteSong(item);
                        },
                        songs: _songs,
                        scrollController: _scrollController,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Map> editTags(Map song, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      final tagger = Audiotagger();

      FileImage songImage = FileImage(File(song['image'].toString()));

      final titlecontroller =
          TextEditingController(text: song['title'].toString());
      final albumcontroller =
          TextEditingController(text: song['album'].toString());
      final artistcontroller =
          TextEditingController(text: song['artist'].toString());
      final albumArtistController =
          TextEditingController(text: song['albumArtist'].toString());
      final genrecontroller =
          TextEditingController(text: song['genre'].toString());
      final yearcontroller =
          TextEditingController(text: song['year'].toString());
      final pathcontroller =
          TextEditingController(text: song['path'].toString());

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final String filePath = await Picker.selectFile(
                      context: context,
                      // ext: ['png', 'jpg', 'jpeg'],
                      message: 'Pick Image',
                    );
                    if (filePath != '') {
                      final imagePath = filePath;
                      File(imagePath).copy(song['image'].toString());

                      songImage = FileImage(File(imagePath));

                      final Tag tag = Tag(
                        artwork: imagePath,
                      );
                      try {
                        await [
                          Permission.manageExternalStorage,
                        ].request();
                        await tagger.writeTags(
                          path: song['path'].toString(),
                          tag: tag,
                        );
                      } catch (e) {
                        await tagger.writeTags(
                          path: song['path'].toString(),
                          tag: tag,
                        );
                      }
                    }
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image(
                        fit: BoxFit.cover,
                        image: songImage,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: titlecontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.artist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: artistcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.albumArtist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: albumArtistController,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.album,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: albumcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.genre,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: genrecontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.year,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: yearcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.songPath,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: pathcontroller,
                  onSubmitted: (value) {},
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () async {
              Navigator.pop(context);
              song['title'] = titlecontroller.text;
              song['album'] = albumcontroller.text;
              song['artist'] = artistcontroller.text;
              song['albumArtist'] = albumArtistController.text;
              song['genre'] = genrecontroller.text;
              song['year'] = yearcontroller.text;
              song['path'] = pathcontroller.text;
              final tag = Tag(
                title: titlecontroller.text,
                artist: artistcontroller.text,
                album: albumcontroller.text,
                genre: genrecontroller.text,
                year: yearcontroller.text,
                albumArtist: albumArtistController.text,
              );
              try {
                try {
                  await [
                    Permission.manageExternalStorage,
                  ].request();
                  tagger.writeTags(
                    path: song['path'].toString(),
                    tag: tag,
                  );
                } catch (e) {
                  await tagger.writeTags(
                    path: song['path'].toString(),
                    tag: tag,
                  );
                  ShowSnackBar().showSnackBar(
                    context,
                    AppLocalizations.of(context)!.successTagEdit,
                  );
                }
              } catch (e) {
                Logger.root.severe('Failed to edit tags', e);
                ShowSnackBar().showSnackBar(
                  context,
                  '${AppLocalizations.of(context)!.failedTagEdit}\nError: $e',
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary == Colors.white
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
  return song;
}

class DownSongsList extends StatefulWidget {
  final List songs;
  final Function(Map item) onDelete;
  final ScrollController scrollController;
  const DownSongsList({
    super.key,
    required this.songs,
    required this.onDelete,
    required this.scrollController,
  });

  @override
  State<DownSongsList> createState() => _DownSongsListState();
}

class _DownSongsListState extends State<DownSongsList>
    with AutomaticKeepAliveClientMixin {
  Future<void> downImage(
    String imageFilePath,
    String songFilePath,
    String url,
  ) async {
    final File file = File(imageFilePath);

    try {
      await file.create();
      final image = await Audiotagger().readArtwork(path: songFilePath);
      if (image != null) {
        file.writeAsBytesSync(image);
      }
    } catch (e) {
      final HttpClientRequest request2 =
          await HttpClient().getUrl(Uri.parse(url));
      final HttpClientResponse response2 = await request2.close();
      final bytes2 = await consolidateHttpClientResponseBytes(response2);
      await file.writeAsBytes(bytes2);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        PlaylistHead(
          title: 'Downloads',
          songsList: widget.songs,
          offline: true,
          fromDownloads: true,
        ),
        if (widget.songs.isEmpty)
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
            child: ListView.builder(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              shrinkWrap: true,
              itemCount: widget.songs.length,
              itemExtent: 70.0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Card(
                    elevation: 5,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox.square(
                      dimension: 50,
                      child: Image(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(
                            widget.songs[index]['image'].toString(),
                          ),
                        ),
                        errorBuilder: (_, __, ___) {
                          if (widget.songs[index]['image'] != null &&
                              widget.songs[index]['image_url'] != null) {
                            downImage(
                              widget.songs[index]['image'].toString(),
                              widget.songs[index]['path'].toString(),
                              widget.songs[index]['image_url'].toString(),
                            );
                          }
                          return Image.asset(
                            'assets/cover.jpg',
                          );
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    PlayerInvoke.init(
                      songsList: widget.songs,
                      index: index,
                      isOffline: true,
                      fromDownloads: true,
                      recommend: false,
                    );
                  },
                  title: Text(
                    '${widget.songs[index]['title']}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${widget.songs[index]['artist'] ?? 'Artist name'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert_sharp,
                          color: Color(0XFFA7A7A7),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit_rounded,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .edit,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_rounded,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .delete,
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (int? value) async {
                          if (value == 0) {
                            widget.songs[index] = await editTags(
                              widget.songs[index] as Map,
                              context,
                            );
                            Hive.box('downloads').put(
                              widget.songs[index]['id'],
                              widget.songs[index],
                            );
                            setState(() {});
                          }
                          if (value == 1) {
                            setState(() {
                              widget.onDelete(widget.songs[index] as Map);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
