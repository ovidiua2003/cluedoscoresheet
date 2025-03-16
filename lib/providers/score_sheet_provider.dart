import 'package:cluedo_score_sheet/models/cluedo_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScoreSheetProvider extends ChangeNotifier {
  CluedoScoreSheet scoreSheet;
  List<List<String>> nestedRowLabels = [
    ["Miss Scarlet", "Colonel Mustard", "Mrs. White", "Reverend Green", "Mrs. Peacock", "Professor Plum"],
    ["Kitchen", "Ballroom", "Conservatory", "Dining Room", "Billiard Room", "Library", "Lounge", "Hall", "Study"],
    ["Rope", "Lead Pipe", "Knife", "Wrench", "Candlestick", "Revolver"]
  ];

  ScoreSheetProvider(this.scoreSheet){
    loadData();
  }

  void addPlayer(String playerName) {
    scoreSheet.players.add(PlayerScore(playerName, nestedRowLabels.expand((list) => list).toList().length, 1));
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

  // Add toJson and fromJson to CluedoScoreSheet and PlayerScore classes.
}