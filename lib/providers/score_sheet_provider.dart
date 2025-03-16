import 'package:cluedo_score_sheet/models/cluedo_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreSheetProvider extends ChangeNotifier {
  CluedoScoreSheet scoreSheet;

  ScoreSheetProvider(this.scoreSheet){
    loadData();
  }

  void addPlayer(BuildContext context, String playerName) {
    List<List<String>> translatedLabels = getNestedRowLabels(context);
    scoreSheet.players.add(PlayerScore(playerName, translatedLabels.expand((list) => list).toList().length, 1));
    notifyListeners();
    _saveData();
  }

  void updateScore(int playerIndex, int flattenedRowIndex, int columnIndex, String value) {
    int nestedRowIndex = 0;
    int itemsInNestedRow = 0;
    for (var row in scoreSheet.players[playerIndex].scores) {
      if (flattenedRowIndex < itemsInNestedRow + row.length) {
        scoreSheet.players[playerIndex].scores[nestedRowIndex][0].value = value;
        notifyListeners();
        _saveData();
        return;
      }
      itemsInNestedRow += row.length;
      nestedRowIndex++;
    }
  }

  void clearColumn(int playerIndex, int columnIndex) {
    for (int i = 0; i < scoreSheet.players[playerIndex].scores.length; i++) {
      scoreSheet.players[playerIndex].scores[i][columnIndex].value = "";
    }
    notifyListeners();
    _saveData();
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(scoreSheet.toJson());
    await prefs.setString('scoreSheetData', jsonData);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('scoreSheetData');
    if (jsonData != null) {
      scoreSheet = CluedoScoreSheet.fromJson(jsonDecode(jsonData));
      notifyListeners();
    }
  }

  List<List<String>> getNestedRowLabels(BuildContext context) {
    return [
      [
        AppLocalizations.of(context)!.missScarlet,
        AppLocalizations.of(context)!.colonelMustard,
        AppLocalizations.of(context)!.mrsWhite,
        AppLocalizations.of(context)!.reverendGreen,
        AppLocalizations.of(context)!.mrsPeacock,
        AppLocalizations.of(context)!.professorPlum,
      ],
      [
        AppLocalizations.of(context)!.kitchen,
        AppLocalizations.of(context)!.ballroom,
        AppLocalizations.of(context)!.conservatory,
        AppLocalizations.of(context)!.diningRoom,
        AppLocalizations.of(context)!.billiardRoom,
        AppLocalizations.of(context)!.library,
        AppLocalizations.of(context)!.lounge,
        AppLocalizations.of(context)!.hall,
        AppLocalizations.of(context)!.study,
      ],
      [
        AppLocalizations.of(context)!.rope,
        AppLocalizations.of(context)!.leadPipe,
        AppLocalizations.of(context)!.knife,
        AppLocalizations.of(context)!.wrench,
        AppLocalizations.of(context)!.candlestick,
        AppLocalizations.of(context)!.revolver,
      ],
    ];
  }
}