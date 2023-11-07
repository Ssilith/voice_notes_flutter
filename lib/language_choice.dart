import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class LanguageChoice extends StatelessWidget {
  final Function(String) onChanged;
  final String language;
  const LanguageChoice(
      {super.key, required this.onChanged, required this.language});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedToggleSwitch<String>.size(
        indicatorColor: Theme.of(context).colorScheme.secondary,
        borderColor: Theme.of(context).colorScheme.secondary,
        indicatorSize: Size.fromWidth(size.width * 0.46),
        current: language,
        values: const ["ENGLISH", "POLSKI"],
        iconBuilder: (value, size) {
          Color color = language == value ? Colors.white : Colors.black;
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14, color: color),
                textAlign: TextAlign.center,
              ));
        },
        onChanged: onChanged,
      ),
    );
  }
}
