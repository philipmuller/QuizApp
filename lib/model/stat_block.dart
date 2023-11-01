import 'package:quiz_app/model/topic.dart';

class StatBlock {
  final Topic? topic;
  final int attempts;
  final int correctAnswers;
  int get incorrectAnswers => attempts - correctAnswers;

  StatBlock({this.topic, required this.attempts, required this.correctAnswers});
}