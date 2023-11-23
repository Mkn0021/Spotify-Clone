//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:spotify/CustomWidgets/empty_screen.dart';
import 'package:spotify/CustomWidgets/gradient_containers.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/search_bar.dart' as searchbar;
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/YouTube/youtube_artist.dart';
import 'package:spotify/Screens/YouTube/youtube_playlist.dart';
import 'package:spotify/Services/player_service.dart';
import 'package:spotify/Services/youtube_services.dart';
import 'package:spotify/Services/yt_music.dart';

class YouTubeSearchPage extends StatefulWidget {
  final String query;
  final bool autofocus;
  const YouTubeSearchPage({
    super.key,
    required this.query,
    this.autofocus = false,
  });
  @override
  _YouTubeSearchPageState createState() => _YouTubeSearchPageState();
}

class _YouTubeSearchPageState extends State<YouTubeSearchPage> {
  String query = '';
  bool status = false;
  List<Map> searchedList = [];
  bool fetched = false;
  bool done = true;
  bool liveSearch =
      Hive.box('settings').get('liveSearch', defaultValue: true) as bool;
  List searchHistory =
      Hive.box('settings').get('search', defaultValue: []) as List;
  bool searchYtMusic =
      Hive.box('settings').get('searchYtMusic', defaultValue: true) as bool;
  bool searchYoutube = false;
  // bool showHistory =
  // Hive.box('settings').get('showHistory', defaultValue: true) as bool;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.query;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    double boxSize = !rotated
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height / 2.5;
    if (boxSize > 250) boxSize = 250;
    if (!status) {
      status = true;
      if (query.isEmpty && widget.query.isEmpty) {
        fetched = true;
      } else {
        if (searchYtMusic) {
          Logger.root.info('calling yt music search');
          YtMusicService()
              .search(query == '' ? widget.query : query)
              .then((value) {
            setState(() {
              searchedList = value;
              fetched = true;
            });
          });
        } else {
          Logger.root.info('calling youtube search');
          YouTubeServices.instance
              .fetchSearchResults(query == '' ? widget.query : query)
              .then((value) {
            setState(() {
              searchedList = value;
              fetched = true;
            });
          });
        }
      }
    }
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.black,
                  body: searchbar.SearchBar(
                    isYt: true,
                    controller: _controller,
                    liveSearch: true,
                    autofocus: widget.autofocus,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    hintText: AppLocalizations.of(context)!.searchYt,
                    onQueryChanged: (changedQuery) {
                      return YouTubeServices.instance
                          .getSearchSuggestions(query: changedQuery);
                    },
                    onSubmitted: (submittedQuery) async {
                      setState(() {
                        fetched = false;
                        query = submittedQuery;
                        _controller.text = submittedQuery;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: query.length,
                          ),
                        );
                        status = false;
                        searchedList = [];
                      });
                    },
                    body: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            left: 20,
                          ),
                          child: (query.isEmpty && widget.query.isEmpty)
                              ? null
                              : Row(
                                  children: [
                                    CustomContainer(
                                      text: 'YT Music',
                                      stateCheck: searchYtMusic,
                                      onTap: () {
                                        searchYtMusic = !searchYtMusic;
                                        searchYoutube = !searchYtMusic;
                                        fetched = false;
                                        status = false;
                                        Hive.box('settings').put(
                                          'searchYtMusic',
                                          searchYtMusic,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    CustomContainer(
                                      text: 'YouTube',
                                      stateCheck: searchYoutube,
                                      onTap: () {
                                        searchYoutube = !searchYoutube;
                                        searchYtMusic = !searchYoutube;
                                        fetched = false;
                                        status = false;
                                        Hive.box('settings').put(
                                          'searchYtMusic',
                                          searchYtMusic,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                        ),
                        Expanded(
                          child: (!fetched)
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                    strokeWidth: 5,
                                  ),
                                )
                              : (query.isEmpty && widget.query.isEmpty)
                                  ? SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Wrap(
                                              children: List<Widget>.generate(
                                                searchHistory.length,
                                                (int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 5.0,
                                                    ),
                                                    child: GestureDetector(
                                                      child: Chip(
                                                        label: Text(
                                                          searchHistory[index]
                                                              .toString(),
                                                        ),
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        onDeleted: () {
                                                          setState(() {
                                                            searchHistory
                                                                .removeAt(
                                                                    index,);
                                                            Hive.box('settings')
                                                                .put(
                                                              'search',
                                                              searchHistory,
                                                            );
                                                          });
                                                        },
                                                      ),
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            fetched = false;
                                                            query =
                                                                searchHistory
                                                                    .removeAt(
                                                                        index,)
                                                                    .toString()
                                                                    .trim();
                                                            searchHistory
                                                                .insert(
                                                              0,
                                                              query,
                                                            );
                                                            Hive.box('settings')
                                                                .put(
                                                              'search',
                                                              searchHistory,
                                                            );

                                                            _controller.text =
                                                                query;
                                                            status = false;
                                                            fetched = false;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : searchedList.isEmpty
                                      ? emptyScreen(
                                          context,
                                          0,
                                          ':( ',
                                          100,
                                          AppLocalizations.of(
                                            context,
                                          )!
                                              .sorry,
                                          60,
                                          AppLocalizations.of(
                                            context,
                                          )!
                                              .resultsNotFound,
                                          20,
                                        )
                                      : Stack(
                                          children: [
                                            SingleChildScrollView(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Column(
                                                children: searchedList.map(
                                                  (Map section) {
                                                    if (section['items'] ==
                                                        null) {
                                                      return const SizedBox();
                                                    }
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 16,
                                                            top: 20,
                                                            bottom: 5,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                section['title']
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                    0xffeeeeee,
                                                                  ),
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Raleway',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              //   if (section['title'] !=
                                                              //       'Top Result')
                                                              //     Row(
                                                              //       mainAxisAlignment:
                                                              //           MainAxisAlignment
                                                              //               .end,
                                                              //       children: [
                                                              //         GestureDetector(
                                                              //           onTap: () {},
                                                              //           child: Row(
                                                              //             children: [
                                                              //               Text(
                                                              //                 AppLocalizations
                                                              //                         .of(
                                                              //                   context,
                                                              //                 )!
                                                              //                     .viewAll,
                                                              //                 style:
                                                              //                     TextStyle(
                                                              //                   color: Theme
                                                              //                           .of(
                                                              //                     context,
                                                              //                   )
                                                              //                       .textTheme
                                                              //                       .caption!
                                                              //                       .color,
                                                              //                   fontWeight:
                                                              //                       FontWeight
                                                              //                           .w800,
                                                              //                 ),
                                                              //               ),
                                                              //               Icon(
                                                              //                 Icons
                                                              //                     .chevron_right_rounded,
                                                              //                 color: Theme
                                                              //                         .of(
                                                              //                   context,
                                                              //                 )
                                                              //                     .textTheme
                                                              //                     .caption!
                                                              //                     .color,
                                                              //               ),
                                                              //             ],
                                                              //           ),
                                                              //         ),
                                                              //       ],
                                                              //     ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              (section['items']
                                                                      as List)
                                                                  .length,
                                                          itemBuilder:
                                                              (context, idx) {
                                                            final itemType =
                                                                section['items'][idx]
                                                                            [
                                                                            'type']
                                                                        ?.toString() ??
                                                                    'Video';
                                                            return ListTile(
                                                              title: Text(
                                                                section['items']
                                                                            [
                                                                            idx]
                                                                        [
                                                                        'title']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xffe7e7e7,
                                                                  ),
                                                                ),
                                                              ),
                                                              subtitle: Text(
                                                                section['items']
                                                                            [
                                                                            idx]
                                                                        [
                                                                        'subtitle']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      13.5,
                                                                  color: Color(
                                                                    0xffa7a7a7,
                                                                  ),
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 15.0,
                                                              ),
                                                              leading: Card(
                                                                margin:
                                                                    EdgeInsets
                                                                        .zero,
                                                                elevation: 8,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    itemType ==
                                                                            'Artist'
                                                                        ? 50.0
                                                                        : 7.0,
                                                                  ),
                                                                ),
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorWidget: (
                                                                    context,
                                                                    _,
                                                                    __,
                                                                  ) =>
                                                                      const Image(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        AssetImage(
                                                                      'assets/cover.jpg',
                                                                    ),
                                                                  ),
                                                                  imageUrl: section['items']
                                                                              [
                                                                              idx]
                                                                          [
                                                                          'image']
                                                                      .toString(),
                                                                  placeholder: (
                                                                    context,
                                                                    url,
                                                                  ) =>
                                                                      const Image(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        AssetImage(
                                                                      'assets/cover.jpg',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              trailing: (itemType ==
                                                                          'Song' ||
                                                                      itemType ==
                                                                          'Video')
                                                                  ? YtSongTileTrailingMenu(
                                                                      data: section['items']
                                                                              [
                                                                              idx]
                                                                          as Map,
                                                                    )
                                                                  : null,
                                                              onTap: () async {
                                                                if (itemType ==
                                                                    'Artist') {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              YouTubeArtist(
                                                                        artistId:
                                                                            section['items'][idx]['id'].toString(),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                if (itemType == 'Playlist' ||
                                                                    itemType ==
                                                                        'Album' ||
                                                                    itemType ==
                                                                        'Single') {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              YouTubePlaylist(
                                                                        playlistId:
                                                                            section['items'][idx]['id'].toString(),
                                                                        type: itemType == 'Album' ||
                                                                                itemType == 'Single'
                                                                            ? 'album'
                                                                            : 'playlist',
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                if (itemType ==
                                                                        'Song' ||
                                                                    itemType ==
                                                                        'Video') {
                                                                  setState(() {
                                                                    done =
                                                                        false;
                                                                  });
                                                                  final Map?
                                                                      response =
                                                                      await YouTubeServices.instance
                                                                          .formatVideoFromId(
                                                                    id: section['items'][idx]
                                                                            [
                                                                            'id']
                                                                        .toString(),
                                                                    data: section['items']
                                                                            [
                                                                            idx]
                                                                        as Map,
                                                                  );
                                                                  if (itemType ==
                                                                      'Song') {
                                                                    final Map
                                                                        response2 =
                                                                        await YtMusicService()
                                                                            .getSongData(
                                                                      videoId: section['items'][idx]
                                                                              [
                                                                              'id']
                                                                          .toString(),
                                                                    );
                                                                    if (response !=
                                                                            null &&
                                                                        response2['image'] !=
                                                                            null) {
                                                                      response[
                                                                          'image'] = response2[
                                                                              'image'] ??
                                                                          response[
                                                                              'image'];
                                                                    }
                                                                  }
                                                                  setState(() {
                                                                    done = true;
                                                                  });
                                                                  if (response !=
                                                                      null) {
                                                                    PlayerInvoke
                                                                        .init(
                                                                      songsList: [
                                                                        response,
                                                                      ],
                                                                      index: 0,
                                                                      isOffline:
                                                                          false,
                                                                    );
                                                                  }
                                                                  response ==
                                                                          null
                                                                      ? ShowSnackBar()
                                                                          .showSnackBar(
                                                                          context,
                                                                          AppLocalizations.of(
                                                                            context,
                                                                          )!
                                                                              .ytLiveAlert,
                                                                        )
                                                                      : Navigator
                                                                          .pushNamed(
                                                                          context,
                                                                          '/player',
                                                                        );
                                                                }
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                            if (!done)
                                              Center(
                                                child: SizedBox.square(
                                                  dimension: boxSize,
                                                  child: Card(
                                                    elevation: 10,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: GradientContainer(
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            const CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                Color(
                                                                    0xFF1ED760,),
                                                              ),
                                                              strokeWidth: 5,
                                                            ),
                                                            Text(
                                                              AppLocalizations
                                                                      .of(
                                                                context,
                                                              )!
                                                                  .fetchingStream,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: rotated ? screenWidth / 2 : 2.0,
            right: 2.0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
