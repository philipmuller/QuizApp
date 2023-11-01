import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/main.dart';
import 'test_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  setUpAll((){
    nock.defaultBase = baseURL;
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets("Opening application shows list of topics returned by API.", (tester) async {
    nock.get("/topics").reply(200, jsonTopics);

    await tester.pumpWidget(ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    for (var topic in topics) {
      expect(find.text(topic.title, skipOffstage: false), findsOneWidget);
    }
  });

  testWidgets("Opening application shows generic practice option.", (tester) async {
    nock.get("/topics").reply(200, jsonTopics);

    await tester.pumpWidget(ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text("Generic Practice"), findsOneWidget);
  });

  testWidgets("Tapping on a topic opens a question returned by the API for that topic.", (tester) async {
    nock.get("/topics").reply(200, jsonTopics);

    nock.get(topics.first.questionPath).reply(200, jsonQuestion);

    await tester.pumpWidget(ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text(topics.first.title));
    await tester.pumpAndSettle();

    expect(find.text(question.text), findsOneWidget);
  });

  testWidgets("Tapping on the generic practice option opens a question from the topic with the fewest correct answers returned by the API for that topic.", (tester) async {
    nock.get("/topics").reply(200, jsonTopics);
    nock.get("/topics").reply(200, jsonTopics); // url is requested twice (page load, lowest ranking topics), so we need to reply twice
    nock.get(topics.first.questionPath).reply(200, jsonQuestion);

    SharedPreferences.setMockInitialValues(initialSharedPreferences()); //the fewest correct answers are from the topic with the lowest index

    await tester.pumpWidget(ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Generic Practice", skipOffstage: false));
    await tester.pumpAndSettle();

    expect(find.text(question.text, skipOffstage: false), findsOneWidget);
  });
}
