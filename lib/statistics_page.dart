import 'package:flutter/material.dart';
import 'package:quizz_app/model/stat_block.dart';
import 'package:quizz_app/model/stats_service.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var stats = StatsService.getAllStats();

    return FutureBuilder(future: stats, builder: statsBuilder);
  }

  Widget statsBuilder(BuildContext context, AsyncSnapshot<List<StatBlock>> snapshot) {
    if (snapshot.hasData) {
      final stats = snapshot.data!;
      final mediaQuery = MediaQuery.of(context);

      final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: (mediaQuery.size.width / 2.0),
        mainAxisExtent: (mediaQuery.size.width / 2.0),
        mainAxisSpacing: 10.0, 
        crossAxisSpacing: 10.0, 
        childAspectRatio: 1.0);

      if (stats.isNotEmpty) {
        return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: CustomScrollView(slivers: [
          SliverList(delegate: SliverChildListDelegate([statCell(context, stats[0], true)])),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20), 
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) => topicStatCell(context, stats[index+1]), childCount: stats.length - 1), 
              gridDelegate: gridDelegate
            )
          ),
        ]));
        
      } else {
        return const Text("No topics");
      }
      
    } else {
      return const Text("Loading...");
    }
  }

  Widget statCell(BuildContext context, StatBlock stats, bool expanded) {
    
    final attemptsCount = stats.attempts;
    final correctAnswersCount = stats.correctAnswers;

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
              Text("$attemptsCount | +$correctAnswersCount -$incorrectAnswersCount", style: Theme.of(context).textTheme.labelMedium)
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

  Widget topicStatCell(BuildContext context, StatBlock stats) {
    return Column(children: [
      Text(stats.topic?.title ?? "", style: Theme.of(context).textTheme.labelLarge, overflow: TextOverflow.ellipsis),
      Expanded(flex: 1, child: statCell(context, stats, false))
      ]);
  }
}