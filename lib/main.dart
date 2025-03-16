// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cluedo_model.dart';
import 'providers/score_sheet_provider.dart';
import 'widgets/score_grid.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for shared_preferences
  final initialScoreSheet = CluedoScoreSheet([
    PlayerScore("Player 1", 21, 1)
  ]);

  final scoreSheetProvider = ScoreSheetProvider(initialScoreSheet);
  await scoreSheetProvider.loadData(); // Load saved data

  runApp(
    ChangeNotifierProvider(
      create: (context) => scoreSheetProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ro'),
      ],
      title: 'Cluedo Score Sheet',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
          bodyMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 88, 88, 88),
          ),
          labelLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale _currentLocale = const Locale('en');
  @override
  Widget build(BuildContext context) {
    final scoreSheetProvider = Provider.of<ScoreSheetProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        elevation: 2,
        surfaceTintColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_currentLocale == const Locale('en')) {
                  _currentLocale = const Locale('ro');
                } else {
                  _currentLocale = const Locale('en');
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  MyApp.setLocale(context, _currentLocale);
                });
              });
            },
            icon: Icon(_currentLocale == const Locale('en') ? Icons.flag : Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView( //Make the app scrollable if many players.
        child: Column(
          children: List.generate(
             scoreSheetProvider.scoreSheet.players.length,
            (index) {
              return ScoreGrid(playerIndex: index, rowLabels: scoreSheetProvider.getNestedRowLabels(context));
            },
          ),
        ),
      ),
    );
  }
}