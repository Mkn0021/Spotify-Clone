import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spotify/CustomWidgets/box_switch_tile.dart';
import 'package:spotify/CustomWidgets/gradient_containers.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/CustomWidgets/textinput_dialog.dart';
import 'package:spotify/Helpers/countrycodes.dart';
import 'package:spotify/Helpers/picker.dart';
import 'package:spotify/main.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({super.key});

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  final Box settingsBox = Hive.box('settings');
  final ValueNotifier<bool> includeOrExclude = ValueNotifier<bool>(
    Hive.box('settings').get('includeOrExclude', defaultValue: false) as bool,
  );
  List includedExcludedPaths = Hive.box('settings')
      .get('includedExcludedPaths', defaultValue: []) as List;
  String lang =
      Hive.box('settings').get('lang', defaultValue: 'English') as String;
  bool useProxy =
      Hive.box('settings').get('useProxy', defaultValue: false) as bool;

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
        title:rotated
            ? Text(
          AppLocalizations.of(
            context,
          )!
              .others,
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
              'Others',
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
                  .lang,
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
                  .langSub,
            ),
            onTap: () {},
            trailing: DropdownButton(
              value: lang,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(
                    () {
                      lang = newValue;
                      MyApp.of(context).setLocale(
                        Locale.fromSubtags(
                          languageCode:
                              ConstantCodes.languageCodes[newValue] ?? 'en',
                        ),
                      );
                      Hive.box('settings').put('lang', newValue);
                    },
                  );
                }
              },
              items: ConstantCodes.languageCodes.keys
                  .map<DropdownMenuItem<String>>((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                  ),
                );
              }).toList(),
            ),
            dense: true,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .includeExcludeFolder,
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
                  .includeExcludeFolderSub,
            ),
            dense: true,
            onTap: () {
              final GlobalKey<AnimatedListState> listKey =
                  GlobalKey<AnimatedListState>();
              showModalBottomSheet(
                isDismissible: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return BottomGradientContainer(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    child: AnimatedList(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        10,
                        0,
                        10,
                      ),
                      key: listKey,
                      initialItemCount: includedExcludedPaths.length + 2,
                      itemBuilder: (cntxt, idx, animation) {
                        if (idx == 0) {
                          return ValueListenableBuilder(
                            valueListenable: includeOrExclude,
                            builder: (
                              BuildContext context,
                              bool value,
                              Widget? widget,
                            ) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      ChoiceChip(
                                        label: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!
                                              .excluded,
                                        ),
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2),
                                        labelStyle: TextStyle(
                                          color: !value
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                          fontWeight: !value
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        selected: !value,
                                        onSelected: (bool selected) {
                                          includeOrExclude.value = !selected;
                                          settingsBox.put(
                                            'includeOrExclude',
                                            !selected,
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ChoiceChip(
                                        label: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!
                                              .included,
                                        ),
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2),
                                        labelStyle: TextStyle(
                                          color: value
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                          fontWeight: value
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        selected: value,
                                        onSelected: (bool selected) {
                                          includeOrExclude.value = selected;
                                          settingsBox.put(
                                            'includeOrExclude',
                                            selected,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 5.0,
                                      bottom: 10.0,
                                    ),
                                    child: Text(
                                      value
                                          ? AppLocalizations.of(
                                              context,
                                            )!
                                              .includedDetails
                                          : AppLocalizations.of(
                                              context,
                                            )!
                                              .excludedDetails,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (idx == 1) {
                          return ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.addNew,
                              style: const TextStyle(
                                color: Color(0xffe7e7e7),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            leading: const Icon(
                              CupertinoIcons.add,
                            ),
                            onTap: () async {
                              final String temp = await Picker.selectFolder(
                                context: context,
                              );
                              if (temp.trim() != '' &&
                                  !includedExcludedPaths.contains(temp)) {
                                includedExcludedPaths.add(temp);
                                Hive.box('settings').put(
                                  'includedExcludedPaths',
                                  includedExcludedPaths,
                                );
                                listKey.currentState!.insertItem(
                                  includedExcludedPaths.length,
                                );
                              } else {
                                if (temp.trim() == '') {
                                  Navigator.pop(context);
                                }
                                ShowSnackBar().showSnackBar(
                                  context,
                                  temp.trim() == ''
                                      ? 'No folder selected'
                                      : 'Already added',
                                );
                              }
                            },
                          );
                        }

                        return SizeTransition(
                          sizeFactor: animation,
                          child: ListTile(
                            leading: const Icon(
                              CupertinoIcons.folder,
                            ),
                            title: Text(
                              includedExcludedPaths[idx - 2].toString(),
                              style: const TextStyle(
                                color: Color(0xffe7e7e7),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                CupertinoIcons.clear,
                                size: 15.0,
                              ),
                              tooltip: 'Remove',
                              onPressed: () {
                                includedExcludedPaths.removeAt(idx - 2);
                                Hive.box('settings').put(
                                  'includedExcludedPaths',
                                  includedExcludedPaths,
                                );
                                listKey.currentState!.removeItem(
                                  idx,
                                  (context, animation) => Container(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
                  .minAudioLen,
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
                  .minAudioLenSub,
            ),
            dense: true,
            onTap: () {
              showTextInputDialog(
                context: context,
                title: AppLocalizations.of(
                  context,
                )!
                    .minAudioAlert,
                initialText: (Hive.box('settings')
                        .get('minDuration', defaultValue: 10) as int)
                    .toString(),
                keyboardType: TextInputType.number,
                onSubmitted: (String value) {
                  if (value.trim() == '') {
                    value = '0';
                  }
                  Hive.box('settings').put('minDuration', int.parse(value));
                  Navigator.pop(context);
                },
              );
            },
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .liveSearch,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .liveSearchSub,
            ),
            keyName: 'liveSearch',
            isThreeLine: false,
            defaultValue: true,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .useDown,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .useDownSub,
            ),
            keyName: 'useDown',
            isThreeLine: true,
            defaultValue: true,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .getLyricsOnline,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .getLyricsOnlineSub,
            ),
            keyName: 'getLyricsOnline',
            isThreeLine: true,
            defaultValue: true,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .supportEq,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .supportEqSub,
            ),
            keyName: 'supportEq',
            isThreeLine: true,
            defaultValue: false,
          ),
          const SizedBox(height: 10,),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .stopOnClose,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .stopOnCloseSub,
            ),
            isThreeLine: true,
            keyName: 'stopForegroundService',
            defaultValue: true,
          ),
          // const BoxSwitchTile(
          //   title: Text('Remove Service from foreground when paused'),
          //   subtitle: Text(
          //       "If turned on, you can slide notification when paused to stop the service. But Service can also be stopped by android to release memory. If you don't want android to stop service while paused, turn it off\nDefault: On\n"),
          //   isThreeLine: true,
          //   keyName: 'stopServiceOnPause',
          //   defaultValue: true,
          // ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .checkUpdate,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .checkUpdateSub,
            ),
            keyName: 'checkUpdate',
            isThreeLine: true,
            defaultValue: false,
          ),
          const SizedBox(height: 10,),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .useProxy,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .useProxySub,
            ),
            keyName: 'useProxy',
            defaultValue: false,
            isThreeLine: true,
            onChanged: ({required bool val, required Box box}) {
              useProxy = val;
              setState(
                () {},
              );
            },
          ),
          Visibility(
            visible: useProxy,
            child: ListTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .proxySet,
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
                    .proxySetSub,
              ),
              dense: true,
              trailing: Text(
                '${Hive.box('settings').get("proxyIp")}:${Hive.box('settings').get("proxyPort")}',
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final controller = TextEditingController(
                      text: settingsBox.get('proxyIp').toString(),
                    );
                    final controller2 = TextEditingController(
                      text: settingsBox.get('proxyPort').toString(),
                    );
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
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
                                    .ipAdd,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            autofocus: true,
                            controller: controller,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!
                                    .port,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            autofocus: true,
                            controller: controller2,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.grey[700],
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
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary ==
                                        Colors.white
                                    ? Colors.black
                                    : null,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            settingsBox.put(
                              'proxyIp',
                              controller.text.trim(),
                            );
                            settingsBox.put(
                              'proxyPort',
                              int.parse(
                                controller2.text.trim(),
                              ),
                            );
                            Navigator.pop(context);
                            setState(
                              () {},
                            );
                          },
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!
                                .ok,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .clearCache,
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
                  .clearCacheSub,
            ),
            trailing: SizedBox(
              height: 70.0,
              width: 70.0,
              child: Center(
                child: FutureBuilder(
                  future: File(Hive.box('cache').path!).length(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<int> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        '${((snapshot.data ?? 0) / (1024 * 1024)).toStringAsFixed(2)} MB',
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            dense: true,
            isThreeLine: true,
            onTap: () async {
              Hive.box('cache').clear();
              setState(
                () {},
              );
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .shareLogs,
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
                  .shareLogsSub,
            ),
            onTap: () async {
              final Directory tempDir = await getTemporaryDirectory();
              final files = <XFile>[XFile('${tempDir.path}/logs/logs.txt')];
              Share.shareXFiles(files);
            },
            dense: true,
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
