import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizz_app/model/question.dart';
import 'package:quizz_app/model/quiz_service.dart';
import 'package:quizz_app/components/page_wrapper.dart';
import 'package:quizz_app/model/stats_service.dart';
import 'package:quizz_app/model/topic.dart';

enum SelectionState { correct, incorrect, none }

class QuestionPage extends ConsumerWidget {

  final Topic topic;
  final int? questionId;

  QuestionPage({required this.topic, this.questionId});

  final questionProvider = FutureProvider.family<Question, Topic>((ref, topic) async {
    return await QuizService.getQuestion(topic);
  });
  final isCorrectProvider = StateProvider<bool?>((ref) => null);
  final wrongSelectionsProvider = StateProvider<List<int>>((ref) => []);
  final correctSelectionProvider = StateProvider<int?>((ref) => null);

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
    return Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          questionCard(question.text, context),
          const SizedBox(height: 40.0),
          questionChoices(context, ref, question.choices),
          const SizedBox(height: 20.0),
          continueField(context, ref)
        ]
      )
    ));
  }

  Widget continueField(BuildContext context, WidgetRef ref) {
    final bool? isCorrect = ref.watch(isCorrectProvider);

    if (isCorrect == null) {
      return Container();
    } else if (isCorrect) {
      return continueButton(context, ref);
    } else {
      return tryAgainField(context);
    }
  }

  Widget continueButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton( style: ElevatedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary),
      onPressed: () {
        ref.watch(isCorrectProvider.notifier).update((state) => null);
        ref.watch(correctSelectionProvider.notifier).update((state) => null);
        ref.watch(wrongSelectionsProvider.notifier).update((state) => []);
        ref.refresh(questionProvider(topic));
      },
      child: const Text("Continue"),
    );
  }

  Widget tryAgainField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text("Try Again", style: TextStyle(color: Theme.of(context).colorScheme.error)),
    );
  }

  Widget questionCard(String text, BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 250),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.grey.shade300)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.apply(bodyColor: Colors.black87).titleSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget questionChoices(BuildContext context, WidgetRef ref, List<String> choices) {
    final correctSelection = ref.watch(correctSelectionProvider);
    final incorrectSelections = ref.watch(wrongSelectionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: choices.map((choice) => choiceButton(
        context, 
        ref, 
        choice, 
        choices.indexOf(choice), 
        correctSelection == choices.indexOf(choice) ? SelectionState.correct : incorrectSelections.contains(choices.indexOf(choice)) ? SelectionState.incorrect : SelectionState.none)).toList()
    );
  }

  Widget choiceButton(BuildContext context, WidgetRef ref, String text, int index, SelectionState state) {
    var foregroundColor = Theme.of(context).colorScheme.primary;
    var backgroundColor = Theme.of(context).colorScheme.primaryContainer;

    if (state == SelectionState.correct) {
      foregroundColor = Theme.of(context).colorScheme.onPrimary;
      backgroundColor = Theme.of(context).colorScheme.primary;
    } else if (state == SelectionState.incorrect) {
      foregroundColor = Theme.of(context).colorScheme.error;
      backgroundColor = Theme.of(context).colorScheme.errorContainer;
    }

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
      ),
      onPressed: () => handleChoiceSelection(index, ref),
      child: Text(text),
    );
  }

  handleChoiceSelection(int selectionIndex, WidgetRef ref) async {
    final question = await ref.watch(questionProvider(topic).future);
    final isCorrect = await QuizService.checkAnswer(question, selectionIndex);
    StatsService.logAnswerAttempt(isCorrect, topic);
    print(isCorrect);
    if (isCorrect) {
      ref.watch(isCorrectProvider.notifier).update((state) => true);
      ref.watch(correctSelectionProvider.notifier).update((state) => selectionIndex);
    } else {
      ref.watch(isCorrectProvider.notifier).update((state) => false);
      ref.watch(wrongSelectionsProvider.notifier).update((state) => [...state, selectionIndex]);
    }
  }
}