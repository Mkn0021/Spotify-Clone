//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/CustomWidgets/on_hover.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/YouTube/youtube_playlist.dart';
import 'package:spotify/Screens/YouTube/youtube_search.dart';
import 'package:spotify/Services/youtube_services.dart';

bool status = false;
List searchedList = Hive.box('cache').get('ytHome', defaultValue: []) as List;
List headList = Hive.box('cache').get('ytHomeHead', defaultValue: []) as List;

class YouTube extends StatefulWidget {
  const YouTube({super.key});

  @override
  _YouTubeState createState() => _YouTubeState();
}

class _YouTubeState extends State<YouTube>
    with AutomaticKeepAliveClientMixin<YouTube> {
  // List ytSearch =
  // Hive.box('settings').get('ytSearch', defaultValue: []) as List;
  // bool showHistory =
  // Hive.box('settings').get('showHistory', defaultValue: true) as bool;
  final TextEditingController _controller = TextEditingController();
  // int _currentPage = 0;
  // final PageController _pageController = PageController(
  // viewportFraction:
  //     (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
  //         ? 0.385
  //         : 1.0,
  // );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (!status) {
      YouTubeServices().getMusicHome().then((value) {
        status = true;
        if (value.isNotEmpty) {
          setState(() {
            searchedList = value['body'] ?? [];
            headList = value['head'] ?? [];

            Hive.box('cache').put('ytHome', value['body']);
            Hive.box('cache').put('ytHomeHead', value['head']);
          });
        } else {
          status = false;
        }
      });
    }
    // if (headList.isNotEmpty) {
    // Timer.periodic(const Duration(seconds: 4), (Timer timer) {
    //   if (_currentPage < headList.length - 1) {
    //     _currentPage++;
    //   } else {
    //     _currentPage = 0;
    //   }
    //   if (_pageController.hasClients) {
    //     _pageController.animateToPage(
    //       _currentPage,
    //       duration: const Duration(milliseconds: 350),
    //       curve: Curves.easeIn,
    //     );
    //   }
    // });
    // }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    double boxSize = !rotated
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height / 2.5;
    if (boxSize > 250) boxSize = 250;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          if (searchedList.isEmpty)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.redAccent,
                ),
                strokeWidth: 5,
              ),
            )
          else
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  ListView.builder(
                    itemCount: searchedList.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 10),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  10,
                                  0,
                                  15,
                                ),
                                child: Text(
                                  '${searchedList[index]["title"]}',
                                  style: const TextStyle(
                                    color: Color(0xffeeeeee),
                                    fontSize: 20,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: boxSize + 10,
                            width: double.infinity,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              itemCount:
                                  (searchedList[index]['playlists'] as List)
                                      .length,
                              itemBuilder: (context, idx) {
                                final item =
                                    searchedList[index]['playlists'][idx];
                                item['subtitle'] = item['type'] != 'video'
                                    ? '${item["count"]} Tracks | ${item["description"]}'
                                    : '${item["count"]} | ${item["description"]}';
                                return GestureDetector(
                                  onTap: () {
                                    item['type'] == 'video'
                                        ? Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (_, __, ___) =>
                                                  YouTubeSearchPage(
                                                query: item['title'].toString(),
                                              ),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (_, __, ___) =>
                                                  YouTubePlaylist(
                                                playlistId: item['playlistId']
                                                    .toString(),
                                                // playlistImage:
                                                //     item['imageStandard']
                                                //         .toString(),
                                                // playlistName:
                                                //     item['title'].toString(),
                                                // playlistSubtitle:
                                                //     '${item['count']} Songs',
                                                // playlistSecondarySubtitle:
                                                //     item['description']
                                                //         ?.toString(),
                                              ),
                                            ),
                                          );
                                  },
                                  child: SizedBox(
                                    width: item['type'] != 'playlist'
                                        ? (boxSize - 30) * (16 / 9)
                                        : boxSize - 30,
                                    child: HoverBox(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Card(
                                                    elevation: 5,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                          8.0,
                                                        ),
                                                        topRight:
                                                            Radius.circular(
                                                          8.0,
                                                        ),
                                                      ),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      errorWidget: (
                                                        context,
                                                        _,
                                                        __,
                                                      ) =>
                                                          Image(
                                                        fit: BoxFit.cover,
                                                        image: item['type'] !=
                                                                'playlist'
                                                            ? const AssetImage(
                                                                'assets/ytCover.png',
                                                              )
                                                            : const AssetImage(
                                                                'assets/cover.jpg',
                                                              ),
                                                      ),
                                                      imageUrl: item['image']
                                                          .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Image(
                                                        fit: BoxFit.cover,
                                                        image: item['type'] !=
                                                                'playlist'
                                                            ? const AssetImage(
                                                                'assets/ytCover.png',
                                                              )
                                                            : const AssetImage(
                                                                'assets/cover.jpg',
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (item['type'] == 'chart')
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      color: Colors.black
                                                          .withOpacity(
                                                        0.75,
                                                      ),
                                                      width: (boxSize - 30) *
                                                          (16 / 9) /
                                                          2.5,
                                                      margin:
                                                          const EdgeInsets.all(
                                                        4.0,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            item['count']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const IconButton(
                                                            onPressed: null,
                                                            color: Colors.white,
                                                            disabledColor:
                                                                Colors.white,
                                                            icon: Icon(
                                                              Icons
                                                                  .playlist_play_rounded,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${item["title"]}',
                                                  textAlign: TextAlign.left,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xffe7e7e7),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  item['subtitle'].toString(),
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xffa7a7a7),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      builder: ({
                                        required BuildContext context,
                                        required bool isHover,
                                        Widget? child,
                                      }) {
                                        return Card(
                                          color: isHover
                                              ? null
                                              : Colors.transparent,
                                          elevation: 0,
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: rotated ? 0.0 : 70.0,
            left: 2.0,
            right: 2.0,
            child: MiniPlayer(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            //color: Colors.black,
            height: 140.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(130, 0, 0, 0),
                  Color.fromARGB(80, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 0.7, 0.85, 1.0],
              ),
            ),
            padding: const EdgeInsets.only(top: 40, bottom: 5, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 15,
                      backgroundImage: AssetImage('assets/yt_music.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Music',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.bold,
                        //fontFamily: 'Raleway',
                        fontStyle: FontStyle.normal,
                        fontSize: 25.0,
                      ),
                    ),
                    const Spacer(),
                    SvgIconButton(
                      selectedSVG: 'assets/search_outline.svg',
                      unselectedColor: Colors.white,
                      iconSize: 23,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YouTubeSearchPage(
                            query: '',
                            autofocus: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      backgroundImage: AssetImage('assets/profile_pic.jpg'),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
