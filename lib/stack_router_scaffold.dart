import 'package:flutter/material.dart';
import 'package:stack_router/stack_router_actions.dart';
import 'package:stack_router/stack_router_app_bar.dart';
import 'package:stack_router/stack_router_inherited_data.dart';
import 'package:stack_router/stack_router_scaffold_messenger.dart';
import 'package:stack_router/stack_router_snack_bar.dart';
import 'package:stack_router/stack_router_snack_bar_for_state.dart';
import 'package:stack_router/stack_router_snack_bar_queue.dart';

class StackRouterScaffold extends StatefulWidget {
  final Widget child;
  final Widget? title;
  final Widget? trailing;
  final Color? color;
  final double? height;
  final double? width;
  final double appBarHeight;
  final bool extendBodyBehindAppBar;
  final Alignment? alignment;
  final bool suppressLeadingBackButton;

  const StackRouterScaffold({
    required this.child,
    this.title,
    this.trailing,
    this.color,
    this.height,
    this.width,
    this.extendBodyBehindAppBar = false,
    this.suppressLeadingBackButton = false,
    this.alignment,
    this.appBarHeight = stackRouterAppBarHeight,
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
        return clearSnackBars(route: route ?? currentRoute);
      },
      hideSnackBar: ({String? route}) {
        final hideSnackBar = stackRouterInheritedData.hideSnackBar;
        return hideSnackBar(route: route ?? currentRoute);
      },
      showSnackBar: ({
        String? route,
        required StackRouterSnackBar snackBar,
      }) {
        final showSnackBar = stackRouterInheritedData.showSnackBar;
        return showSnackBar(
          route: route ?? currentRoute,
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
                top: widget.extendBodyBehindAppBar ? 0 : widget.appBarHeight,
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
            StackRouterAppBar(
              title: widget.title,
              trailing: widget.trailing,
              height: widget.appBarHeight,
              suppressLeadingBackButton: widget.suppressLeadingBackButton,
            ),
            StackRouterSnackBarForState(
              event: _latestSnackBarEvent,
            ),
          ],
        ),
      ),
    );
  }
}
