import 'package:flutter/material.dart';
import 'package:testing/providers/notifier_provider.dart';
import 'branch.dart';
////////////////////////////////////////////////////////////////////////////////
class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Colors.green;

    var branch = Branch(theme: theme);
    var homePage = NotifierProvider(child: branch);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: theme[400],
        appBarTheme: AppBarTheme(color: theme[400]),
        floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: theme[400]),
      ),
      home: homePage,
    );
  }
}