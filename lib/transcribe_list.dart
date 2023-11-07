import 'package:flutter/material.dart';
import 'package:voice_notes/text_card.dart';
import 'package:voice_notes/user_shared_preferences.dart';

class TranscribeList extends StatefulWidget {
  const TranscribeList({super.key});

  @override
  State<TranscribeList> createState() => _TranscribeListState();
}

class _TranscribeListState extends State<TranscribeList> {
  List<String> transcribes = [];

  @override
  void initState() {
    transcribes = UserSharedPreferences.getTranscribes() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Transcribes'),
      ),
      body: ListView.builder(
        itemCount: transcribes.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextCard(
              text: transcribes[index],
              title: false,
              onPressed: () async {
                setState(() {
                  transcribes.remove(transcribes[index]);
                });
                await UserSharedPreferences.setTranscribes(transcribes);
              },
            ),
          );
        },
      ),
    );
  }
}
