import 'package:flutter/material.dart';
import 'package:quiz_app/statistics_page.dart';

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
              showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext context) {
                return FractionallySizedBox(heightFactor: 0.8, child: StatisticsPage());
              },
              constraints:  const BoxConstraints(minWidth: double.infinity, minHeight: 200),
              showDragHandle: true);
            },
          )],
        ),
      body: SafeArea(child: body),
    );
  }
}