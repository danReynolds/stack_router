import 'dart:async';

import 'package:stack_router/stack_router_snack_bar.dart';

enum SnackBarState { none, transitionIn, display, transitionOut }

const stackRouterSnackBarQueueTransitionInDuration =
    Duration(milliseconds: 250);
const stackRouterSnackBarQueueTransitionOutDuration =
    Duration(milliseconds: 250);

class StackRouterSnackBarQueueChangeEvent {
  final StackRouterSnackBar? snackBar;
  final SnackBarState snackBarState;

  StackRouterSnackBarQueueChangeEvent(
      {required this.snackBar, required this.snackBarState});
}

class StackRouterSnackBarQueue {
  List<StackRouterSnackBar> _snackBars = [];
  Timer? _currentSnackBarTimer;
  SnackBarState _currentSnackBarState = SnackBarState.none;
  final void Function(StackRouterSnackBarQueueChangeEvent event) onChange;

  StackRouterSnackBarQueue({required this.onChange});

  _fireOnChangeEvent() {
    final event = StackRouterSnackBarQueueChangeEvent(
      snackBar: _snackBars.isNotEmpty ? _snackBars[0] : null,
      snackBarState: _currentSnackBarState,
    );
    onChange(event);
  }

  enqueue(StackRouterSnackBar snackBar) {
    _snackBars.add(snackBar);

    if (_currentSnackBarState == SnackBarState.none) {
      _advance();
    }
  }

  dequeue() {
    // If the current snack bar is being transitioned in or displayed, cancel it
    // and advance it to transition out.
    if (_currentSnackBarState == SnackBarState.transitionIn ||
        _currentSnackBarState == SnackBarState.display) {
      _currentSnackBarTimer!.cancel();
      _currentSnackBarTimer = null;
      _currentSnackBarState = SnackBarState.display;
      _advance();
    }
  }

  clearAll() {
    if (_currentSnackBarState != SnackBarState.none) {
      _currentSnackBarTimer!.cancel();
      _currentSnackBarTimer = null;
      _snackBars = [];
    }

    _fireOnChangeEvent();
  }

  _advance() {
    if (_currentSnackBarState == SnackBarState.none) {
      _currentSnackBarState = SnackBarState.transitionIn;
      _fireOnChangeEvent();
      _currentSnackBarTimer = Timer(
        stackRouterSnackBarQueueTransitionInDuration,
        _advance,
      );
    } else if (_currentSnackBarState == SnackBarState.transitionIn) {
      _currentSnackBarState = SnackBarState.display;
      _fireOnChangeEvent();
      _currentSnackBarTimer =
          Timer(_snackBars[0].duration ?? const Duration(seconds: 3), _advance);
    } else if (_currentSnackBarState == SnackBarState.display) {
      _currentSnackBarState = SnackBarState.transitionOut;
      _fireOnChangeEvent();
      _currentSnackBarTimer = Timer(
        stackRouterSnackBarQueueTransitionOutDuration,
        _advance,
      );
    } else {
      _snackBars.removeAt(0);
      _currentSnackBarState = SnackBarState.none;
      _fireOnChangeEvent();

      if (_snackBars.isNotEmpty) {
        _advance();
      }
    }
  }
}
