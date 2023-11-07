import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voice_notes/user_shared_preferences.dart';
import 'package:voice_notes/voice_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      title: 'Voice Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(secondary: Color(0xFF16295A)),
          useMaterial3: true,
          fontFamily: "Poppins",
          appBarTheme: AppBarTheme(
              color: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              scrolledUnderElevation: 0.0,
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 22),
              iconTheme: const IconThemeData(color: Colors.white)),
          cardTheme: const CardTheme(
              elevation: 4.0,
              color: Colors.white,
              shadowColor: Color.fromARGB(255, 148, 148, 148)),
          iconTheme: const IconThemeData(color: Colors.white)),
      home: const MyHomePage(title: 'Voice Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
      ),
      body: const VoiceNotes(),
    );
  }
}
