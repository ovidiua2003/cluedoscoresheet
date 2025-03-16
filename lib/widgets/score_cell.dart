// lib/widgets/score_cell.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cluedo_model.dart';
import '../providers/score_sheet_provider.dart';
import 'score_entry_dialog.dart';

class ScoreCell extends StatelessWidget {
  final int playerIndex;
  final int rowIndex;
  final int columnIndex;
  final ScoreEntry scoreEntry;

  ScoreCell({
    required this.playerIndex,
    required this.rowIndex,
    required this.columnIndex,
    required this.scoreEntry,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showScoreEntryDialog(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        alignment: Alignment.center,
        child: Text(
          scoreEntry.value,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void _showScoreEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScoreEntryDialog(
          onSelected: (String value) {
            final scoreSheetProvider = Provider.of<ScoreSheetProvider>(context, listen: false);
            scoreSheetProvider.updateScore(playerIndex, rowIndex, columnIndex, value);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}