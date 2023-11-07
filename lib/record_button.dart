import 'package:flutter/material.dart';
import 'package:voice_notes/button_icon.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final Function() onPressed;
  const RecordButton(
      {super.key, required this.isRecording, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonIcon(
      color:
          isRecording ? Colors.grey : Theme.of(context).colorScheme.secondary,
      icon: Icons.mic,
      size: 100,
      onPressed: onPressed,
    );
  }
}
