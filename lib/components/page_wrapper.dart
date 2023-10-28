import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageWrapper extends StatelessWidget {
  final Widget body;
  final String title;

  PageWrapper({required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), titleTextStyle: Theme.of(context).textTheme.titleMedium),
      body: body
    );
  }
}