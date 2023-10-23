import 'package:flutter/material.dart';
import 'package:quizz_app/components/topic_list_component.dart';
import 'package:quizz_app/components/page_wrapper.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageWrapper(title: "Quizz App",
      body: TopicList()
    );
  }
}