//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:spotify/Screens/YouTube/youtube_search.dart';


class SearchBar extends StatefulWidget {
  final bool isYt;
  final Widget body;
  final bool autofocus;
  final bool liveSearch;
  final bool showClose;
  final Widget? leading;
  final String? hintText;
  final TextEditingController controller;
  final Function(String)? onQueryChanged;
  final Function()? onQueryCleared;
  final Function(String) onSubmitted;

  const SearchBar({
    super.key,
    this.leading,
    this.hintText,
    this.showClose = true,
    this.autofocus = false,
    this.onQueryChanged,
    this.onQueryCleared,
    required this.body,
    required this.isYt,
    required this.controller,
    required this.liveSearch,
    required this.onSubmitted,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String tempQuery = '';
  String query = '';
  final ValueNotifier<bool> hide = ValueNotifier<bool>(true);
  final ValueNotifier<List> suggestionsList = ValueNotifier<List>([]);

  @override
  void dispose() {
    super.dispose();
    hide.dispose();
    suggestionsList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.body,
        ValueListenableBuilder(
          valueListenable: hide,
          builder: (
            BuildContext context,
            bool hidden,
            Widget? child,
          ) {
            return Visibility(
              visible: !hidden,
              child: GestureDetector(
                onTap: () {
                  hide.value = true;
                },
              ),
            );
          },
        ),
        Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              elevation: 8.0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                height: 52.0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        style: const TextStyle(
                          color: Colors.black87,
                          backgroundColor: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Raleway',
                          fontStyle: FontStyle.normal,
                          fontSize: 17.0,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          hintText: 'Artist, Song, or podcast',
                          hintStyle: TextStyle(
                            color: Color(0xff535353),
                          ),
                        ),
                        autofocus: widget.autofocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (val) {
                          tempQuery = val;
                          if (val.trim() == '') {
                            hide.value = true;
                            suggestionsList.value = [];
                            if (widget.onQueryCleared != null) {
                              widget.onQueryCleared!.call();
                            }
                          }
                          if (widget.liveSearch && val.trim() != '') {
                            hide.value = false;
                            Future.delayed(
                              const Duration(
                                milliseconds: 600,
                              ),
                              () async {
                                if (tempQuery == val &&
                                    tempQuery.trim() != '' &&
                                    tempQuery != query) {
                                  query = tempQuery;
                                  suggestionsList.value =
                                      await widget.onQueryChanged!(tempQuery)
                                          as List;
                                }
                              },
                            );
                          }
                        },
                        onSubmitted: (submittedQuery) {
                          if (!hide.value) hide.value = true;
                          if (submittedQuery.trim() != '') {
                            query = submittedQuery.trim();
                            widget.onSubmitted(submittedQuery);
                            List searchQueries = Hive.box('settings')
                                .get('search', defaultValue: []) as List;
                            if (searchQueries.contains(query)) {
                              searchQueries.remove(query);
                            }
                            searchQueries.insert(0, query);
                            if (searchQueries.length > 10) {
                              searchQueries = searchQueries.sublist(0, 10);
                            }
                            Hive.box('settings').put('search', searchQueries);
                          }
                        },
                      ),
                    ),
                    if (widget.showClose)
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xff191919),
                        ),
                        onPressed: () {
                          widget.controller.text = '';
                          hide.value = true;
                          suggestionsList.value = [];
                          if (widget.onQueryCleared != null) {
                            widget.onQueryCleared!.call();
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            if (!widget.isYt)
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        style: const TextStyle(color: Colors.grey),
                        text: AppLocalizations.of(context)!.cantFind,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.searchYt,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => YouTubeSearchPage(
                                  query: query.isNotEmpty
                                      ? query
                                      : widget.controller.text,
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ValueListenableBuilder(
              valueListenable: hide,
              builder: (
                BuildContext context,
                bool hidden,
                Widget? child,
              ) {
                return Visibility(
                  visible: !hidden,
                  child: ValueListenableBuilder(
                    valueListenable: suggestionsList,
                    builder: (
                      BuildContext context,
                      List suggestedList,
                      Widget? child,
                    ) {
                      return suggestedList.isEmpty
                          ? const SizedBox()
                          : Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                              ),
                              elevation: 8.0,
                              child: SizedBox(
                                height: min(
                                  MediaQuery.of(context).size.height / 1.75,
                                  70.0 * suggestedList.length,
                                ),
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  shrinkWrap: true,
                                  itemExtent: 70.0,
                                  itemCount: suggestedList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading:
                                          const Icon(CupertinoIcons.search),
                                      title: Text(
                                        suggestedList[index].toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        widget.onSubmitted(
                                          suggestedList[index].toString(),
                                        );
                                        hide.value = true;
                                        List searchQueries =
                                            Hive.box('settings').get(
                                          'search',
                                          defaultValue: [],
                                        ) as List;
                                        if (searchQueries.contains(
                                          suggestedList[index]
                                              .toString()
                                              .trim(),
                                        )) {
                                          searchQueries.remove(
                                            suggestedList[index]
                                                .toString()
                                                .trim(),
                                          );
                                        }
                                        searchQueries.insert(
                                          0,
                                          suggestedList[index]
                                              .toString()
                                              .trim(),
                                        );
                                        if (searchQueries.length > 10) {
                                          searchQueries =
                                              searchQueries.sublist(0, 10);
                                        }
                                        Hive.box('settings')
                                            .put('search', searchQueries);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
