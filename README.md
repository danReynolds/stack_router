# Stack router

A stack-based routing library using an [IndexedStack](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html) to route between different widgets. Includes its own [Scaffold](https://github.com/danReynolds/stack_router/blob/master/lib/stack_router_scaffold.dart), [App bar](https://github.com/danReynolds/stack_router/blob/master/lib/stack_router_app_bar.dart) and [Snack bar](https://github.com/danReynolds/stack_router/blob/master/lib/stack_router_snack_bar.dart) implementation.

![Basic demo gif](./demo.gif).

## Usage

```dart
import 'package:stack_router/stack_router.dart';

class ExampleStackRoutes {
  static const String firstRoute = 'firstRoute';
  static const String secondRoute = 'secondRoute';
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StackRouter(
        initialRoute: ExampleStackRoutes.firstRoute,
        builder: (router) {
          return [
            StackRoute(
              route: ExampleStackRoutes.firstRoute,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    router.pushRoute(ExampleStackRoutes.secondRoute);
                  },
                  child: const Text(
                    "Go to second route",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            StackRoute(
              route: ExampleStackRoutes.secondRoute,
              child: StackRouterScaffold(
                appBar: const StackRouterAppBar(
                  title: Text("I'm a Title", style: TextStyle(fontSize: 24)),
                ),
                child: Expanded(
                  child: Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "I'm the second route",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            router.showSnackBar(
                              snackBar: const StackRouterSnackBar(
                                title: Text(
                                  "I'm a snackbar!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Show snack bar",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}
```

To see it in action, try running the [example](./example).

