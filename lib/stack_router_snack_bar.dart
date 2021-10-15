import 'package:flutter/material.dart';

class StackRouterSnackBar extends StatelessWidget {
  final Widget title;
  final List<Widget>? actions;
  // While duration is not used directly in this widget, it is extracted from the snackbar
  // by the snack bar queue to determine how long it should remain displayed.
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
