import 'package:flutter/material.dart';

import 'stack_router_inherited_data.dart';

const double stackRouterAppBarHeight = 60;

/// An app bar displayed at the top of the [StackRouterScaffold].
class StackRouterAppBar extends StatelessWidget {
  /// A title widget to display in the app bar.
  final Widget? title;

  /// A trailing widget to display at the right side of the app bar.
  final Widget? trailing;

  /// A leading widget to display at the left side of the app bar.
  final Widget? leading;

  /// The height of the app bar.
  final double height;

  /// Whether to hide the back button for this route.
  final bool suppressLeadingBackButton;

  const StackRouterAppBar({
    this.title,
    this.leading,
    this.trailing,
    this.suppressLeadingBackButton = false,
    this.height = stackRouterAppBarHeight,
    key,
  }) : super(key: key);

  bool _shouldShowLeadingBackButton(BuildContext context) {
    final inheritedData = StackRouterInheritedData.of(context)!;

    final isCurrentRoute = inheritedData.currentRoute == inheritedData.route;
    final canPop = inheritedData.canPop;

    return isCurrentRoute &&
        canPop &&
        leading == null &&
        !suppressLeadingBackButton;
  }

  Widget _buildLeading(BuildContext context) {
    if (leading != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: leading!,
      );
    }

    final inheritedData = StackRouterInheritedData.of(context)!;

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
            inheritedData.popRoute();
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
        leading != null ||
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
