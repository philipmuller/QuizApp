import 'package:flutter/material.dart';
import 'package:quizz_app/model/topic.dart';
import 'package:quizz_app/model/quiz_service.dart';
import 'package:quizz_app/model/stats_service.dart';

class StatisticsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var attemptsCount = StatsService.getCount(type: StatType.attemptsCount);
    var correctAnswersCount = StatsService.getCount(type: StatType.correctAnswersCount);
    var topics = QuizService.getTopics();

    return Column(
      children: [
        Text("This is the statistics page"),
        FutureBuilder(future: attemptsCount, builder: attemptsBuilder),
        FutureBuilder(future: correctAnswersCount, builder: correctAnswersBuilder),
        FutureBuilder(future: topics, builder: topicsBuilder),
        TextButton(onPressed: () => StatsService.clearPreferences(), child: const Text("Clear statistics"))
      ]
    );
  }

  Widget attemptsBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    if (snapshot.hasData) {
      return Text("Attempts: ${snapshot.data}");
    } else {
      return const Text("Loading...");
    }
  }

  Widget correctAnswersBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    if (snapshot.hasData) {
      return Text("Correct: ${snapshot.data}");
    } else {
      return const Text("Loading...");
    }
  }

  Widget topicsBuilder(BuildContext context, AsyncSnapshot<List<Topic>> snapshot) {
    if (snapshot.hasData) {
      return Column(
        children: snapshot.data!.map((topic) => topicStatCell(topic)).toList()
      );
    } else {
      return const Text("Loading...");
    }
  }

  Widget topicStatCell(Topic topic) {
    var topicAttemptsCount = StatsService.getCount(type: StatType.attemptsCount, topic: topic);
    var topicCorrectAnswersCount = StatsService.getCount(type: StatType.correctAnswersCount, topic: topic);

    return Container(
      child: Column(
        children: [
          Text(topic.title),
          FutureBuilder(future: topicAttemptsCount, builder: attemptsBuilder),
          FutureBuilder(future: topicCorrectAnswersCount, builder: correctAnswersBuilder),
        ]
      ));
  }
}