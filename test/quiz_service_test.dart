import 'package:quizz_app/model/question.dart';
import 'package:quizz_app/model/quiz_service.dart';
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

  test('Calling checkAnswer() returns a bool.', () async {

    final topics = await QuizService.getTopics();
    final topic = topics.first;
    final question = await QuizService.getQuestion(topic);

    final answer = await QuizService.checkAnswer(question, 0);

    expect(answer, isA<bool>());
  });
}
