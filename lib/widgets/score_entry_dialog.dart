// lib/widgets/score_entry_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreEntryDialog extends StatelessWidget {
  final Function(String) onSelected;

  ScoreEntryDialog({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(AppLocalizations.of(context)!.selectScore, style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
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
      return Column(
        children: [
          SvgPicture.asset('assets/cross.svg', width: 36, height: 36),
          Divider(color: const Color.fromARGB(255, 200, 200, 200), thickness: 1, height: 40),
        ],
      );
    } else if (value == 'y') {
      return Column(
        children: [
          SvgPicture.asset('assets/check-mark.svg', width: 36, height: 36),
          Divider(color: const Color.fromARGB(255, 200, 200, 200), thickness: 1, height: 40),
        ],
      );
    } else if (value == '?') {
      return Column(
        children: [
          SvgPicture.asset('assets/question-mark.svg', width: 38, height: 38),
          Divider(color: const Color.fromARGB(255, 200, 200, 200), thickness: 1, height: 40),
        ],
      );
    } else {
      return const SizedBox.shrink(); // Display nothing if value is empty or null
    }
  }
}