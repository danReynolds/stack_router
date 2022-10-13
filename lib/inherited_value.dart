import 'package:flutter/material.dart';

class InheritedValue extends InheritedWidget {
  final GlobalKey value;

  const InheritedValue({
    required Widget child,
    required this.value,
    Key? key,
  }) : super(key: key, child: child);

  static InheritedValue? of<S>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedValue>();
  }

  @override
  bool updateShouldNotify(InheritedValue oldWidget) => value != oldWidget.value;
}
