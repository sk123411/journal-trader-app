class JournalEntry {
  final int? id;
  final String date;
  final String bias;
  final String concepts;
  final String mistakes;
  final String imagePath;
  final String result;

  JournalEntry({
    this.id,
    required this.date,
    required this.bias,
    required this.concepts,
    required this.mistakes,
    required this.imagePath,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'bias': bias,
      'concepts': concepts,
      'mistakes': mistakes,
      'imagePath': imagePath,
      'result': result,
    };
  }
}
