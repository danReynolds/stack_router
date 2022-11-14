import 'package:stack_router/stack_router_snack_bar.dart';

class StackRouterController {
  /// Displays a [StackRouterSnackBar] bottom of the [StackRouterScaffold] for the given route. Defaults to the current route.
  late void Function({
    /// The [StackRouterSnackBar] to display.
    required StackRouterSnackBar snackBar,

    /// The route to display the snack bar on.
    String? route,
  }) showSnackBar;

  /// Clears all snack bars on the given route. Defaults to the current route.
  late void Function({String? route}) clearSnackBars;

  /// Hides the active snack bar on the given route. Defaults to the current route.
  late void Function({String? route}) hideSnackBar;

  /// Pushes the given route on top of the router stack.
  late void Function(String route) pushRoute;

  /// Pushes the given route on top of the router stack and removes the previous route.
  late void Function(String route) pushReplacementRoute;

  /// Pops the given route from the router stack history. Defaults to the current route.
  late void Function([String? route]) popRoute;

  /// Switches the current route to the provided route by moving it from its previous
  /// position in the stack to the top or adding it to the top if it is not already present
  /// in the stack's history.
  late final void Function(String route) switchRoute;
}
