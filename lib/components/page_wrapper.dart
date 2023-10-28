import 'package:flutter/material.dart';
import 'package:quizz_app/statistics_page.dart';

class PageWrapper extends StatelessWidget {
  final Widget body;
  final String title;

  const PageWrapper({required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), 
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              showModalBottomSheet(context: context, builder: (BuildContext context) {
                return StatisticsPage();
              },
              constraints: BoxConstraints(minWidth: double.infinity, minHeight: 200),
              showDragHandle: true);
            },
          )],
        ),
      body: body
    );
  }
}