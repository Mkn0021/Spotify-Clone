import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class BoxSwitchTile extends StatelessWidget {
  const BoxSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.keyName,
    required this.defaultValue,
    this.isThreeLine,
    this.onChanged,
  });

  final Text title;
  final Text? subtitle;
  final String keyName;
  final bool defaultValue;
  final bool? isThreeLine;
  final Function({required bool val, required Box box})? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (BuildContext context, Box box, Widget? widget) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: DefaultTextStyle(
            style: const TextStyle(
              color: Color(0xffe7e7e7),
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
            ),
            child: title,
          ),
          subtitle: subtitle,
          isThreeLine: isThreeLine ?? false,
          dense: true,
          trailing: CupertinoSwitch(
            activeColor: const Color(0xFF366930),
            trackColor: const Color(0xFF313630),
            value: box.get(keyName, defaultValue: defaultValue) as bool? ??
                defaultValue,
            onChanged: (val) {
              box.put(keyName, val);
              onChanged?.call(val: val, box: box);
            },
          ),
        );
      },
    );
  }
}
