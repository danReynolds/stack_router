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
    void Function(String route)? pushRoute,
    void Function([String route])? popRoute,
    void Function({
      String? route,
      required StackRouterSnackBar snackBar,
    })?
        showSnackBar,
    void Function({String? route})? clearSnackBars,
    void Function({String? route})? hideSnackBar,
    String? currentRoute,
    String? route,
    List<String>? routeHistory,
    Function({
      required String route,
      required StackRouterScaffoldMessenger messenger,
    })?
        addMessenger,
    void Function()? onPop,
    Widget? child,
  }) {
    return StackRouterInheritedData(
      child: child ?? this.child,
      currentRoute: currentRoute ?? this.currentRoute,
      routeHistory: routeHistory ?? this.routeHistory,
      popRoute: popRoute ?? this.popRoute,
      pushRoute: pushRoute ?? this.pushRoute,
      showSnackBar: showSnackBar ?? this.showSnackBar,
      clearSnackBars: clearSnackBars ?? this.clearSnackBars,
      hideSnackBar: hideSnackBar ?? this.hideSnackBar,
      addMessenger: addMessenger ?? this.addMessenger,
      route: route ?? this.route,
      onPop: onPop ?? this.onPop,
    );
  }
}
