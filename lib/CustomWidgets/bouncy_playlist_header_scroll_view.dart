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
        : MediaQuery.of(context).size.width;
    final double screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: const BouncingScrollPhysics(),
      slivers: [
        AnimatedBuilder(
          animation: scrollController,
          child: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueGrey,
                    Colors.black,
                  ],
                  stops: [0.0, 0.8],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: screenWidth / 1.9,
                        child: Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          child: image,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (secondarySubtitle != null &&
                      secondarySubtitle!.isNotEmpty)
                    Text(
                      secondarySubtitle!,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      ...actions ?? [], // Use the null-aware spread operator
                      const Spacer(),
                      if (onShuffleTap != null)
                        IconButton(
                          onPressed: () {
                            onShuffleTap!.call();
                          },
                          icon: const Icon(Icons.shuffle_rounded),
                        ),
                      if (onPlayTap != null)
                        Transform.scale(
                          scale: 1.5,
                          child: SvgIconButton(
                            selectedSVG: 'assets/play_round.svg',
                            unselectedSVG: 'assets/pause_round.svg',
                            selectedColor: buttonColor ??
                                Theme.of(context).colorScheme.secondary,
                            unselectedColor: buttonColor ??
                                Theme.of(context).colorScheme.secondary,
                            iconSize: 40,
                            onTap: () {
                              onPlayTap!.call();
                            },
                          ),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
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
              //floating: true,
              backgroundColor: isTransparent.value ? Colors.transparent : null,
              iconTheme: Theme.of(context).iconTheme,
              expandedHeight: expandedHeight - 20,
              flexibleSpace: child,
            );
          },
        ),
        sliverList,
      ],
    );
  }
}
