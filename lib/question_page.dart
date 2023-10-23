import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizz_app/model/question.dart';
import 'package:quizz_app/model/quiz-service.dart';
import 'package:quizz_app/components/topic_list_component.dart';
import 'package:quizz_app/components/page_wrapper.dart';
import 'package:quizz_app/model/topic.dart';

class QuestionPage extends ConsumerWidget {

  final Topic topic;
  final int? questionId;

  QuestionPage({required this.topic, this.questionId});

  final questionProvider = FutureProvider.family<Question, Topic>((ref, topic) async {
    return await QuizService.getQuestion(topic);
  });
  final isCorrectProvider = StateProvider<bool?>((ref) => null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionFuture = ref.watch(questionProvider(topic));

    return PageWrapper(title: topic.title,
      body: questionFuture.when(
        data: (question) => questionView(question, context, ref),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()))
    );
  }

  Widget questionView(Question question, BuildContext context, WidgetRef ref) {
    return Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          questionCard(question.text, context),
          questionChoices(question.choices, ref),
          continueButton(ref)
        ]
      )
    );
  }

  Widget continueButton(WidgetRef ref) {
    final bool? isCorrect = ref.watch(isCorrectProvider);

    if (isCorrect == null) {
      return Container();
    } else if (isCorrect) {
      return ElevatedButton(
        onPressed: () {
          ref.watch(isCorrectProvider.notifier).update((state) => null);
          ref.refresh(questionProvider(topic));
        },
        child: const Text("Continue"),
      );
    } else {
      return const Text("Try Again");
    }
  }

  Widget questionCard(String text, BuildContext context) {
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 350,
        height: 220,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }

  Widget questionChoices(List<String> choices, WidgetRef ref) {
    return Column(
      children: choices.map((choice) => choiceButton(choice, choices.indexOf(choice), ref)).toList()
    );
  }

  Widget choiceButton(String text, int index, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => handleChoiceSelection(index, ref),
      child: Text(text),
    );
  }

  handleChoiceSelection(int selectionIndex, WidgetRef ref) async {
    final question = await ref.watch(questionProvider(topic).future);
    final isCorrect = await QuizService.checkAnswer(question, selectionIndex);
    print(isCorrect);
    if (isCorrect) {
      ref.watch(isCorrectProvider.notifier).update((state) => true);
    } else {
      ref.watch(isCorrectProvider.notifier).update((state) => false);
    }
  }
}