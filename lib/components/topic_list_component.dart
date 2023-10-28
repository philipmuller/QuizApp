import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:go_router/go_router.dart';
import 'package:quizz_app/model/topic.dart';
import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz_service.dart';

class TopicList extends ConsumerWidget {

  final topicProvider = FutureProvider<List<Topic>>((ref,) async {
    return await QuizService.getTopics();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicFuture = ref.watch(topicProvider);

    return topicFuture.when(
      data: (topics) => topicList(topics, context),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }


  Widget topicList(List<Topic> topics, BuildContext context) {
    if (topics.isEmpty) {
      return const Text("No topics available");
    } else {
      return GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisSpacing: 13,
      mainAxisSpacing: 13, 
      crossAxisCount: 2, 
      shrinkWrap: false, 
      children: topics.map((topic) => topicCell(topic, context)).toList());
    }
  }

  Widget topicCell(Topic topic, BuildContext context) {

    void handleTap() {
      context.push("/topic/question/", extra: topic);
    }

    return GestureDetector(
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          ),
        padding: const EdgeInsets.all(15),
        child: Text(topic.title),
      )
    );
  }
}