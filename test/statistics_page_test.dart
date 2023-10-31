import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizz_app/question_page.dart';
import 'package:quizz_app/statistics_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_utils.dart';

void main() {

  setUpAll((){
    nock.defaultBase = baseURL;
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets("Statistics displays total answer count and correct answer count from SharedPreferences", (tester) async {
    nock.get("/topics").reply(200, jsonTopics);
    SharedPreferences.setMockInitialValues(initialSharedPreferences());

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: StatisticsPage())));
    await tester.pumpAndSettle();

    expect(find.text("Total: 30", skipOffstage: false), findsOneWidget);
    expect(find.text("Correct: 16", skipOffstage: false), findsOneWidget);
  });

  testWidgets("Statistics page displays answer count and correct answer count for all topics from SharedPreferences", (tester) async {
    await tester.binding.setSurfaceSize(const Size(380, 2000)); // Some components offscreen in default size
    WidgetsFlutterBinding.ensureInitialized();
    
    nock.get("/topics").reply(200, jsonTopics);
    SharedPreferences.setMockInitialValues(initialSharedPreferences());

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: StatisticsPage())));
    await tester.pumpAndSettle();

    for (var topic in topics) {
      expect(find.text(topic.title, skipOffstage: false), findsOneWidget);
      expect(find.text("${topic.id+1} | +${topic.id} -1", skipOffstage: false), findsOneWidget);
    }
  });

}