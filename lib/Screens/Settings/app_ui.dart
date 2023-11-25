import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:spotify/CustomWidgets/box_switch_tile.dart';
import 'package:spotify/CustomWidgets/gradient_containers.dart';
import 'package:spotify/CustomWidgets/textinput_dialog.dart';
import 'package:spotify/Screens/Settings/player_gradient.dart';

class AppUIPage extends StatefulWidget {
  final Function? callback;
  const AppUIPage({this.callback});

  @override
  State<AppUIPage> createState() => _AppUIPageState();
}

class _AppUIPageState extends State<AppUIPage> {
  final Box settingsBox = Hive.box('settings');
  List blacklistedHomeSections = Hive.box('settings')
      .get('blacklistedHomeSections', defaultValue: []) as List;
  List miniButtonsOrder = Hive.box('settings').get(
    'miniButtonsOrder',
    defaultValue: ['Like', 'Previous', 'Play/Pause', 'Next', 'Download'],
  ) as List;
  List preferredMiniButtons = Hive.box('settings').get(
    'preferredMiniButtons',
    defaultValue: ['Previous', 'Play/Pause', 'Next'],
  )?.toList() as List;
  List<int> preferredCompactNotificationButtons = Hive.box('settings').get(
    'preferredCompactNotificationButtons',
    defaultValue: [1, 2, 3],
  ) as List<int>;

  @override
  Widget build(BuildContext context) {
  final bool rotated =MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title:rotated
            ? Text(
          AppLocalizations.of(
            context,
          )!
              .ui,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 30, left: 10),
            child: Text(
              'App UI',
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
                  .playerScreenBackground,
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
                  .playerScreenBackgroundSub,
            ),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) =>
                      const PlayerGradientSelection(),
                ),
              );
            },
          ),

          // BoxSwitchTile(
          //   title: Text(
          //     AppLocalizations.of(
          //       context,
          //     )!
          //         .useBlurForNowPlaying,
          //   ),
          //   subtitle: Text(
          //     AppLocalizations.of(
          //       context,
          //     )!
          //         .useBlurForNowPlayingSub,
          //   ),
          //   keyName: 'useBlurForNowPlaying',
          //   defaultValue: true,
          //   isThreeLine: true,
          // ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .useDenseMini,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .useDenseMiniSub,
            ),
            keyName: 'useDenseMini',
            defaultValue: true,
            isThreeLine: false,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .miniButtons,
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
                  .miniButtonsSub,
            ),
            dense: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final List checked = List.from(preferredMiniButtons);
                  final List<String> order = List.from(miniButtonsOrder);
                  return StatefulBuilder(
                    builder: (
                      BuildContext context,
                      StateSetter setStt,
                    ) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        content: SizedBox(
                          width: 500,
                          child: ReorderableListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              10,
                              0,
                              10,
                            ),
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex--;
                              }
                              final temp = order.removeAt(
                                oldIndex,
                              );
                              order.insert(newIndex, temp);
                              setStt(
                                () {},
                              );
                            },
                            header: Center(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!
                                    .changeOrder,
                              ),
                            ),
                            children: order.map((e) {
                              return Row(
                                key: Key(e),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ReorderableDragStartListener(
                                    index: order.indexOf(e),
                                    child: const Icon(
                                      Icons.drag_handle_rounded,
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: CheckboxListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        checkColor: Theme.of(
                                                  context,
                                                ).colorScheme.secondary ==
                                                Colors.white
                                            ? Colors.black
                                            : null,
                                        value: checked.contains(e),
                                        title: Text(e),
                                        onChanged: (bool? value) {
                                          setStt(
                                            () {
                                              value!
                                                  ? checked.add(e)
                                                  : checked.remove(e);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
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
                              setState(
                                () {
                                  final List temp = [];
                                  for (int i = 0; i < order.length; i++) {
                                    if (checked.contains(order[i])) {
                                      temp.add(order[i]);
                                    }
                                  }
                                  preferredMiniButtons = temp;
                                  miniButtonsOrder = order;
                                  Navigator.pop(context);
                                  Hive.box('settings').put(
                                    'preferredMiniButtons',
                                    preferredMiniButtons,
                                  );
                                  Hive.box('settings').put(
                                    'miniButtonsOrder',
                                    order,
                                  );
                                },
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
              );
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .compactNotificationButtons,
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
                  .compactNotificationButtonsSub,
            ),
            dense: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final Set<int> checked = {
                    ...preferredCompactNotificationButtons,
                  };
                  final List<Map> buttons = [
                    {
                      'name': 'Like',
                      'index': 0,
                    },
                    {
                      'name': 'Previous',
                      'index': 1,
                    },
                    {
                      'name': 'Play/Pause',
                      'index': 2,
                    },
                    {
                      'name': 'Next',
                      'index': 3,
                    },
                    {
                      'name': 'Stop',
                      'index': 4,
                    },
                  ];
                  return StatefulBuilder(
                    builder: (
                      BuildContext context,
                      StateSetter setStt,
                    ) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        content: SizedBox(
                          width: 500,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              10,
                              0,
                              10,
                            ),
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .compactNotificationButtonsHeader,
                                ),
                              ),
                              ...buttons.map((value) {
                                return CheckboxListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.only(
                                    left: 16.0,
                                  ),
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  checkColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary ==
                                          Colors.white
                                      ? Colors.black
                                      : null,
                                  value: checked.contains(
                                    value['index'] as int,
                                  ),
                                  title: Text(
                                    value['name'] as String,
                                  ),
                                  onChanged: (bool? isChecked) {
                                    setStt(
                                      () {
                                        if (isChecked!) {
                                          while (checked.length >= 3) {
                                            checked.remove(
                                              checked.first,
                                            );
                                          }

                                          checked.add(
                                            value['index'] as int,
                                          );
                                        } else {
                                          checked.removeWhere(
                                            (int element) =>
                                                element == value['index'],
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
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
                              setState(
                                () {
                                  while (checked.length > 3) {
                                    checked.remove(
                                      checked.first,
                                    );
                                  }
                                  preferredCompactNotificationButtons =
                                      checked.toList()..sort();
                                  Navigator.pop(context);
                                  Hive.box('settings').put(
                                    'preferredCompactNotificationButtons',
                                    preferredCompactNotificationButtons,
                                  );
                                },
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
              );
            },
          ),

          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .blacklistedHomeSections,
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
                  .blacklistedHomeSectionsSub,
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
                      initialItemCount: blacklistedHomeSections.length + 1,
                      itemBuilder: (cntxt, idx, animation) {
                        return (idx == 0)
                            ? ListTile(
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
                                  showTextInputDialog(
                                    context: context,
                                    title: AppLocalizations.of(
                                      context,
                                    )!
                                        .enterText,
                                    keyboardType: TextInputType.text,
                                    onSubmitted: (String value) {
                                      Navigator.pop(context);
                                      blacklistedHomeSections.add(
                                        value.trim().toLowerCase(),
                                      );
                                      Hive.box('settings').put(
                                        'blacklistedHomeSections',
                                        blacklistedHomeSections,
                                      );
                                      listKey.currentState!.insertItem(
                                        blacklistedHomeSections.length,
                                      );
                                    },
                                  );
                                },
                              )
                            : SizeTransition(
                                sizeFactor: animation,
                                child: ListTile(
                                  leading: const Icon(
                                    CupertinoIcons.folder,
                                  ),
                                  title: Text(
                                    blacklistedHomeSections[idx - 1]
                                        .toString(),
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
                                      blacklistedHomeSections
                                          .removeAt(idx - 1);
                                      Hive.box('settings').put(
                                        'blacklistedHomeSections',
                                        blacklistedHomeSections,
                                      );
                                      listKey.currentState!.removeItem(
                                        idx,
                                        (
                                          context,
                                          animation,
                                        ) =>
                                            Container(),
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

          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .showPlaylists,
            ),
            keyName: 'showPlaylist',
            defaultValue: true,
            onChanged: ({required bool val, required Box box}) {
              widget.callback!();
            },
          ),

          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .showLast,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .showLastSub,
            ),
            keyName: 'showRecent',
            defaultValue: false,
            onChanged: ({required bool val, required Box box}) {
              widget.callback!();
            },
          ),
          // BoxSwitchTile(
          //   title: Text(
          //     AppLocalizations.of(
          //       context,
          //     )!
          //         .showHistory,
          //   ),
          //   subtitle: Text(
          //     AppLocalizations.of(
          //       context,
          //     )!
          //         .showHistorySub,
          //   ),
          //   keyName: 'showHistory',
          //   defaultValue: true,
          // ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .enableGesture,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .enableGestureSub,
            ),
            keyName: 'enableGesture',
            defaultValue: true,
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
