//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/textinput_dialog.dart';
import 'package:spotify/CustomWidgets/with_bottomNavBar.dart';
import 'package:spotify/Helpers/import_export_playlist.dart';
import 'package:spotify/Helpers/playlist.dart';
import 'package:spotify/Helpers/search_add_playlist.dart';

class ImportPlaylist extends StatelessWidget {
  ImportPlaylist({super.key});

  final Box settingsBox = Hive.box('settings');
  final List playlistNames =
      Hive.box('settings').get('playlistNames')?.toList() as List? ??
          ['Favorite Songs'];

  @override
  Widget build(BuildContext context) {
    return withBottomNavBar(
      selectedIndex: 3,
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.importPlaylist,
                ),
                centerTitle: true,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (cntxt, index) {
                  return ListTile(
                    title: Text(
                      index == 0
                          ? AppLocalizations.of(context)!.importFile
                          : index == 1
                              ? AppLocalizations.of(context)!.importYt
                              : index == 2
                                  ? AppLocalizations.of(
                                      context,
                                    )!
                                      .importJioSaavn
                                  : AppLocalizations.of(
                                      context,
                                    )!
                                      .importResso,
                    ),
                    leading: SizedBox.square(
                      dimension: 50,
                      child: Center(
                        child: Icon(
                          index == 0
                              ? MdiIcons.import
                              : index == 1
                                  ? MdiIcons.youtube
                                  : Icons.music_note_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    onTap: () {
                      index == 0
                          ? importFile(
                              cntxt,
                              playlistNames,
                              settingsBox,
                            )
                          : index == 1
                              ? importYt(
                                  cntxt,
                                  playlistNames,
                                  settingsBox,
                                )
                              : index == 2
                                  ? importJioSaavn(
                                      cntxt,
                                      playlistNames,
                                      settingsBox,
                                    )
                                  : importResso(
                                      cntxt,
                                      playlistNames,
                                      settingsBox,
                                    );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> importFile(
  BuildContext context,
  List playlistNames,
  Box settingsBox,
) async {
  await importFilePlaylist(context, playlistNames);
}

Future<void> importYt(
  BuildContext context,
  List playlistNames,
  Box settingsBox,
) async {
  await showTextInputDialog(
    context: context,
    title: AppLocalizations.of(context)!.enterPlaylistLink,
    initialText: '',
    keyboardType: TextInputType.url,
    onSubmitted: (value) async {
      final String link = value.trim();
      Navigator.pop(context);
      final Map data = await SearchAddPlaylist.addYtPlaylist(link);
      if (data.isNotEmpty) {
        if (data['title'] == '' && data['count'] == 0) {
          Logger.root.severe(
            'Failed to import YT playlist. Data not empty but title or the count is empty.',
          );
          ShowSnackBar().showSnackBar(
            context,
            '${AppLocalizations.of(context)!.failedImport}\n${AppLocalizations.of(context)!.confirmViewable}',
            duration: const Duration(seconds: 3),
          );
        } else {
          playlistNames.add(
            data['title'] == '' ? 'Yt Playlist' : data['title'],
          );
          settingsBox.put(
            'playlistNames',
            playlistNames,
          );

          await SearchAddPlaylist.showProgress(
            data['count'] as int,
            context,
            SearchAddPlaylist.ytSongsAdder(
              data['title'].toString(),
              data['tracks'] as List,
            ),
          );
        }
      } else {
        Logger.root.severe(
          'Failed to import YT playlist. Data is empty.',
        );
        ShowSnackBar().showSnackBar(
          context,
          AppLocalizations.of(context)!.failedImport,
        );
      }
    },
  );
}

Future<void> importResso(
  BuildContext context,
  List playlistNames,
  Box settingsBox,
) async {
  await showTextInputDialog(
    context: context,
    title: AppLocalizations.of(context)!.enterPlaylistLink,
    initialText: '',
    keyboardType: TextInputType.url,
    onSubmitted: (value) async {
      final String link = value.trim();
      Navigator.pop(context);
      final Map data = await SearchAddPlaylist.addRessoPlaylist(link);
      if (data.isNotEmpty) {
        String playName = data['title'].toString();
        while (playlistNames.contains(playName) ||
            await Hive.boxExists(playName)) {
          // ignore: use_string_buffers
          playName = '$playName (1)';
        }
        playlistNames.add(playName);
        settingsBox.put(
          'playlistNames',
          playlistNames,
        );

        await SearchAddPlaylist.showProgress(
          data['count'] as int,
          context,
          SearchAddPlaylist.ressoSongsAdder(
            playName,
            data['tracks'] as List,
          ),
        );
      } else {
        Logger.root.severe(
          'Failed to import Resso playlist. Data is empty.',
        );
        ShowSnackBar().showSnackBar(
          context,
          AppLocalizations.of(context)!.failedImport,
        );
      }
    },
  );
}

Future<void> importJioSaavn(
  BuildContext context,
  List playlistNames,
  Box settingsBox,
) async {
  await showTextInputDialog(
    context: context,
    title: AppLocalizations.of(context)!.enterPlaylistLink,
    initialText: '',
    keyboardType: TextInputType.url,
    onSubmitted: (value) async {
      final String link = value.trim();
      Navigator.pop(context);
      final Map data = await SearchAddPlaylist.addJioSaavnPlaylist(
        link,
      );

      if (data.isNotEmpty) {
        final String playName = data['title'].toString();
        addPlaylist(playName, data['tracks'] as List);
        playlistNames.add(playName);
      } else {
        Logger.root.severe('Failed to import JioSaavn playlist. data is empty');
        ShowSnackBar().showSnackBar(
          context,
          AppLocalizations.of(context)!.failedImport,
        );
      }
    },
  );
}
