import 'package:flutter/material.dart';

/// A snack bar that displays at the bottom of a [StackRouterScaffold].
class StackRouterSnackBar extends StatelessWidget {
  /// The title widget displayed in the snack bar.
  final Widget title;

  /// A list of actions to show in the snack bar.
  final List<Widget>? actions;

  // While duration is not used directly in this widget, it is extracted from the snackbar
  // by the snack bar queue to determine how long it should remain displayed.
  /// The duration to show the snack bar for.
  final Duration? duration;

  const StackRouterSnackBar({
    required this.title,
    this.actions,
    this.duration,
    key,
  }) : super(key: key);

  @override
  build(context) {
    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: 16,
        right: 8,
      ),
      child: Row(
        children: [
          title,
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
