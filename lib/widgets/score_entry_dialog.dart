// lib/widgets/score_entry_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScoreEntryDialog extends StatelessWidget {
  final Function(String) onSelected;

  ScoreEntryDialog({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select Score Entry'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () => onSelected('x'),
          child: _getCellValueWidget('x'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected('y'),
          child: _getCellValueWidget('y'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected('?'),
          child: _getCellValueWidget('?'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected(''),
          child: SvgPicture.asset('assets/trash.svg', width: 36, height: 36),
        ),
      ],
    );
  }

  Widget _getCellValueWidget(String? value) {
    if (value == 'x') {
      return SvgPicture.asset('assets/cross.svg', width: 36, height: 36);
    } else if (value == 'y') {
      return SvgPicture.asset('assets/check-mark.svg', width: 36, height: 36);
    } else if (value == '?') {
      return SvgPicture.asset('assets/question-mark.svg', width: 36, height: 36);
    } else {
      return const SizedBox.shrink(); // Display nothing if value is empty or null
    }
  }
}