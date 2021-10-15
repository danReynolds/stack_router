import 'package:flutter/material.dart';

import 'stack_router_inherited_data.dart';

const double stackRouterAppBarHeight = 60;

class StackRouterAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? trailing;
  final double? height;
  final bool suppressLeadingBackButton;

  const StackRouterAppBar({
    required this.title,
    this.trailing,
    this.suppressLeadingBackButton = false,
    this.height,
    key,
  }) : super(key: key);

  bool _shouldShowLeadingBackButton(BuildContext context) {
    final inheritedBottomSheetStack = StackRouterInheritedData.of(context)!;

    final isCurrentRoute = inheritedBottomSheetStack.currentRoute ==
        inheritedBottomSheetStack.route;
    final isFirstRoute = inheritedBottomSheetStack.routeHistory.length == 1;
    final onPop = inheritedBottomSheetStack.onPop;

    return isCurrentRoute &&
        (!isFirstRoute || onPop != null) &&
        !suppressLeadingBackButton;
  }

  Widget _buildLeading(BuildContext context) {
    final inheritedBottomSheetStack = StackRouterInheritedData.of(context)!;
    final onPop = inheritedBottomSheetStack.onPop;

    if (_shouldShowLeadingBackButton(context)) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 28,
            color: Colors.grey[700],
          ),
          onTap: () {
            if (onPop != null) {
              onPop();
            } else {
              inheritedBottomSheetStack.popRoute();
            }
          },
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildTitle(BuildContext context) {
    if (title != null) {
      return title!;
    }

    return const SizedBox();
  }

  Widget _buildTrailing(BuildContext context) {
    if (trailing != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: trailing,
      );
    }

    return const SizedBox();
  }

  @override
  build(context) {
    if (title != null ||
        trailing != null ||
        _shouldShowLeadingBackButton(context)) {
      return SizedBox(
        height: height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildLeading(context),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildTitle(context),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildTrailing(context),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
