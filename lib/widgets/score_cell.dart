// lib/widgets/score_cell.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          border: Border.all(color: const Color.fromARGB(255, 200, 200, 200)),
          color: Colors.white
        ),
        alignment: Alignment.center,
        child: _getCellValueWidget(scoreEntry.value),
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

  Widget _getCellValueWidget(String? value) {
    if (value == 'x') {
      return SvgPicture.asset('assets/cross.svg', width: 24, height: 24);
    } else if (value == 'y') {
      return SvgPicture.asset('assets/check-mark.svg', width: 24, height: 24);
    } else if (value == '?') {
      return SvgPicture.asset('assets/question-mark.svg', width: 24, height: 24);
    } else {
      return const SizedBox.shrink(); // Display nothing if value is empty or null
    }
  }
}