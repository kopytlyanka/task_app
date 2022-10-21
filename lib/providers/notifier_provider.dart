import 'package:flutter/material.dart';
import 'package:testing/providers/app_bar_notifier.dart';
import 'package:testing/providers/task_notifier.dart';
import 'package:testing/providers/title_notifier.dart';
////////////////////////////////////////////////////////////////////////////////
class NotifierProvider extends StatefulWidget {
  final Widget child;

  const NotifierProvider({super.key, required this.child});

  static NotifierProviderState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedNotifierProvider>()!.data;
  }

  @override
  State<NotifierProvider> createState() => NotifierProviderState();
}
////////////////////////////////////////////////////////////////////////////////
class NotifierProviderState extends State<NotifierProvider> {
  TaskNotifier taskNotifier = TaskNotifier();
  AppBarNotifier appBarNotifier = AppBarNotifier();
  TitleNotifier titleNotifier = TitleNotifier();

  @override
  Widget build(BuildContext context) {
    return _InheritedNotifierProvider(
        data: this,
        child: widget.child,
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
class _InheritedNotifierProvider extends InheritedWidget {
  const _InheritedNotifierProvider({
    required this.data,
    required super.child
  });

  final NotifierProviderState data;

  @override
  bool updateShouldNotify(_InheritedNotifierProvider oldWidget) => true;
}