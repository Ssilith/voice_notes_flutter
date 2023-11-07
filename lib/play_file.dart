import 'package:flutter/material.dart';
import 'package:voice_notes/button_icon.dart';

class PlayFile extends StatelessWidget {
  final Function() onPressed;
  final bool play;
  const PlayFile({super.key, required this.onPressed, required this.play});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ButtonIcon(
            color: Colors.red,
            icon: play ? Icons.play_arrow : Icons.stop,
            onPressed: onPressed),
        const SizedBox(width: 10),
        Text(
          play ? 'Tap to play' : 'Tap to stop',
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
