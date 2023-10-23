import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:quizz_app/model/topic.dart';
import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz-service.dart';

class TopicList extends ConsumerWidget {

  final topicProvider = FutureProvider<List<Topic>>((ref) async {
    return await QuizService.getTopics();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicFuture = ref.watch(topicProvider);

    return topicFuture.when(
      data: (topics) => topicList(topics),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }


  Widget topicList(List<Topic> topics) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10, 
      crossAxisCount: 2, 
      shrinkWrap: false, 
      children: topics.map((topic) => topicCell(topic)).toList());
  }

  Widget topicCell(Topic topic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Text(topic.title),
    );
  }
}