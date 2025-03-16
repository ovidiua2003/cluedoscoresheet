class ScoreEntry {
  String value; // "", "X", "✓", "?"
  ScoreEntry({this.value = ""});

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      value: json['value'],
    );
  }
}

class PlayerScore {
  String playerName;
  List<List<ScoreEntry>> scores; // 2D list
  PlayerScore(this.playerName, int numberOfRows, int numberOfColumns)
      : scores = List.generate(
            numberOfRows, (i) => List.generate(numberOfColumns, (j) => ScoreEntry()));

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'scores': scores.map((row) => row.map((entry) => entry.toJson()).toList()).toList(),
    };
  }

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    String playerName = json['playerName'];
    int numberOfRows = (json['scores'] as List).length;
    int numberOfColumns = (json['scores'] as List)[0].length;

    PlayerScore playerScore = PlayerScore(
      playerName,
      numberOfRows,
      numberOfColumns,
    );

    playerScore.scores = (json['scores'] as List)
        .map((row) {
          return (row as List).map((entryJson) {
            return ScoreEntry.fromJson(entryJson);
          }).toList();
        })
        .toList();

    return playerScore;
  }
}

class CluedoScoreSheet {
  List<PlayerScore> players;
  CluedoScoreSheet(this.players);

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
    };
  }

  factory CluedoScoreSheet.fromJson(Map<String, dynamic> json) {
    return CluedoScoreSheet(
      (json['players'] as List).map((playerJson) => PlayerScore.fromJson(playerJson)).toList(),
    );
  }
}