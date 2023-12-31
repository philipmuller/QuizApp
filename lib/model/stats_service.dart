import 'package:quiz_app/model/topic.dart';
import 'package:quiz_app/model/stat_block.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/model/quiz_service.dart';


enum StatType { attemptsCount, correctAnswersCount }

class StatsService {

  static logAnswerAttempt(bool correctly, Topic topic) {
    _increment(StatType.attemptsCount, topic);
    if (correctly) {
      _increment(StatType.correctAnswersCount, topic);
    }
  }

//Returns a list of stat blocks. The first stat block (index 0) refers to the global statistics across all stats, the remaining are topic specific ordered by correctly answered questions.
  static Future<List<StatBlock>> getAllStats() async {
    final topics = await QuizService.getTopics();
    final globalStats = await getStats();

    List<StatBlock> topicStats = [];
    for (var topic in topics) {
      topicStats.add(await getStats(topic: topic));
    }

    topicStats.sort((a, b) => b.correctAnswers - a.correctAnswers);

    return [globalStats, ...topicStats];
  }

  static Future<StatBlock> getStats({Topic? topic}) async {
    if (topic == null) {
      return StatBlock(attempts: await _getCount(type: StatType.attemptsCount), correctAnswers: await _getCount(type: StatType.correctAnswersCount));
    } else {
      return StatBlock(topic: topic, attempts: await _getCount(type: StatType.attemptsCount, topic: topic), correctAnswers: await _getCount(type: StatType.correctAnswersCount, topic: topic));
    }
  }

  static Future<List<Topic>> getLowestRankingTopics() async {
    var all = (await getAllStats()).reversed.toList();
    all.removeLast();

    if (all.isNotEmpty) {
      List<StatBlock> lowestRanking = [];

      for (var statBlock in all) {
        var last = lowestRanking.lastOrNull;
        if (last == null) {
          lowestRanking.add(statBlock);
        } else {
          if (statBlock.correctAnswers == last.correctAnswers) {
            lowestRanking.add(statBlock);
          } else {
            break;
          }
        }
      }
      //this should be fine since we kicked the element that rapresents global stats that doesn't have a topic so topic should always be different than null. Still bad tho.
      return lowestRanking.map((e) => e.topic!).toList();
    }

    return [];
  }

  static clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<int> _getCount({required StatType type, Topic? topic}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = type.name;

    if (topic != null) {
      key = "$key-${topic.id}";
    } 

    if (prefs.containsKey(key)) {
      return prefs.getInt(key)!;
    } else {
      await prefs.setInt(key, 0);
      return 0;
    }
  }

  static _increment(StatType type, Topic topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int topicCount = await _getCount(type: type, topic: topic);
    int totalCount = await _getCount(type: type);

    await prefs.setInt(type.name, totalCount + 1);
    await prefs.setInt("${type.name}-${topic.id}", topicCount + 1);
  }
}