import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz-service.dart';
import 'package:quizz_app/model/topic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizz_app/components/topic_list_component.dart';

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Quizz App')),
      body: TopicList()
    );
  }

  Widget title() {
    return const Text(
      'Topics',
      style: TextStyle(fontSize: 24),
    );
  }
}