library stack_router;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stack_router/inherited_value.dart';
import 'package:stack_router/stack_route.dart';
import 'package:stack_router/stack_router_controller.dart';
import 'package:stack_router/stack_router_inherited_data.dart';
import 'package:stack_router/stack_router_scaffold_messenger.dart';
import 'package:stack_router/stack_router_snack_bar.dart';

export 'package:stack_router/stack_route.dart';
export 'package:stack_router/stack_router_snack_bar.dart';
export 'package:stack_router/stack_router_actions.dart';
export 'package:stack_router/stack_router_scaffold.dart';
export 'package:stack_router/stack_router_app_bar.dart';
export 'package:stack_router/stack_router_snack_bar_action.dart';
export 'package:stack_router/stack_router_controller.dart';
export 'package:stack_router/inherited_value.dart';
export 'package:stack_router/stack_router_inherited_data.dart';

/// A router for displaying and routing to/from widgets using an IndexedStack.
class StackRouter extends StatefulWidget {
  /// The builder for the router that returns a list of the full set of stack routes.
  final List<StackRoute> Function(StackRouterState router) builder;

  /// The initial route to display.
  final String? initialRoute;

  /// The controller for the stack router used to imperatively change routes and interact
  /// with the route snack bars.
  final StackRouterController? controller;

  /// Whether route changes should notify the system navigator to trigger URI
  /// updates on Flutter web.
  final bool notifySystemNavigator;

  final List<String> initialHistory;

  final void Function(String route)? onRouteChange;

  const StackRouter({
    required this.builder,
    this.initialRoute,
    this.initialHistory = const [],
    this.controller,
    this.onRouteChange,
    this.notifySystemNavigator = true,
    key,
  }) : super(key: key);

  @override
  StackRouterState createState() => StackRouterState();
}

class StackRouterState extends State<StackRouter> {
  int _tabIndex = 0;
  List<String> _routeHistory = [];
  String? _currentRoute;
  Map<String, int> routeIndices = {};
  List<StackRoute>? children;
  late final StackRouterController controller;
  Map<String, StackRouterScaffoldMessenger> stackRouterScaffoldMessengers = {};

  @override
  initState() {
    super.initState();

    controller = widget.controller ?? StackRouterController();
    controller.clearSnackBars = clearSnackBars;
    controller.hideSnackBar = hideSnackBar;
    controller.showSnackBar = showSnackBar;
    controller.pushReplacementRoute = pushReplacementRoute;
    controller.pushRoute = pushRoute;
    controller.popRoute = popRoute;
  }

  _addMessenger({
    required String route,
    required StackRouterScaffoldMessenger messenger,
  }) {
    stackRouterScaffoldMessengers[route] = messenger;
  }

  /// Displays a [StackRouterSnackBar] bottom of the [StackRouterScaffold] for the given route. Defaults to the current route.
  void showSnackBar({
    /// The [StackRouterSnackBar] to display.
    required StackRouterSnackBar snackBar,

    /// The route to display the snack bar on.
    String? route,
  }) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  /// Clears all snack bars on the given route. Defaults to the current route.
  void clearSnackBars({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.clearSnackBars();
    }
  }

  /// Hides the active snack bar on the given route. Defaults to the current route.
  void hideSnackBar({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? _currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.hideSnackBar();
    }
  }

  _notifyRouteChange() {
    if (widget.notifySystemNavigator) {
      SystemNavigator.routeInformationUpdated(location: _currentRoute!);
    }

    if (widget.onRouteChange != null) {
      widget.onRouteChange!(_currentRoute!);
    }
  }

  _setRoute(String route) {
    setState(() {
      _currentRoute = route;
    });

    _notifyRouteChange();
  }

  /// Pushes the given route on top of the router stack.
  void pushRoute(String route) {
    _routeHistory.add(route);
    _setRoute(route);
  }

  /// Pushes the given route on top of the router stack and clears the router stack history.
  void pushReplacementRoute(String route) {
    _routeHistory = [route];
    _setRoute(route);
  }

  /// Pops the given route from the router stack history. Defaults to the current route.
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
      _routeHistory = [...widget.initialHistory, _currentRoute!];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyRouteChange();
      });
    }

    if (routeIndices[_currentRoute] != null) {
      _tabIndex = routeIndices[_currentRoute]!;
    }

    return StackRouterInheritedData(
      key: widget.key ?? InheritedValue.of(context)?.value,
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
