// lib/widgets/score_grid.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/score_sheet_provider.dart';
import 'score_cell.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreGrid extends StatelessWidget {
  final int playerIndex;
  final List<List<String>> rowLabels; // Accept a nested list
  final Map<String, Color> rowLabelColors = {
    "characters": Colors.amber[100]!,
    "rooms": Colors.lightGreen[100]!,
    "weapons": Colors.lightBlue[100]!,
  };
  final Map<String, Color> rowDividerColors = {
    "characters": const Color.fromARGB(255, 199, 153, 13),
    "rooms": const Color.fromARGB(255, 92, 121, 58),
    "weapons": const Color.fromARGB(255, 52, 105, 129),
  };

  ScoreGrid({required this.playerIndex, required this.rowLabels}); // Update constructor

  void _clearColumnDialog(BuildContext context, int playerIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearAll),
          content: Text(AppLocalizations.of(context)!.clearColumnContent),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.clear),
              onPressed: () {
                final scoreSheetProvider = Provider.of<ScoreSheetProvider>(context, listen: false);
                //Get the first column index.
                scoreSheetProvider.clearColumn(playerIndex, 0); //Clear the first column.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreSheetProvider = Provider.of<ScoreSheetProvider>(context);
    final playerScore = scoreSheetProvider.scoreSheet.players[playerIndex];
    List<String> flattenedLabels = rowLabels.expand((list) => list).toList();
    List<int> delimiterIndices = [];
    int count = 0;
    for (List<String> list in rowLabels){
      count += list.length;
      delimiterIndices.add(count -1);
    }
    delimiterIndices.removeLast();

    return Column(
      children: [
        ...List.generate(
          playerScore.scores.length,
          (rowIndex) => Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                color: _getRowLabelColor(rowIndex),
                child: Row(
                  children: [
                    SizedBox( // Fixed width for labels column
                      width: 300, // Adjust width as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          flattenedLabels[rowIndex], 
                          style: Theme.of(context).textTheme.displayLarge
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Row(
                        children: List.generate(
                          1, // single column now
                          (columnIndex) => Expanded(
                            child: ScoreCell(
                              playerIndex: playerIndex,
                              rowIndex: rowIndex,
                              columnIndex: columnIndex,
                              scoreEntry: playerScore.scores[rowIndex][columnIndex],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (delimiterIndices.contains(rowIndex)) 
                Divider(thickness: 5, height: 5, color: Colors.black) 
              else 
                Divider(height:1, color: _getDividerColor(rowIndex))
            ],
          ),
        ),
        SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _clearColumnDialog(context, playerIndex),
          child: Text(AppLocalizations.of(context)!.clearAll),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Color _getRowLabelColor(int rowIndex) {
    if (rowIndex < 6) {
      return rowLabelColors["characters"]!; // Characters
    } else if (rowIndex < 15) {
      return rowLabelColors["rooms"]!; // Rooms
    } else {
      return rowLabelColors["weapons"]!; // Weapons
    }
  }

  Color _getDividerColor(int rowIndex) {
    if (rowIndex < 6) {
      return rowDividerColors["characters"]!; // Characters
    } else if (rowIndex < 15) {
      return rowDividerColors["rooms"]!; // Rooms
    } else {
      return rowDividerColors["weapons"]!; // Weapons
    }
  }
}