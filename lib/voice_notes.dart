// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:voice_notes/language_choice.dart';
import 'package:voice_notes/message.dart';
import 'package:voice_notes/next_page.dart';
import 'package:voice_notes/play_file.dart';
import 'package:voice_notes/record_button.dart';
import 'package:voice_notes/text_card.dart';
import 'package:voice_notes/user_shared_preferences.dart';

class VoiceNotes extends StatefulWidget {
  const VoiceNotes({super.key});

  @override
  State<VoiceNotes> createState() => _VoiceNotesState();
}

class _VoiceNotesState extends State<VoiceNotes> {
  AutoRefreshingAuthClient? client;
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();
  bool isRecording = false;
  String text = '';
  DateTime? startRecordingTime;
  Duration? duration;
  String filePath = '';
  String language = 'ENGLISH';
  List<String> transcribes = [];

  @override
  void initState() {
    requestPermissions();
    loadCredentials();
    transcribes = UserSharedPreferences.getTranscribes() ?? [];
    super.initState();
  }

  @override
  void dispose() {
    client?.close();
    record.dispose();
    super.dispose();
  }

  playAudio() async {
    final filePath = await getFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      audioPlayer.play(DeviceFileSource(filePath));
    } else {
      showInfo("File not found.");
    }
  }

  loadCredentials() async {
    try {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final file = File('$path/voice-translation-403719-60ab941851ec.json');
      final jsonString = await file.readAsString();
      final credentials = ServiceAccountCredentials.fromJson(jsonString);
      client = await clientViaServiceAccount(
          credentials, ['https://www.googleapis.com/auth/cloud-platform']);
    } catch (e) {
      showInfo("Failed to load credientials.");
    }
  }

  deleteExistingFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  requestPermissions() async {
    var storageStatus = await Permission.manageExternalStorage.request();
    var microphoneStatus = await Permission.microphone.request();
    if (!(storageStatus.isGranted && microphoneStatus.isGranted)) {
      showInfo("Required consents were not accepted.");
    }
  }

  startRecording() async {
    if (await record.hasPermission()) {
      final filePath = await getFilePath();
      await deleteExistingFile(filePath);
      setState(() {
        text = '';
      });
      await record.start(
        const RecordConfig(
          sampleRate: 44100,
          encoder: AudioEncoder.flac,
        ),
        path: filePath,
      );
      startRecordingTime = DateTime.now();
    }
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/voice_note.flac';
  }

  stopRecording() async {
    try {
      final path = await record.stop();
      if (path == null || path.isEmpty) {
        showInfo("Recording failed. Path is empty.");
        return;
      }
      final audioFile = File(path);
      if (await audioFile.exists()) {
        final audioBytes = await audioFile.readAsBytes();
        final base64Audio = base64Encode(audioBytes);

        if (client == null) {
          showInfo("Failed to load credientials.");
          return;
        }

        if (startRecordingTime != null) {
          setState(() {
            duration = DateTime.now().difference(startRecordingTime!);
          });
        }

        String languageCode = language == 'POLSKI' ? 'pl-PL' : 'en-US';

        final response = await client!.post(
          Uri.parse('https://speech.googleapis.com/v1/speech:recognize'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'config': {
              'encoding': 'FLAC',
              'sampleRateHertz': 44100,
              'audio_channel_count': 2,
              'languageCode': languageCode,
            },
            'audio': {
              'content': base64Audio,
            },
          }),
        );

        final data = jsonDecode(response.body);

        if (data['results'] != null) {
          final transcript =
              data['results'][0]['alternatives'][0]['transcript'];
          setState(() {
            text = transcript;
            transcribes.insert(0, text);
          });
          await UserSharedPreferences.setTranscribes(transcribes);
        } else {
          showInfo("Unable to transcribe.");
        }
      } else {
        showInfo("Recording failed. File not found.");
      }
    } catch (e) {
      showInfo("Recording failed with error.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LanguageChoice(
            onChanged: (i) => setState(() {
                  language = i;
                }),
            language: language),
        RecordButton(
          isRecording: isRecording,
          onPressed: () {
            startRecording();
            setState(() {
              isRecording = true;
            });
          },
        ),
        Text(isRecording ? '' : "Tap to record",
            style: const TextStyle(fontSize: 18)),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: isRecording
                ? PlayFile(
                    play: false,
                    onPressed: () async {
                      stopRecording();
                      filePath = await getFilePath();
                      setState(() {
                        isRecording = false;
                      });
                    })
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        PlayFile(
                          play: true,
                          onPressed: () => playAudio(),
                        ),
                        if (duration != null) Text(duration.toString())
                      ])),
        TextCard(text: text, title: true),
        const Spacer(),
        const NextPage(),
      ],
    );
  }
}
