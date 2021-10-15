import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_scaffold_messenger.dart';
import 'package:stack_router/stack_router_snack_bar.dart';

class StackRouterInheritedData extends InheritedWidget {
  final void Function(String route) pushRoute;
  final void Function([String route]) popRoute;
  final void Function({
    String? route,
    required StackRouterSnackBar snackBar,
  }) showSnackBar;
  final void Function({String? route}) clearSnackBars;
  final void Function({String? route}) hideSnackBar;
  final String currentRoute;
  final String? route;
  final List<String> routeHistory;
  final Function({
    required String route,
    required StackRouterScaffoldMessenger messenger,
  }) addMessenger;
  final void Function()? onPop;

  const StackRouterInheritedData({
    required this.currentRoute,
    required this.routeHistory,
    required this.popRoute,
    required this.pushRoute,
    required this.showSnackBar,
    required this.clearSnackBars,
    required this.hideSnackBar,
    required this.addMessenger,
    required child,
    this.route,
    this.onPop,
    key,
  }) : super(key: key, child: child);

  static StackRouterInheritedData? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StackRouterInheritedData>();
  }

  @override
  bool updateShouldNotify(StackRouterInheritedData oldWidget) =>
      popRoute != oldWidget.popRoute ||
      currentRoute != oldWidget.currentRoute ||
      route != oldWidget.route ||
      routeHistory != oldWidget.routeHistory ||
      popRoute != oldWidget.popRoute ||
      pushRoute != oldWidget.pushRoute ||
      showSnackBar != oldWidget.showSnackBar ||
      clearSnackBars != oldWidget.clearSnackBars ||
      onPop != oldWidget.onPop ||
      hideSnackBar != oldWidget.hideSnackBar;

  StackRouterInheritedData copyWith({
    Widget? child,
    String? route,
    void Function()? onPop,
  }) {
    return StackRouterInheritedData(
      child: child ?? this.child,
      currentRoute: currentRoute,
      routeHistory: routeHistory,
      popRoute: popRoute,
      pushRoute: pushRoute,
      showSnackBar: showSnackBar,
      clearSnackBars: clearSnackBars,
      hideSnackBar: hideSnackBar,
      addMessenger: addMessenger,
      route: route ?? this.route,
      onPop: onPop,
    );
  }
}
