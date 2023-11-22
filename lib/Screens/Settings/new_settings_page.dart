import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/Settings/about.dart';
import 'package:spotify/Screens/Settings/app_ui.dart';
import 'package:spotify/Screens/Settings/backup_and_restore.dart';
import 'package:spotify/Screens/Settings/download.dart';
import 'package:spotify/Screens/Settings/music_playback.dart';
import 'package:spotify/Screens/Settings/others.dart';
import 'package:spotify/Screens/Settings/theme.dart';

class NewSettingsPage extends StatefulWidget {
  final Function? callback;

  const NewSettingsPage({this.callback});

  @override
  State<NewSettingsPage> createState() => _NewSettingsPageState();
}

class _NewSettingsPageState extends State<NewSettingsPage> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');

  @override
  void dispose() {
    controller.dispose();
    searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24 , vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23.5,
                  backgroundImage: AssetImage('assets/profile_pic.jpg'),
                ),
              ],
            ),
            const SizedBox(height: 12,),
            const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xffeeeeee),
                fontSize: 40,
              ),
            ),
            _searchBar(context),
            Expanded(child: _settingsItem(context)),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(2.0, 20.0, 2.0, 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30.0,
        ),
      ),
      color: Theme.of(context).cardColor,
      elevation: 2.0,
      child: SizedBox(
        height: 55.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3 , horizontal: 16),
          child: ValueListenableBuilder(
            valueListenable: searchQuery,
            builder: (BuildContext context, String query, Widget? child) {
              return TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.transparent,
                    ),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  prefixIcon: const SvgIconButton(
                    selectedSVG: 'assets/search_outline.svg',
                    selectedColor: Color(0xffe3e3e3),
                    unselectedColor: Color(0xffe3e3e3),
                  ),
                  suffixIcon: query.trim() != ''
                      ? IconButton(
                          onPressed: () {
                            controller.clear();
                            searchQuery.value = '';
                          },
                          icon: const Icon(Icons.close_rounded),
                        )
                      : null,
                  border: InputBorder.none,
                  hintText: 'Search settings',
                  hintStyle: const TextStyle(
                    fontSize: 19,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onChanged: (_) {
                  searchQuery.value = controller.text.trim();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(BuildContext context) {
    final List<Map<String, dynamic>> settingsList = [
      {
        'title': AppLocalizations.of(
          context,
        )!
            .theme,
        'icon': MdiIcons.themeLightDark,
        'onTap': ThemePage(
          callback: widget.callback,
        ),
        'isThreeLine': true,
        'items': [
          AppLocalizations.of(context)!.darkMode,
          AppLocalizations.of(context)!.accent,
          AppLocalizations.of(context)!.useSystemTheme,
          AppLocalizations.of(context)!.bgGrad,
          AppLocalizations.of(context)!.cardGrad,
          AppLocalizations.of(context)!.bottomGrad,
          AppLocalizations.of(context)!.canvasColor,
          AppLocalizations.of(context)!.cardColor,
          AppLocalizations.of(context)!.useSpotify,
          AppLocalizations.of(context)!.currentTheme,
          AppLocalizations.of(context)!.saveTheme,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .ui,
        'icon': Icons.design_services_rounded,
        'onTap': AppUIPage(
          callback: widget.callback,
        ),
        'isThreeLine': true,
        'items': [
          AppLocalizations.of(context)!.playerScreenBackground,
          AppLocalizations.of(context)!.miniButtons,
          AppLocalizations.of(context)!.useDenseMini,
          AppLocalizations.of(context)!.blacklistedHomeSections,
          AppLocalizations.of(context)!.changeOrder,
          AppLocalizations.of(context)!.compactNotificationButtons,
          AppLocalizations.of(context)!.showPlaylists,
          AppLocalizations.of(context)!.showLast,
          AppLocalizations.of(context)!.enableGesture,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .musicPlayback,
        'icon': Icons.music_note_rounded,
        'onTap': MusicPlaybackPage(
          callback: widget.callback,
        ),
        'isThreeLine': true,
        'items': [
          AppLocalizations.of(context)!.musicLang,
          AppLocalizations.of(context)!.streamQuality,
          AppLocalizations.of(context)!.chartLocation,
          AppLocalizations.of(context)!.streamWifiQuality,
          AppLocalizations.of(context)!.ytStreamQuality,
          AppLocalizations.of(context)!.loadLast,
          AppLocalizations.of(context)!.resetOnSkip,
          AppLocalizations.of(context)!.enforceRepeat,
          AppLocalizations.of(context)!.autoplay,
          AppLocalizations.of(context)!.cacheSong,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .down,
        'icon': Icons.download_done_rounded,
        'onTap': const DownloadPage(),
        'isThreeLine': true,
        'items': [
          AppLocalizations.of(context)!.downQuality,
          AppLocalizations.of(context)!.downLocation,
          AppLocalizations.of(context)!.downFilename,
          AppLocalizations.of(context)!.ytDownQuality,
          AppLocalizations.of(context)!.createAlbumFold,
          AppLocalizations.of(context)!.createYtFold,
          AppLocalizations.of(context)!.downLyrics,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .others,
        'icon': Icons.miscellaneous_services_rounded,
        'onTap': const OthersPage(),
        'isThreeLine': true,
        'items': [
          AppLocalizations.of(context)!.lang,
          AppLocalizations.of(context)!.includeExcludeFolder,
          AppLocalizations.of(context)!.minAudioLen,
          AppLocalizations.of(context)!.liveSearch,
          AppLocalizations.of(context)!.useDown,
          AppLocalizations.of(context)!.getLyricsOnline,
          AppLocalizations.of(context)!.supportEq,
          AppLocalizations.of(context)!.stopOnClose,
          AppLocalizations.of(context)!.checkUpdate,
          AppLocalizations.of(context)!.useProxy,
          AppLocalizations.of(context)!.proxySet,
          AppLocalizations.of(context)!.clearCache,
          AppLocalizations.of(context)!.shareLogs,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .backNRest,
        'icon': Icons.settings_backup_restore_rounded,
        'onTap': const BackupAndRestorePage(),
        'isThreeLine': false,
        'items': [
          AppLocalizations.of(context)!.createBack,
          AppLocalizations.of(context)!.restore,
          AppLocalizations.of(context)!.autoBack,
          AppLocalizations.of(context)!.autoBackLocation,
        ],
      },
      {
        'title': AppLocalizations.of(
          context,
        )!
            .about,
        'icon': Icons.info_outline_rounded,
        'onTap': const AboutPage(),
        'isThreeLine': false,
        'items': [
          'Developer',
        ],
      },
    ];

    final List<Map> searchOptions = [];
    for (final Map e in settingsList) {
      for (final item in e['items'] as List) {
        searchOptions.add({'title': item, 'route': e['onTap']});
      }
    }

    //final bool isRotated = MediaQuery.of(context).orientation == Orientation.landscape;

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          physics: const BouncingScrollPhysics(),
          itemCount: settingsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Center(
                      child: Icon(
                        settingsList[index]['icon'] as IconData,
                        color: const Color(0xffe7e7e7),
                        size: 28,
                      ),
                    ),
                  const SizedBox(
                      width: 16.0,), // Add some space between the icon and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settingsList[index]['title'].toString(),
                          style: const TextStyle(
                              color: Color(0xffeeeeee),
                              fontSize: 18,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                        const SizedBox(height: 2,),
                        Text(
                          (settingsList[index]['items'] as List)
                              .take(3)
                              .join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xffa7a7a7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              isThreeLine: settingsList[index]['subtitle'] != null,
              onTap: () {
                searchQuery.value = '';
                controller.text = '';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        settingsList[index]['onTap'] as Widget,
                  ),
                );
              },
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: searchQuery,
          builder: (BuildContext context, String query, Widget? child) {
            if (query != '') {
              final List<Map> results = _getSearchResults(searchOptions, query);
              return _searchSuggestions(context, results);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  List<Map> _getSearchResults(
    List<Map> searchOptions,
    String query,
  ) {
    final List<Map> options = query != ''
        ? searchOptions
            .where(
              (element) =>
                  element['title'].toString().toLowerCase().contains(query),
            )
            .toList()
        : List.empty();
    return options;
  }

  Widget _searchSuggestions(
    BuildContext context,
    List<Map> options,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        //horizontal: 3.0,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      elevation: 8.0,
      child: SizedBox(
        height: options.length * 70,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 10, top: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: options.length,
          itemExtent: 70,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(options[index]['title'].toString()),
              onTap: () {
                searchQuery.value = '';
                controller.text = '';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => options[index]['route'] as Widget,
                    settings: RouteSettings(
                      arguments: options[index]['title'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
