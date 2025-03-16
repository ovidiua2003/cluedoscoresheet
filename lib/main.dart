// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cluedo_model.dart';
import 'providers/score_sheet_provider.dart';
import 'widgets/score_grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for shared_preferences
  final initialScoreSheet = CluedoScoreSheet([
    PlayerScore("Player 1", 12, 1)
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cluedo Score Sheet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scoreSheetProvider = Provider.of<ScoreSheetProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cluedo Score Sheet'),
      ),
      body: SingleChildScrollView( //Make the app scrollable if many players.
        child: Column(
          children: List.generate(
             scoreSheetProvider.scoreSheet.players.length,
            (index) {
              return ScoreGrid(playerIndex: index, rowLabels: scoreSheetProvider.nestedRowLabels);
            },
          ),
        ),
      ),
    );
  }
}