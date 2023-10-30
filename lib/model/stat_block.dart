class StatBlock {
  final String? title;
  final int attempts;
  final int correctAnswers;
  int get incorrectAnswers => attempts - correctAnswers;

  StatBlock({this.title, required this.attempts, required this.correctAnswers});
}