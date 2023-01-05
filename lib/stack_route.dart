import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_inherited_data.dart';

/// A route of a [StackRouter].
class StackRoute extends StatefulWidget {
  /// The child widget to be displayed when this becomes the current route.
  final Widget child;

  /// The name of the route.
  final String route;

  /// Whether to maintain the state of the [child] widget subtree while it is not the current route.
  /// Defaults to true if the route is present in the stack router history. If for example, this route
  /// should be eagerly built for when it later is made the current route, set [persist] to true.
  final bool? persist;

  /// A callback invoked when this route is popped off the stack history.
  final void Function()? onPop;

  const StackRoute({
    required this.child,
    required this.route,
    this.onPop,
    this.persist,
    key,
  }) : super(key: key);

  @override
  _StackRouteState createState() => _StackRouteState();
}

class _StackRouteState extends State<StackRoute> {
  @override
  build(context) {
    final inheritedStackRouterData = StackRouterInheritedData.of(context)!;

    final isCurrentRoute =
        inheritedStackRouterData.currentRoute == widget.route;
    final shouldPersist = widget.persist ??
        inheritedStackRouterData.routeHistory.contains(widget.route);
    final canPopRoute = inheritedStackRouterData.routeHistory.length > 1 ||
        widget.onPop != null;

    return Visibility(
      visible: isCurrentRoute,
      maintainState: shouldPersist,
      child: inheritedStackRouterData.copyWith(
        child: widget.child,
        route: widget.route,
        onPop: widget.onPop,
        canPop: canPopRoute,
      ),
    );
  }
}
