import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:spotify/CustomWidgets/box_switch_tile.dart';
import 'package:spotify/CustomWidgets/gradient_containers.dart';
import 'package:spotify/CustomWidgets/snackbar.dart';
import 'package:spotify/Helpers/countrycodes.dart';
import 'package:spotify/Screens/Home/saavn.dart' as home_screen;

class MusicPlaybackPage extends StatefulWidget {
  final Function? callback;
  const MusicPlaybackPage({this.callback});

  @override
  State<MusicPlaybackPage> createState() => _MusicPlaybackPageState();
}

class _MusicPlaybackPageState extends State<MusicPlaybackPage> {
  String streamingMobileQuality = Hive.box('settings')
      .get('streamingQuality', defaultValue: '96 kbps') as String;
  String streamingWifiQuality = Hive.box('settings')
      .get('streamingWifiQuality', defaultValue: '320 kbps') as String;
  String ytQuality =
      Hive.box('settings').get('ytQuality', defaultValue: 'Low') as String;
  String region =
      Hive.box('settings').get('region', defaultValue: 'India') as String;
  List<String> languages = [
    'Hindi',
    'English',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Kannada',
    'Bhojpuri',
    'Malayalam',
    'Urdu',
    'Haryanvi',
    'Rajasthani',
    'Odia',
    'Assamese',
  ];
  List preferredLanguage = Hive.box('settings')
      .get('preferredLanguage', defaultValue: ['Hindi'])?.toList() as List;

  @override
  Widget build(BuildContext context) {
    final bool rotated =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
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
              .musicPlayback,
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
              'Music & Playback',
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
                  .musicLang,
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
                  .musicLangSub,
            ),
            trailing: SizedBox(
              width: 150,
              child: Text(
                preferredLanguage.isEmpty
                    ? 'None'
                    : preferredLanguage.join(', '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            dense: true,
            onTap: () {
              showModalBottomSheet(
                isDismissible: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  final List checked = List.from(preferredLanguage);
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
                                itemCount: languages.length,
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
                                      languages[idx],
                                    ),
                                    title: Text(
                                      languages[idx],
                                    ),
                                    onChanged: (bool? value) {
                                      value!
                                          ? checked.add(languages[idx])
                                          : checked.remove(
                                              languages[idx],
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
                                    setState(
                                      () {
                                        preferredLanguage = checked;
                                        Navigator.pop(context);
                                        Hive.box('settings').put(
                                          'preferredLanguage',
                                          checked,
                                        );
                                        home_screen.fetched = false;
                                        home_screen.preferredLanguage =
                                            preferredLanguage;
                                        widget.callback!();
                                      },
                                    );
                                    if (preferredLanguage.isEmpty) {
                                      ShowSnackBar().showSnackBar(
                                        context,
                                        AppLocalizations.of(
                                          context,
                                        )!
                                            .noLangSelected,
                                      );
                                    }
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
          const SizedBox(height: 8,),
          ListTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .streamQuality,
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
                  .streamQualitySub,
            ),
            onTap: () {},
            trailing: DropdownButton(
              value: streamingMobileQuality,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(
                    () {
                      streamingMobileQuality = newValue;
                      Hive.box('settings').put('streamingQuality', newValue);
                    },
                  );
                }
              },
              items: <String>['96 kbps', '160 kbps', '320 kbps']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
                  .streamWifiQuality,
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
                  .streamWifiQualitySub,
            ),
            onTap: () {},
            trailing: DropdownButton(
              value: streamingWifiQuality,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(
                    () {
                      streamingWifiQuality = newValue;
                      Hive.box('settings')
                          .put('streamingWifiQuality', newValue);
                    },
                  );
                }
              },
              items: <String>['96 kbps', '160 kbps', '320 kbps']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
                  .ytStreamQuality,
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
                  .ytStreamQualitySub,
            ),
            onTap: () {},
            trailing: DropdownButton(
              value: ytQuality,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(
                    () {
                      ytQuality = newValue;
                      Hive.box('settings').put('ytQuality', newValue);
                    },
                  );
                }
              },
              items: <String>['Low', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            dense: true,
          ),
          const SizedBox(
            height: 8,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .loadLast,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .loadLastSub,
            ),
            keyName: 'loadStart',
            defaultValue: true,
          ),
          const SizedBox(
            height: 8,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .resetOnSkip,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .resetOnSkipSub,
            ),
            keyName: 'resetOnSkip',
            defaultValue: false,
          ),
          const SizedBox(
            height: 8,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .enforceRepeat,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .enforceRepeatSub,
            ),
            keyName: 'enforceRepeat',
            defaultValue: false,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .autoplay,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .autoplaySub,
            ),
            keyName: 'autoplay',
            defaultValue: true,
            isThreeLine: true,
          ),
          BoxSwitchTile(
            title: Text(
              AppLocalizations.of(
                context,
              )!
                  .cacheSong,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!
                  .cacheSongSub,
            ),
            keyName: 'cacheSong',
            defaultValue: true,
          ),
        ],
      ),
    );
  }
}

class SpotifyCountry {
  Future<String> changeCountry({required BuildContext context}) async {
    String region =
        Hive.box('settings').get('region', defaultValue: 'India') as String;
    if (!ConstantCodes.localChartCodes.containsKey(region)) {
      region = 'India';
    }

    await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        const Map<String, String> codes = ConstantCodes.localChartCodes;
        final List<String> countries = codes.keys.toList();
        return BottomGradientContainer(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              0,
              10,
              0,
              10,
            ),
            itemCount: countries.length,
            itemBuilder: (context, idx) {
              return ListTileTheme(
                selectedColor: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  title: Text(
                    countries[idx],
                    style: const TextStyle(
                      color: Color(0xffe7e7e7),
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: Radio(
                    value: countries[idx],
                    groupValue: region,
                    onChanged: (value) {
                      Hive.box('settings').put('region', region);
                      Navigator.pop(context);
                    },
                  ),
                  selected: region == countries[idx],
                  onTap: () {
                    Hive.box('settings').put('region', region);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
    return region;
  }
}
