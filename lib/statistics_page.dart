import 'package:flutter/material.dart';
import 'package:quizz_app/model/topic.dart';
import 'package:quizz_app/model/quiz_service.dart';
import 'package:quizz_app/model/stats_service.dart';
import 'package:pie_chart/pie_chart.dart';

class StatBundle {
  final int attemptsCount;
  final int correctAnswersCount;

  StatBundle(this.attemptsCount, this.correctAnswersCount);
}

class StatisticsPage extends StatelessWidget {

  Future<StatBundle> getStats({Topic? topic}) async {
    var attemptsCount = await StatsService.getCount(type: StatType.attemptsCount, topic: topic);
    var correctAnswersCount = await StatsService.getCount(type: StatType.correctAnswersCount, topic: topic);

    return StatBundle(attemptsCount, correctAnswersCount);
  }

  @override
  Widget build(BuildContext context) {
    var global = getStats();
    var topics = QuizService.getTopics();

    return FutureBuilder(future: Future.wait([global, topics]), builder: statsBuilder);
  }

  Widget statsBuilder(BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
    if (snapshot.hasData) {
      final statBundle = snapshot.data![0] as StatBundle;
      final topics = snapshot.data![1] as List<Topic>;

      final mediaQuery = MediaQuery.of(context);

      final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: (mediaQuery.size.width / 2.0),
        mainAxisExtent: (mediaQuery.size.width / 2.0),
        mainAxisSpacing: 10.0, 
        crossAxisSpacing: 10.0, 
        childAspectRatio: 1.0);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20), 
        child: CustomScrollView(slivers: [
        SliverList(delegate: SliverChildListDelegate([
          statCell(context, statBundle, true),
        ])),
        SliverPadding(padding: EdgeInsets.only(top: 20), sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) => topicStatCell(context, topics[index]), childCount: topics.length), 
          gridDelegate: gridDelegate),)
        
      ]));
    } else {
      return const Text("Loading...");
    }
  }

  Widget statCell(BuildContext context, StatBundle stats, bool expanded) {
    
    final attemptsCount = stats.attemptsCount;
    final correctAnswersCount = stats.correctAnswersCount;

    final noAttempts = attemptsCount == 0;

    final percentage = noAttempts ? 0 : ((correctAnswersCount/attemptsCount)*100).round();
    final incorrectAnswersCount = attemptsCount - correctAnswersCount;

    final dataMap = (!noAttempts) ? {
      "Correct": correctAnswersCount.toDouble(),
      "Incorrect": incorrectAnswersCount.toDouble()
    } : {
      "Incorrect": 1.0
    };

    return Opacity(opacity: noAttempts ? 0.4 : 1.0, child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
        ),
      padding: EdgeInsets.all(25),
      child: Flex(direction: expanded ? Axis.horizontal : Axis.vertical, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          chart(context, noAttempts ? "--" : "$percentage%", dataMap, expanded),
          Spacer(flex: 1),
          Padding(padding: EdgeInsets.only(left: expanded ? 25 : 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
            children: expanded ? [
              Text("Total: $attemptsCount", style: Theme.of(context).textTheme.bodyLarge),
              Text("Correct: $correctAnswersCount", style: Theme.of(context).textTheme.bodyLarge),
              Text("Incorrect: $incorrectAnswersCount", style: Theme.of(context).textTheme.bodyLarge),
            ] : [
              Text("T: $attemptsCount, C: $correctAnswersCount, I: $incorrectAnswersCount", style: Theme.of(context).textTheme.bodySmall)
            ]
          ))
        ]
      )
    ));
  }

  Widget chart(BuildContext context, String centerText, Map<String, double> dataMap, bool expanded) {
    return Expanded(flex: 15, child: PieChart(
            chartType: ChartType.ring,
            ringStrokeWidth: expanded ? 20 : 10,
            centerText: centerText,
            initialAngleInDegree: -90,
            colorList: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.inversePrimary],
            centerTextStyle: expanded ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall,
            legendOptions: LegendOptions(showLegends: false), 
            chartValuesOptions: ChartValuesOptions(showChartValues: false, showChartValueBackground: false), 
            dataMap: dataMap));
  }

  Widget topicStatCell(BuildContext context, Topic topic) {
    var localStats = getStats(topic: topic);

    return Column(children: [
      Text(topic.title, style: Theme.of(context).textTheme.labelLarge, overflow: TextOverflow.ellipsis,),
      Expanded(flex: 1, child: FutureBuilder(future: localStats, builder: topicStatsBuilder))
      ]);
  }

  Widget topicStatsBuilder(BuildContext context, AsyncSnapshot<StatBundle> snapshot) {
    if (snapshot.hasData) {
      return statCell(context, snapshot.data!, false);
    } else {
      return const Text("Loading...");
    }
  }
}