import 'dart:convert';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/model/quiz_service.dart';
import 'package:quiz_app/model/topic.dart';
import 'package:quiz_app/model/stats_service.dart';

const baseURL = "https://${QuizService.authority}";

final topics = [
      Topic(id: 1, title: "Hello", questionPath: "/topics/1/questions"),
      Topic(id: 2, title: "This", questionPath: "/topics/2/questions"),
      Topic(id: 3, title: "Is", questionPath: "/topics/3/questions"),
      Topic(id: 4, title: "A", questionPath: "/topics/4/questions"),
      Topic(id: 5, title: "Test", questionPath: "/topics/5/questions"),
    ];

final jsonTopics = jsonEncode(topics);

final question = Question(
      id: 1,
      text: "What is the answer?",
      choices: ["A", "B", "C", "D"],
      answerPath: "/topics/1/questions/1/answers",
    );

final jsonQuestion = jsonEncode(question);

String jsonQuestionAnswer(int idx) => json.encode({"answer": question.choices[idx]});

final jsonQuestionAnswerCorrect = jsonEncode({"correct": true});
final jsonQuestionAnswerIncorrect = jsonEncode({"correct": false});

Map<String, Object> initialSharedPreferences() {
  var prefs = <String, Object>{};
  prefs[StatType.attemptsCount.name] = 30;
  prefs[StatType.correctAnswersCount.name] = 16;

  for (var topic in topics) {
    prefs["${StatType.attemptsCount.name}-${topic.id}"] = topic.id+1;
    prefs["${StatType.correctAnswersCount.name}-${topic.id}"] = topic.id;
  }

  return prefs;
}