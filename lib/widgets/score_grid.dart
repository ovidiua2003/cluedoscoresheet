// lib/widgets/score_grid.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/score_sheet_provider.dart';
import 'score_cell.dart';

class ScoreGrid extends StatelessWidget {
  final int playerIndex;
  final List<List<String>> rowLabels; // Accept a nested list

  ScoreGrid({required this.playerIndex, required this.rowLabels}); // Update constructor

  void _clearColumnDialog(BuildContext context, int playerIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Column?'),
          content: Text('Are you sure you want to clear this column?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear'),
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
              Row(
                children: [
                  SizedBox( // Fixed width for labels column
                    width: 200, // Adjust width as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(flattenedLabels[rowIndex]),
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
              if (delimiterIndices.contains(rowIndex)) Divider(),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _clearColumnDialog(context, playerIndex),
          child: Text('Clear Column'),
        ),
      ],
    );
  }
}