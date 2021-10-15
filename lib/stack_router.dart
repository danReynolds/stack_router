library stack_router;

import 'package:flutter/material.dart';
import 'package:stack_router/stack_route.dart';
import 'package:stack_router/stack_router_inherited_data.dart';
import 'package:stack_router/stack_router_scaffold_messenger.dart';
import 'package:stack_router/stack_router_snack_bar.dart';

export 'package:stack_router/stack_route.dart';
export 'package:stack_router/stack_router_snack_bar.dart';
export 'package:stack_router/stack_router_actions.dart';
export 'package:stack_router/stack_router_scaffold.dart';

class StackRouter extends StatefulWidget {
  final List<StackRoute> Function(_StackRouterState router) builder;
  final String? initialRoute;

  const StackRouter({
    required this.builder,
    this.initialRoute,
    key,
  }) : super(key: key);

  @override
  _StackRouterState createState() => _StackRouterState();
}

class _StackRouterState extends State<StackRouter> {
  int _tabIndex = 0;
  List<String> _routeHistory = [];
  String? _currentRoute;
  Map<String, int> routeIndices = {};
  List<StackRoute>? children;
  Map<String, StackRouterScaffoldMessenger> stackRouterScaffoldMessengers = {};

  _addMessenger({
    required String route,
    required StackRouterScaffoldMessenger messenger,
  }) {
    stackRouterScaffoldMessengers[route] = messenger;
  }

  void showSnackBar({
    required StackRouterSnackBar snackBar,
    String? route,
  }) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  void clearSnackBars({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      stackRouterScaffoldMessengers[route]!.clearSnackBars();
    }
  }

  void hideSnackBar({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      stackRouterScaffoldMessengers[route]!.hideSnackBar();
    }
  }

  _setRoute(String route) {
    setState(() {
      _tabIndex = routeIndices[route]!;
      _currentRoute = route;
    });
  }

  void pushRoute(String route) {
    _routeHistory.add(route);
    _setRoute(route);
  }

  void pushReplacementRoute(String route) {
    _routeHistory = [route];
    _setRoute(route);
  }

  void popRoute([String? route]) {
    final backRoute = route ?? _routeHistory[_routeHistory.length - 2];

    final lastIndexOfRoute = _routeHistory.lastIndexOf(backRoute);
    _routeHistory = _routeHistory.sublist(0, lastIndexOfRoute + 1);

    _setRoute(backRoute);
  }

  @override
  build(context) {
    children = widget.builder(this);

    children!.asMap().forEach((index, child) {
      routeIndices[child.route] = index;
    });

    // Initialize the first route by selecting either an initial route or just
    // the first element in the stack. The tab index is set to the index of that route
    // and the history is hydrated with that route.
    if (_currentRoute == null) {
      _currentRoute = widget.initialRoute ?? children![0].route;
      _tabIndex = routeIndices[_currentRoute]!;
      _routeHistory = [_currentRoute!];
    }

    return StackRouterInheritedData(
      showSnackBar: showSnackBar,
      hideSnackBar: hideSnackBar,
      clearSnackBars: clearSnackBars,
      pushRoute: pushRoute,
      popRoute: popRoute,
      currentRoute: _currentRoute!,
      routeHistory: _routeHistory,
      addMessenger: _addMessenger,
      child: IndexedStack(
        index: _tabIndex,
        children: children!,
      ),
    );
  }
}
