import 'package:flutter/material.dart';

class StackRouterSnackBarAction extends StatelessWidget {
  final Widget text;
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
