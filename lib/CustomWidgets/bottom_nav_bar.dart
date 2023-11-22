import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarIcon extends StatelessWidget {
  final String selectedIcon;
  final String? unselectedIcon;
  final double? iconSize;
  final Color? iconColor;
  final bool indexChecker;

  const BottomNavBarIcon({super.key, 
    required this.selectedIcon,
    this.unselectedIcon,
    this.iconSize,
    this.iconColor,
    required this.indexChecker,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      indexChecker ? selectedIcon : unselectedIcon?? selectedIcon ,
      width: iconSize?? 30,
      height: iconSize?? 30,
      // ignore: deprecated_member_use
      color: indexChecker ? iconColor?? Colors.white : const Color(0xFFB3B3B3),
    );
  }
}
