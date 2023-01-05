library stack_router;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Key? key,
  }) : super(key: key);

  @override
  StackRouterState createState() => StackRouterState();
}

class StackRouterState extends State<StackRouter> {
  int _stackIndex = 0;
  List<String> _routeHistory = [];
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
    controller.switchRoute = switchRoute;
  }

  _addMessenger({
    required String route,
    required StackRouterScaffoldMessenger messenger,
  }) {
    stackRouterScaffoldMessengers[route] = messenger;
  }

  String? get currentRoute {
    if (_routeHistory.isEmpty) {
      return null;
    }

    return _routeHistory.last;
  }

  /// Displays a [StackRouterSnackBar] bottom of the [StackRouterScaffold] for the given route. Defaults to the current route.
  void showSnackBar({
    /// The [StackRouterSnackBar] to display.
    required StackRouterSnackBar snackBar,

    /// The route to display the snack bar on.
    String? route,
  }) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  /// Clears all snack bars on the given route. Defaults to the current route.
  void clearSnackBars({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.clearSnackBars();
    }
  }

  /// Hides the active snack bar on the given route. Defaults to the current route.
  void hideSnackBar({String? route}) {
    final scaffoldMessenger =
        stackRouterScaffoldMessengers[route ?? currentRoute];
    if (scaffoldMessenger != null) {
      scaffoldMessenger.hideSnackBar();
    }
  }

  _notifyRouteChange() {
    if (widget.notifySystemNavigator) {
      SystemNavigator.routeInformationUpdated(location: currentRoute!);
    }

    if (widget.onRouteChange != null) {
      widget.onRouteChange!(currentRoute!);
    }
  }

  /// Pushes the given route on top of the router stack.
  void pushRoute(String route) {
    setState(() {
      _routeHistory.add(route);
    });
    _notifyRouteChange();
  }

  /// Removes the current route at the top of the stack and replaces it with the provided one.
  void pushReplacementRoute(String route) {
    setState(() {
      _routeHistory.removeLast();
      _routeHistory.add(route);
    });
    _notifyRouteChange();
  }

  /// Switches the current route to the provided route by moving it from its previous
  /// position in the stack to the top or adding it to the top if it is not already present
  /// in the stack's history.
  void switchRoute(String route) {
    setState(() {
      if (_routeHistory.contains(route)) {
        _routeHistory.remove(route);
      }
      _routeHistory.add(route);
    });
    _notifyRouteChange();
  }

  /// Pops the given route from the router stack history. Defaults to the current route.
  void popRoute([String? route]) {
    route ??= _routeHistory.last;

    if (!_routeHistory.contains(route)) {
      return;
    }

    setState(() {
      _routeHistory.remove(route);
      children![routeIndices[route]!].onPop?.call();
    });

    _notifyRouteChange();
  }

  @override
  build(context) {
    children = widget.builder(this);

    children!.asMap().forEach((index, child) {
      routeIndices[child.route] = index;
    });

    final initialRoute = widget.initialRoute;
    final initialHistory = widget.initialHistory;

    // Initialize the first route by selecting either an initial route or just
    // the first element in the stack. The tab index is set to the index of that route
    // and the history is hydrated with that route.
    if (_routeHistory.isEmpty) {
      if (widget.initialHistory.isEmpty) {
        _routeHistory = [initialRoute ?? children![0].route];
      } else {
        _routeHistory = [...initialHistory];
        if (initialRoute != null) {
          _routeHistory.add(initialRoute);
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyRouteChange();
      });
    }

    if (routeIndices[currentRoute] != null) {
      _stackIndex = routeIndices[currentRoute]!;
    }

    return StackRouterInheritedData(
      showSnackBar: showSnackBar,
      hideSnackBar: hideSnackBar,
      clearSnackBars: clearSnackBars,
      pushRoute: pushRoute,
      popRoute: popRoute,
      switchRoute: switchRoute,
      routeHistory: _routeHistory,
      addMessenger: _addMessenger,
      canPop: false,
      child: IndexedStack(
        index: _stackIndex,
        children: children!,
      ),
    );
  }
}
