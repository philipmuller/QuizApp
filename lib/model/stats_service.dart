import 'package:quizz_app/model/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StatType { attemptsCount, correctAnswersCount }

class StatsService {

  static Future<int> getCount({required StatType type, Topic? topic}) async {
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

  static increment(StatType type, Topic topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int topicCount = await getCount(type: type, topic: topic);
    int totalCount = await getCount(type: type);

    await prefs.setInt(type.name, totalCount + 1);
    await prefs.setInt("${type.name}-${topic.id}", topicCount + 1);
  }

  static logAnswerAttempt(bool correctly, Topic topic) {
    increment(StatType.attemptsCount, topic);
    if (correctly) {
      increment(StatType.correctAnswersCount, topic);
    }
  }

  static clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}