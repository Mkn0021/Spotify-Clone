//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spotify/CustomWidgets/like_button.dart';
import 'package:spotify/CustomWidgets/miniplayer.dart';
import 'package:spotify/Services/player_service.dart';

class RecentlyPlayed extends StatefulWidget {
  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  List _songs = [];
  bool added = false;

  Future<void> getSongs() async {
    _songs = Hive.box('cache').get('recentSongs', defaultValue: []) as List;
    added = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              title: const Text(
                'Recently played',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
            body: _songs.isEmpty
                ? const SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You haven't played anything yet",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Here you'll find all your listening history",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w300,
                                color: Color(0xfff7f7f7),),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    shrinkWrap: true,
                    itemCount: _songs.length,
                    itemExtent: 70.0,
                    itemBuilder: (context, index) {
                      return _songs.isEmpty
                          ? const SizedBox()
                          : Dismissible(
                              key: Key(_songs[index]['id'].toString()),
                              direction: DismissDirection.endToStart,
                              background: const ColoredBox(
                                color: Colors.redAccent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.delete_outline_rounded),
                                    ],
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                _songs.removeAt(index);
                                setState(() {});
                                Hive.box('cache').put('recentSongs', _songs);
                              },
                              child: ListTile(
                                leading: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox.square(
                                    dimension: 55.0,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      errorWidget: (context, _, __) =>
                                          const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/cover.jpg'),
                                      ),
                                      imageUrl: _songs[index]['image']
                                          .toString()
                                          .replaceAll('http:', 'https:'),
                                      placeholder: (context, url) =>
                                          const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/cover.jpg'),
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // DownloadButton(
                                    //   data: _songs[index] as Map,
                                    //   icon: 'download',
                                    // ),
                                    LikeButton(
                                      mediaItem: null,
                                      data: _songs[index] as Map,
                                    ),
                                  ],
                                ),
                                title: Text(
                                  '${_songs[index]["title"]}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_songs[index]["artist"]}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  PlayerInvoke.init(
                                    songsList: _songs,
                                    index: index,
                                    isOffline: false,
                                  );
                                  Navigator.pushNamed(context, '/player');
                                },
                              ),
                            );
                    },
                  ),
          ),
        ),
        MiniPlayer(),
      ],
    );
  }
}
