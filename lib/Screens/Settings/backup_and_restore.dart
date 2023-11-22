import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:spotify/CustomWidgets/box_switch_tile.dart';
import 'package:spotify/CustomWidgets/gradient_containers.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/Helpers/backup_restore.dart';
import 'package:spotify/Helpers/config.dart';
import 'package:spotify/Helpers/picker.dart';
import 'package:spotify/Services/ext_storage_provider.dart';

class BackupAndRestorePage extends StatefulWidget {
  const BackupAndRestorePage({super.key});

  @override
  State<BackupAndRestorePage> createState() => _BackupAndRestorePageState();
}

class _BackupAndRestorePageState extends State<BackupAndRestorePage> {
  final Box settingsBox = Hive.box('settings');
  final MyTheme currentTheme = GetIt.I<MyTheme>();
  String autoBackPath = Hive.box('settings').get(
    'autoBackPath',
    defaultValue: '/storage/emulated/0/BlackHole/Backups',
  ) as String;

  @override
  Widget build(BuildContext context) {
    final bool rotated =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: rotated
            ? Text(
          AppLocalizations.of(
            context,
          )!
              .backNRest,
          textAlign: TextAlign.center,
          style: const TextStyle(
                  color: Color(0xffeeeeee),
                  fontSize: 18,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
        )
            : const SizedBox(),
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 30, left: 10),
            child: Text(
              'Backup & Restore',
              style: TextStyle(
                color: Color(0xffeeeeee),
                fontSize: 40,
              ),
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .createBack,
              style: const TextStyle(
                color: Color(0xffe7e7e7),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .createBackSub,
            ),
            dense: true,
            onTap: () {
              showModalBottomSheet(
                isDismissible: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  final List playlistNames = Hive.box('settings').get(
                    'playlistNames',
                    defaultValue: ['Favorite Songs'],
                  ) as List;
                  if (!playlistNames.contains('Favorite Songs')) {
                    playlistNames.insert(0, 'Favorite Songs');
                    settingsBox.put(
                      'playlistNames',
                      playlistNames,
                    );
                  }

                  final List<String> persist = [
                    AppLocalizations.of(
                      context,
                    )!
                        .settings,
                    AppLocalizations.of(
                      context,
                    )!
                        .playlists,
                  ];

                  final List<String> checked = [
                    AppLocalizations.of(
                      context,
                    )!
                        .settings,
                    AppLocalizations.of(
                      context,
                    )!
                        .downs,
                    AppLocalizations.of(
                      context,
                    )!
                        .playlists,
                  ];

                  final List<String> items = [
                    AppLocalizations.of(
                      context,
                    )!
                        .settings,
                    AppLocalizations.of(
                      context,
                    )!
                        .playlists,
                    AppLocalizations.of(
                      context,
                    )!
                        .downs,
                    AppLocalizations.of(
                      context,
                    )!
                        .cache,
                  ];

                  final Map<String, List> boxNames = {
                    AppLocalizations.of(
                      context,
                    )!
                        .settings: ['settings'],
                    AppLocalizations.of(
                      context,
                    )!
                        .cache: ['cache'],
                    AppLocalizations.of(
                      context,
                    )!
                        .downs: ['downloads'],
                    AppLocalizations.of(
                      context,
                    )!
                        .playlists: playlistNames,
                  };
                  return StatefulBuilder(
                    builder: (
                      BuildContext context,
                      StateSetter setStt,
                    ) {
                      return BottomGradientContainer(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  0,
                                  10,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, idx) {
                                  return CheckboxListTile(
                                    activeColor: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    checkColor: Theme.of(context)
                                                .colorScheme
                                                .secondary ==
                                            Colors.white
                                        ? Colors.black
                                        : null,
                                    value: checked.contains(
                                      items[idx],
                                    ),
                                    title: Text(
                                      items[idx],
                                    ),
                                    onChanged: persist.contains(items[idx])
                                        ? null
                                        : (bool? value) {
                                            value!
                                                ? checked.add(
                                                    items[idx],
                                                  )
                                                : checked.remove(
                                                    items[idx],
                                                  );
                                            setStt(
                                              () {},
                                            );
                                          },
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary,
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
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                  ),
                                  onPressed: () {
                                    createBackup(
                                      context,
                                      checked,
                                      boxNames,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!
                                        .ok,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .restore,
              style: const TextStyle(
                color: Color(0xffe7e7e7),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .restoreSub,
            ),
            dense: true,
            onTap: () async {
              await restore(context);
              currentTheme.refresh();
            },
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .autoBack,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .autoBackSub,
            ),
            keyName: 'autoBackup',
            defaultValue: false,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .autoBackLocation,
              style: const TextStyle(
                color: Color(0xffe7e7e7),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(autoBackPath),
            trailing: TextButton(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey[700],
              ),
              onPressed: () async {
                autoBackPath = await ExtStorageProvider.getExtStorage(
                      dirName: 'BlackHole/Backups',
                      writeAccess: true,
                    ) ??
                    '/storage/emulated/0/BlackHole/Backups';
                Hive.box('settings').put('autoBackPath', autoBackPath);
                setState(
                  () {},
                );
              },
              child: Text(
                AppLocalizations.of(
                  context,
                )!
                    .reset,
              ),
            ),
            onTap: () async {
              final String temp = await Picker.selectFolder(
                context: context,
                message: AppLocalizations.of(
                  context,
                )!
                    .selectBackLocation,
              );
              if (temp.trim() != '') {
                autoBackPath = temp;
                Hive.box('settings').put('autoBackPath', temp);
                setState(
                  () {},
                );
              } else {
                ShowSnackBar().showSnackBar(
                  context,
                  AppLocalizations.of(
                    context,
                  )!
                      .noFolderSelected,
                );
              }
            },
            dense: true,
          ),
        ],
      ),
    );
  }
}
