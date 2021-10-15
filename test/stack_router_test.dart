import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:stack_router/stack_router.dart';

class TestStackRoutes {
  static const String firstRoute = 'firstRoute';
  static const String secondRoute = 'secondRoute';
}

void main() {
  testGoldens(
    'Displays initial route',
    (WidgetTester tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Displays initial route',
          SizedBox(
            height: 500,
            width: double.infinity,
            child: Material(
              child: StackRouter(
                initialRoute: TestStackRoutes.firstRoute,
                builder: (router) {
                  return [
                    const StackRoute(
                      route: TestStackRoutes.firstRoute,
                      child: Center(
                        child: Text(
                          "I'm a stack router",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'initial_route', customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Push second route',
    (WidgetTester tester) async {
      await loadAppFonts();

      late StackRouterState routerState;

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Push second route',
          SizedBox(
            height: 500,
            width: double.infinity,
            child: Material(
              child: StackRouter(
                initialRoute: TestStackRoutes.firstRoute,
                builder: (router) {
                  routerState = router;
                  return [
                    const StackRoute(
                      route: TestStackRoutes.firstRoute,
                      child: Center(
                        child: Text(
                          "I'm the first route",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const StackRoute(
                      route: TestStackRoutes.secondRoute,
                      child: StackRouterScaffold(
                        appBar: StackRouterAppBar(
                          title: Text("I'm a Title"),
                        ),
                        child: Expanded(
                          child: Center(
                            child: Text(
                              "I'm the second route",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());

      routerState.pushRoute(TestStackRoutes.secondRoute);

      await screenMatchesGolden(tester, 'push_route', customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );
}
