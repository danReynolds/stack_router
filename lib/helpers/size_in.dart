import 'package:flutter/material.dart';

enum SizeInDimension {
  both,
  height,
  width,
}

class SizeIn extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final Duration duration;
  final double size;
  final double initialSize;
  final SizeInDimension? dimension;

  const SizeIn({
    required this.child,
    required this.size,
    required this.duration,
    this.initialSize = 0,
    this.delay,
    this.dimension,
    key,
  }) : super(key: key);

  @override
  _SizeInState createState() => _SizeInState();
}

class _SizeInState extends State<SizeIn> with SingleTickerProviderStateMixin {
  double? _size;
  late SizeInDimension _dimension;

  @override
  initState() {
    super.initState();

    _size = widget.initialSize;
    _dimension = widget.dimension ?? SizeInDimension.both;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.delay == null) {
        setState(() {
          _size = widget.size;
        });
      } else {
        Future.delayed(widget.delay!, () {
          setState(() {
            _size = widget.size;
          });
        });
      }
    });
  }

  @override
  build(context) {
    return Stack(
      key: widget.key,
      alignment: Alignment.bottomCenter,
      children: [
        Align(
          child: AnimatedContainer(
            width: _dimension != SizeInDimension.height ? _size : null,
            height: _dimension != SizeInDimension.width ? _size : null,
            duration: widget.duration,
            curve: Curves.fastOutSlowIn,
            child: widget.child,
          ),
        ),
        Container(height: _size),
      ],
    );
  }
}
