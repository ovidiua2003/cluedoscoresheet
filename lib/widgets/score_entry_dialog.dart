// lib/widgets/score_entry_dialog.dart

import 'package:flutter/material.dart';

class ScoreEntryDialog extends StatelessWidget {
  final Function(String) onSelected;

  ScoreEntryDialog({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select Score Entry'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () => onSelected('X'),
          child: Text('X'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected('✓'),
          child: Text('✓'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected('?'),
          child: Text('?'),
        ),
        SimpleDialogOption(
          onPressed: () => onSelected(''),
          child: Text('Clear'),
        ),
      ],
    );
  }
}