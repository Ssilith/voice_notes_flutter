import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_notes/button_icon.dart';

class TextCard extends StatelessWidget {
  final bool title;
  final String text;
  final Function()? onPressed;
  const TextCard({
    super.key,
    required this.text,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: title ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: Card(
        child: Column(children: [
          if (title)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Text:',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(text),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: title
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                ButtonIcon(
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.copy,
                    onPressed: () {
                      copyToClipboard(text);
                    }),
                if (!title)
                  ButtonIcon(
                    color: Colors.red,
                    icon: Icons.delete,
                    onPressed: onPressed!,
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
