import 'package:quizz_app/model/question.dart';
import 'package:quizz_app/model/quiz-service.dart';
import 'package:quizz_app/model/topic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Calling getTopics() returns topics.', () async {
    expect(await QuizService.getTopics(), isA<List<Topic>>());
  });

  test('Calling getQuestion() returns a question.', () async {

    final topics = await QuizService.getTopics();
    final topic = topics.first;
    print(topic.toString());
    final question = await QuizService.getQuestion(topic);

    expect(question, isA<Question>());
  });
}
