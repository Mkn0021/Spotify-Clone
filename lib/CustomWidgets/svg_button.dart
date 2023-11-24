// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatefulWidget {
  final String? unselectedSVG;
  final String selectedSVG;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? iconSize;
  final double? angle;
  final VoidCallback? onTap;

  const SvgIconButton({
    this.unselectedSVG,
    required this.selectedSVG,
    this.selectedColor,
    this.unselectedColor,
    this.iconSize,
    this.angle,
    this.onTap,
    super.key,
  });

  @override
  _SvgIconButtonState createState() => _SvgIconButtonState();
}

class _SvgIconButtonState extends State<SvgIconButton> {
  bool isToggled = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isToggled = !isToggled;
        });

        // Call the onTap callback if provided
        widget.onTap?.call();
      },
      icon: Transform.rotate(
        angle: (widget.angle ?? 0) *
            (3.1416 / 180.0), // Convert degrees to radians
        child: SvgPicture.asset(
          isToggled
              ? widget.selectedSVG
              : widget.unselectedSVG ?? widget.selectedSVG,
          width: widget.iconSize ?? 24,
          height: widget.iconSize ?? 24,
          // ignore: deprecated_member_use
          color: isToggled
              ? widget.selectedColor ?? Colors.white
              : widget.unselectedColor ?? const Color(0xFFB3B3B3),
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final String text;
  final Function(bool)? onSelected;
  final Function? onTap;
  final bool? stateCheck;
  final bool? selected;

  const CustomContainer({
    super.key,
    required this.text,
    this.onSelected,
    this.onTap,
    this.stateCheck,
    this.selected,
  });

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    bool isClicked = widget.selected ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });

        // Call the onTap callback if provided
        widget.onTap?.call();
        widget.onSelected?.call(isClicked);
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.stateCheck ?? isClicked
              ? Theme.of(context).colorScheme.secondary
              : const Color(0xFF2A2A2A),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        margin: const EdgeInsets.only(bottom: 12, right: 10),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.stateCheck ?? isClicked
                ? const Color(0xfe000000)
                : const Color(0xfeffffff),
            fontWeight: FontWeight.w500,
            fontFamily: 'Raleway',
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
