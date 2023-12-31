// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';

class SectionBuilder extends StatelessWidget {
  const SectionBuilder({
    super.key,
    required this.sectionTitle,
    this.fontSize,
    required this.sectionBodyBuilder,
    this.titlePadding = const EdgeInsets.only(left: 16, bottom: 18),
    this.padding = const EdgeInsets.only(top: 36),
  });

  final String sectionTitle;
  final double? fontSize;
  final Widget Function(BuildContext) sectionBodyBuilder;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Padding(
            padding: titlePadding,
            child: Text(sectionTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway',
                    fontStyle: FontStyle.normal,
                    fontSize: fontSize ?? 22.0,
                    overflow: TextOverflow.ellipsis,),
                maxLines: 2,
                textAlign: TextAlign.left,),
          ),
          Builder(builder: sectionBodyBuilder),
        ],
      ),
    );
  }
}

class NewSongContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const NewSongContainer({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      margin: const EdgeInsets.only(right: 16, left: 16),
      child: Row(
        children: [
          // img
          SizedBox(
            width: 142,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // text
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                // description
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xffa7a7a7),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Your SvgIconButton widgets go here
                        // ...

                        SvgIconButton(
                          selectedSVG: 'assets/Heart_outline.svg',
                          unselectedSVG: 'assets/Heart_fill.svg',
                          unselectedColor: Colors.redAccent,
                        ),
                        Expanded(child: SizedBox()),
                        SvgIconButton(
                          selectedSVG: 'assets/play_round.svg',
                          unselectedSVG: 'assets/pause_round.svg',
                          unselectedColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
