import 'package:flutter/material.dart';
import 'package:stack_router/helpers/size_in.dart';
import 'package:stack_router/stack_router_snack_bar_queue.dart';

class StackRouterSnackBarForState extends StatelessWidget {
  final StackRouterSnackBarQueueChangeEvent? event;
  final double _snackBarHeight = 40;

  const StackRouterSnackBarForState({required this.event, key})
      : super(key: key);

  @override
  build(context) {
    final currentSnackBarState = event?.snackBarState;

    if (currentSnackBarState == null ||
        currentSnackBarState == SnackBarState.none) {
      return const SizedBox();
    }

    final currentSnackBar = event!.snackBar;

    Widget snackBarWidget;

    if (currentSnackBarState == SnackBarState.transitionIn ||
        currentSnackBarState == SnackBarState.display) {
      snackBarWidget = SizeIn(
        key: const Key('stack-router-snackBar-transition-in'),
        size: _snackBarHeight,
        dimension: SizeInDimension.height,
        duration: stackRouterSnackBarQueueTransitionInDuration,
        child: currentSnackBar!,
      );
    } else {
      snackBarWidget = SizeIn(
        key: const Key('stack-router-snackBar-transition-out'),
        size: 0,
        dimension: SizeInDimension.height,
        initialSize: _snackBarHeight,
        duration: stackRouterSnackBarQueueTransitionOutDuration,
        child: currentSnackBar!,
      );
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: snackBarWidget,
    );
  }
}
