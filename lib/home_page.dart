import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:quiz_app/components/page_wrapper.dart';
import 'package:quiz_app/model/stats_service.dart';
import 'package:quiz_app/model/topic.dart';
import 'package:quiz_app/model/quiz_service.dart';

class HomePage extends ConsumerWidget {

  final topicProvider = FutureProvider<List<Topic>>((ref,) async {
    return await QuizService.getTopics();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicFuture = ref.watch(topicProvider);

    return PageWrapper(title: "quiz App",
      body: topicFuture.when(
        data: (topics) => topicList(topics, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
      )
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
      children: [topicCell(context: context), ...topics.map((topic) => topicCell(topic: topic, context: context)).toList()]);
    }
  }

  Widget topicCell({Topic? topic = null, required BuildContext context}) {

    final route = (topic == null) ? "/practice/question" : "/topic/question";


    void handleTap() async {
      var selectedTopic = topic;

      if (topic == null) {
        var topics = await StatsService.getLowestRankingTopics();
        topics.shuffle();
        selectedTopic = topics.first;
      }
      if (context.mounted) {
        context.push(route, extra: selectedTopic);
      }
    }

    return GestureDetector(
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          color: (topic == null) ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15),
          ),
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
          topic?.title ?? "Generic Practice", 
          style: Theme.of(context).textTheme.apply(bodyColor: (topic == null) ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSecondaryContainer).bodyMedium
          ),
          const Spacer(),
          if (topic == null) Text("🪄", style: Theme.of(context).textTheme.titleLarge)
          ]),
      )
    );
  }
}