import 'package:flutter/material.dart';
import 'package:voice_notes/button_icon.dart';
import 'package:voice_notes/transcribe_list.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonIcon(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TranscribeList()));
              }),
        ),
      ],
    );
  }
}
