//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole)

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';

class BouncyPlaylistHeaderScrollView extends StatelessWidget {
  final ScrollController scrollController;
  final SliverList sliverList;
  final bool shrinkWrap;
  final List<Widget>? actions;
  final String title;
  final String? subtitle;
  final String? secondarySubtitle;
  final String? imageUrl;
  final bool localImage;
  final String placeholderImage;
  final Function? onPlayTap;
  final Function? onShuffleTap;
  final Color? buttonColor;
  BouncyPlaylistHeaderScrollView({
    super.key,
    required this.scrollController,
    this.shrinkWrap = false,
    required this.sliverList,
    required this.title,
    this.subtitle,
    this.secondarySubtitle,
    this.placeholderImage = 'assets/cover.jpg',
    this.localImage = false,
    this.imageUrl,
    this.actions,
    this.onPlayTap,
    this.onShuffleTap,
    this.buttonColor,
  });

  final ValueNotifier<bool> isTransparent = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final Widget image = imageUrl == null
        ? Image(
            fit: BoxFit.cover,
            image: AssetImage(placeholderImage),
          )
        : localImage
            ? Image(
                image: FileImage(
                  File(
                    imageUrl!,
                  ),
                ),
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
                imageUrl: imageUrl!,
                placeholder: (context, url) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
              );
    final bool rotated =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    final double expandedHeight = rotated
        ? MediaQuery.of(context).size.width * 0.35
        : MediaQuery.of(context).size.width * 0.6;
    final double screenWidth = rotated
        ? MediaQuery.of(context).size.width * 0.3
        : MediaQuery.of(context).size.width * 0.5;

    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: const BouncingScrollPhysics(),
      slivers: [
        AnimatedBuilder(
          animation: scrollController,
          child: FlexibleSpaceBar(
            background: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: image,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 20.0,
                          top: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.lerp(
                            Alignment.topCenter,
                            Alignment.center,
                            0.5,
                          )!,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (subtitle != null && subtitle!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3.0,
                                  ),
                                  child: Text(
                                    subtitle!,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color,
                                    ),
                                  ),
                                ),
                              if (secondarySubtitle != null &&
                                  secondarySubtitle!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3.0,
                                  ),
                                  child: Text(
                                    secondarySubtitle!,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (onShuffleTap != null)
                                    Transform.translate(
                                      offset: const Offset(0.0, 6.0,), 
                                      child: IconButton(
                                        onPressed: () {
                                          onShuffleTap!.call();
                                        },
                                        icon: const Icon(Icons.shuffle_rounded),
                                      ),
                                    ),
                                  if (onPlayTap != null)
                                    Transform.scale(
                                    origin: const Offset(0, -10),
                                      scale:2,
                                      child: SvgIconButton(
                                        selectedSVG: 'assets/play_round.svg',
                                        unselectedSVG: 'assets/pause_round.svg',
                                        selectedColor: buttonColor ??
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        unselectedColor: buttonColor ??
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        iconSize: 40,
                                        onTap: () {
                                          onPlayTap!.call();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          builder: (context, child) {
            if (scrollController.offset.roundToDouble() > expandedHeight - 80) {
              isTransparent.value = false;
            } else {
              isTransparent.value = true;
            }
            return SliverAppBar(
              elevation: 0,
              stretch: true,
              pinned: true,
              centerTitle: true,
              // floating: true,
              backgroundColor: isTransparent.value ? Colors.transparent : null,
              iconTheme: Theme.of(context).iconTheme,
              expandedHeight: expandedHeight,
              actions: actions,
              flexibleSpace: child,
            );
          },
        ),
        sliverList,
      ],
    );
  }
}
