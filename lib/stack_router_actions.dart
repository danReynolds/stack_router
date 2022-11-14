import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_snack_bar.dart';

/// The controller for invoking a set of actions on the stack router including pushing/popping routes
/// and showing/hiding snack bars.
class StackRouterActions extends InheritedWidget {
  /// Pushes the given route to the top of the stack.
  final Function(String route) pushRoute;

  /// Pops the give route off the stack. Defaults to the current route.
  final Function([String route]) popRoute;

  /// Switches the current route to the provided route by moving it from its previous
  /// position in the stack to the top or adding it to the top if it is not already present
  /// in the stack's history.
  final void Function(String route) switchRoute;

  /// Shows a snack bar on the given route. Defaults to the current route.
  final Function({
    String route,
    required StackRouterSnackBar snackBar,
  }) showSnackBar;

  /// Clears all snack bars on the given route. Defaults to the current route.
  final Function({String route}) clearSnackBars;

  /// Hides the current snack bar on the given route. Defaults to the current route.
  final Function({String route}) hideSnackBar;

  const StackRouterActions({
    required child,
    required this.pushRoute,
    required this.popRoute,
    required this.switchRoute,
    required this.showSnackBar,
    required this.clearSnackBars,
    required this.hideSnackBar,
    key,
  }) : super(key: key, child: child);

  static StackRouterActions? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StackRouterActions>();
  }

  @override
  bool updateShouldNotify(StackRouterActions oldWidget) =>
      showSnackBar != oldWidget.showSnackBar ||
      clearSnackBars != oldWidget.clearSnackBars ||
      pushRoute != oldWidget.pushRoute ||
      popRoute != oldWidget.popRoute ||
      switchRoute != oldWidget.switchRoute ||
      hideSnackBar != oldWidget.hideSnackBar;
}
