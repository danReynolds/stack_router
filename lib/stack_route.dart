import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_inherited_data.dart';

class StackRoute extends StatefulWidget {
  final Widget child;
  final String route;
  final bool persist;
  final void Function()? onPop;

  const StackRoute({
    required this.child,
    required this.route,
    this.onPop,
    this.persist = false,
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
    final shouldPersist =
        inheritedStackRouterData.routeHistory.contains(widget.route) ||
            widget.persist;

    return Visibility(
      visible: isCurrentRoute,
      maintainState: shouldPersist,
      child: inheritedStackRouterData.copyWith(
        child: widget.child,
        route: widget.route,
        onPop: widget.onPop,
      ),
    );
  }
}
