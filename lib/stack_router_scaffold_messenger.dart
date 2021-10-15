import 'package:stack_router/stack_router_snack_bar.dart';

class StackRouterScaffoldMessenger {
  Function(StackRouterSnackBar snackBar) showSnackBar;
  Function() clearSnackBars;
  Function() hideSnackBar;

  StackRouterScaffoldMessenger({
    required this.showSnackBar,
    required this.clearSnackBars,
    required this.hideSnackBar,
  });
}
