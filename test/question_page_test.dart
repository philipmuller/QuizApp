import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizz_app/question_page.dart';
import 'test_utils.dart';

void main() {

  setUpAll((){
    nock.defaultBase = baseURL;
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets("Question page displays question provided by API", (tester) async {
    nock.get(topics.first.questionPath).reply(200, jsonQuestion);

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: QuestionPage(topic: topics.first))));
    await tester.pumpAndSettle();

    expect(find.text(question.text, skipOffstage: false), findsOneWidget);
  });

  testWidgets("Question page displays options provided by API", (tester) async {
    nock.get(topics.first.questionPath).reply(200, jsonQuestion);

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: QuestionPage(topic: topics.first))));
    await tester.pumpAndSettle();

    for (var choice in question.choices) {
      expect(find.text(choice, skipOffstage: false), findsOneWidget);
    }
  });

  testWidgets("Selecting correct (API checked) answer displays continue button.", (tester) async {
    await tester.binding.setSurfaceSize(const Size(380, 820)); // Button is offscreen in default size

    nock.get(topics.first.questionPath).reply(200, jsonQuestion);
    nock.post(question.answerPath, jsonQuestionAnswer(0)).reply(200, jsonQuestionAnswerCorrect);

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: QuestionPage(topic: topics.first))));
    await tester.pumpAndSettle();
    await tester.tap(find.text(question.choices.first, skipOffstage: false));
    await tester.pumpAndSettle();

    expect(find.text("Continue", skipOffstage: false), findsOneWidget);
  });

  testWidgets("Selecting incorrect (API checked) answer displays Try Again message.", (tester) async {
    await tester.binding.setSurfaceSize(const Size(380, 820)); // Warning is offscreen in default size

    nock.get(topics.first.questionPath).reply(200, jsonQuestion);
    nock.post(question.answerPath, jsonQuestionAnswer(0)).reply(200, jsonQuestionAnswerIncorrect);

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: QuestionPage(topic: topics.first))));
    await tester.pumpAndSettle();
    await tester.tap(find.text(question.choices.first, skipOffstage: false));
    await tester.pumpAndSettle();

    expect(find.text("Try Again", skipOffstage: false), findsOneWidget);
  });
}
