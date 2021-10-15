import 'package:flutter/material.dart';

/// An action to show in a [StackRouterSnackBar].
class StackRouterSnackBarAction extends StatelessWidget {
  /// The text to display within the action's [TextButton].
  final Widget text;

  /// The function to invoke when the action's [TextButton] is pressed.
  final void Function() onPress;

  const StackRouterSnackBarAction({
    required this.text,
    required this.onPress,
    key,
  }) : super(key: key);

  @override
  build(context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: text,
      onPressed: onPress,
    );
  }
}
