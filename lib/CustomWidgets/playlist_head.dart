//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Services/player_service.dart';

class PlaylistHead extends StatelessWidget {
  final String title;
  final List songsList;
  final bool offline;
  final bool fromDownloads;
  const PlaylistHead({
    super.key,
    required this.title,
    required this.songsList,
    required this.fromDownloads,
    required this.offline,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 13),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${songsList.length} ${AppLocalizations.of(
              context,
            )!.songs}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0XFFA7A7A7),
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Spacer(),
              SvgIconButton(
                selectedSVG: 'assets/shuffle.svg',
                selectedColor: const Color(0xffe7e7e7),
                unselectedColor: const Color(0xffe7e7e7),
                onTap: () {
                  PlayerInvoke.init(
                    songsList: songsList,
                    index: 0,
                    isOffline: offline,
                    fromDownloads: fromDownloads,
                    recommend: false,
                    shuffle: true,
                  );
                },
              ),
              Transform.scale(
                scale: 1.5,
                child: SvgIconButton(
                  selectedSVG: 'assets/play_round.svg',
                  unselectedSVG: 'assets/pause_round.svg',
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  unselectedColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 40,
                  onTap: () {
                    PlayerInvoke.init(
                      songsList: songsList,
                      index: 0,
                      isOffline: offline,
                      fromDownloads: fromDownloads,
                      recommend: false,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
