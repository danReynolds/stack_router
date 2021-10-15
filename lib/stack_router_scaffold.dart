import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_actions.dart';
import 'package:stack_router/stack_router_app_bar.dart';
import 'package:stack_router/stack_router_inherited_data.dart';
import 'package:stack_router/stack_router_scaffold_messenger.dart';
import 'package:stack_router/stack_router_snack_bar.dart';
import 'package:stack_router/stack_router_snack_bar_for_state.dart';
import 'package:stack_router/stack_router_snack_bar_queue.dart';

/// A scaffold for a [StackRoute] that provides the route with the ability to show app bars, snack bars and
/// perform [StackRouterActions] accessible by the injected inherited widget using [StackRouterActions.of(context)].
class StackRouterScaffold extends StatefulWidget {
  /// The child widget to display within the scaffold.
  final Widget child;

  /// An app bar to display at the top of the scaffold.
  final StackRouterAppBar? appBar;

  /// The color of the scaffold body.
  final Color? color;

  /// The height of the scaffold.
  final double? height;

  /// The width of the scaffold.
  final double? width;

  /// Whether the child widget of the scaffold should extend to under the app bar.
  final bool extendBodyBehindAppBar;

  /// The aligment of the child widget in the scaffold.
  final Alignment? alignment;

  const StackRouterScaffold({
    required this.child,
    this.appBar,
    this.color,
    this.height,
    this.width,
    this.alignment,
    this.extendBodyBehindAppBar = false,
    key,
  }) : super(key: key);

  @override
  _StackRouterScaffoldState createState() => _StackRouterScaffoldState();
}

class _StackRouterScaffoldState extends State<StackRouterScaffold> {
  late StackRouterSnackBarQueue _snackBarQueue;
  StackRouterSnackBarQueueChangeEvent? _latestSnackBarEvent;
  bool _hasAddedMessenger = false;
  late StackRouterScaffoldMessenger _messenger;

  @override
  initState() {
    super.initState();

    _messenger = StackRouterScaffoldMessenger(
      showSnackBar: _showSnackBar,
      clearSnackBars: _clearSnackBars,
      hideSnackBar: _hideSnackBar,
    );

    _snackBarQueue = StackRouterSnackBarQueue(onChange: (event) {
      if (mounted) {
        setState(() {
          _latestSnackBarEvent = event;
        });
      }
    });
  }

  _showSnackBar(StackRouterSnackBar snackBar) {
    _snackBarQueue.enqueue(snackBar);
  }

  _clearSnackBars() {
    _snackBarQueue.clearAll();
  }

  _hideSnackBar() {
    _snackBarQueue.dequeue();
  }

  @override
  build(context) {
    final stackRouterInheritedData = StackRouterInheritedData.of(context)!;
    final currentRoute = stackRouterInheritedData.route;

    if (!_hasAddedMessenger) {
      _hasAddedMessenger = true;
      stackRouterInheritedData.addMessenger(
        route: currentRoute!,
        messenger: _messenger,
      );
    }

    return StackRouterActions(
      pushRoute: stackRouterInheritedData.pushRoute,
      popRoute: stackRouterInheritedData.popRoute,
      clearSnackBars: ({String? route}) {
        final clearSnackBars = stackRouterInheritedData.clearSnackBars;
        return clearSnackBars(route: route);
      },
      hideSnackBar: ({String? route}) {
        final hideSnackBar = stackRouterInheritedData.hideSnackBar;
        return hideSnackBar(route: route);
      },
      showSnackBar: ({
        String? route,
        required StackRouterSnackBar snackBar,
      }) {
        final showSnackBar = stackRouterInheritedData.showSnackBar;
        return showSnackBar(
          route: route,
          snackBar: snackBar,
        );
      },
      child: Container(
        color: widget.color ?? Colors.white,
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: widget.extendBodyBehindAppBar || widget.appBar == null
                    ? 0
                    : widget.appBar!.height,
              ),
              child: Container(
                alignment: widget.alignment,
                // While the child of the scaffold is wrapped in a stack in order
                // to support the appbar and snackbar, the child itself typically
                // wants a column as its parent as opposed to a stack so that it
                // can support flex widgets. We get around that here by wrapping the
                // child in a column.
                child: Column(
                  children: [
                    widget.child,
                  ],
                ),
              ),
            ),
            if (widget.appBar != null) widget.appBar!,
            StackRouterSnackBarForState(
              event: _latestSnackBarEvent,
            ),
          ],
        ),
      ),
    );
  }
}
