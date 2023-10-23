import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizz_app/model/topic.dart';
import 'package:quizz_app/model/question.dart';

class QuizService extends Object {
  static const authority = "dad-quiz-api.deno.dev";

  static Future<List<Topic>> getTopics() async {
    final uri = Uri.https(authority, "topics");
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List parsedList = json.decode(response.body); 
      List<Topic> topicList = parsedList.map((topicMap) =>  Topic.fromJson(topicMap)).toList();
      return topicList;
    } else {
      throw Exception("Failed to load topics");
    }
  }

  static Future<Question> getQuestion(Topic topic) async {
    final uri = Uri.https(authority, topic.questionPath);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final questionMap = json.decode(response.body);
      return Question.fromJson(questionMap);
    } else {
      throw Exception("Failed to load question");
    }
  }

  static Future<bool> checkAnswer(Question question, int answerIndex) async {
    return await checkAnswers(question, [answerIndex]);
  }

  static Future<bool> checkAnswers(Question question, List<int> answerIndexes) async {
    for(var answerIndex in answerIndexes) {
      if (answerIndex < 0 || answerIndex >= question.choices.length) {
        throw Exception("Invalid answer index");
      }
    }

    if (answerIndexes.length != 1) {
      throw Exception("Currently only supporting single answer questions");
    }

    final answer = question.choices[answerIndexes.first];
    print("Answer is: $answer");
    final uri = Uri.https(authority, question.answerPath);
    print("URI is: $uri");
    print("JSON is: ${json.encode({"answer": answer})}");
    final response = await http.post(uri, body: json.encode({"answer": answer}));

    if (response.statusCode == 200) {
      final Map parsedMap = json.decode(response.body);
      return parsedMap['correct'] as bool;
    } else {
      throw Exception("Failed to check answers");
    }
  }
}