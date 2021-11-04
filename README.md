# Stack router

Stack routers use an [IndexedStack](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html) to route between different widgets. They come with their own scaffolds, app bars and snack bars similarly to the ones provided by the core Flutter UI library.

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
          ];
        },
      ),
    );
  }
}
```

In this example, the first route consists of a button that navigates to the second route using the `router.pushRoute` API when it is pressed.

The basic router APIs for navigating between routes are:

* `pushRoute(String route)` - Push the given route onto the top of the navigation stack
* `popRoute([String? route])` - Pop the given route (defaults to the current route) from the navigation stack.

## StackRouterActions

Similarly to Flutter Material's [ScaffoldMessenger](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html), any child under a [StackRouterScaffold](https://pub.dev/documentation/stack_router/latest/stack_router_scaffold/stack_router_scaffold-library.html) can manipulate the stack router using the [StackRouterActions](https://pub.dev/documentation/stack_router/latest/stack_router_actions/StackRouterActions-class.html) made available by an `InheritedWidget`.

This makes it easy to show snack bars and change routes from your current route.

```dart
class SecondRoute extends StatelessWidget {
  @override
  build(context) {
    return StackRouterScaffold(
      child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            StackRouterActions.of(context).showSnackBar(
              snackBar: const StackRouterSnackBar(
                title: Text(
                  "I'm a snackbar!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Go back'),
                  onPressed: () {
                    StackRouterActions.of(context).popRoute();
                  }
                )
              ]
            );
          },
          child: const Text(
            "Show snack bar",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
```

## Snack bars

Snack bars are queued per route and can can be shown or hidden with the router snack bar APIs:

* `showSnackBar({ required StackRouterSnackBar snackBar, String? route })` - Display a snack bar on the provided route (default is current route).
* `hideSnackBar({ String? route })` - Clear the current snack bar on the provided route (default is current route).
* `clearSnackBars({ String? route })` - Clear all snack bars from the given route (default is the current route).

In the following example, two snack bars are queued up on the current route when the button is pressed:

```dart
class SecondRoute extends StatelessWidget {
  @override
  build(context) {
    return StackRouterScaffold(
      child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            StackRouterActions.of(context).showSnackBar(
              snackBar: const StackRouterSnackBar(
                title: Text(
                  "I'm a snackbar!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            StackRouterActions.of(context).showSnackBar(
              snackBar: const StackRouterSnackBar(
                title: Text(
                  "I'm another snackbar!",
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
      ),
    );
  }
}
```

![Snack bar demo gif](./demo2.gif).

You can also show snackbars on a different route than the current one:

```dart
class SecondRoute extends StatelessWidget {
  @override
  build(context) {
    return StackRouterScaffold(
      child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            StackRouterActions.of(context).showSnackBar(
              snackBar: const StackRouterSnackBar(
                title: Text(
                  "I'm a snackbar!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            StackRouterActions.of(context).showSnackBar(
              snackBar: const StackRouterSnackBar(
                route: ExampleStackRoutes.firstRoute,
                title: Text(
                  "I'm a snackbar for another route!",
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
      ),
    );
  }
}
```

![Snack bar demo gif](./demo3.gif).

## Persisted Routes

Stack routers pass the widgets specified in the routes list to an `IndexedStack` widget that chooses which route to display. Because routes are managed by an `IndexedStack`, it has some interesting properties like the ability to warm up and persist routes:

```dart
StackRoute(
  route: ExampleStackRoutes.secondRoute,
  persist: true,
  child: Center(
    child: const Text(
      "Second route",
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

By default, a route in the stack router is not built until it has been pushed on. All routes that have been pushed on are maintained in the `StackRouter` history and are persisted so that when you push on a second route and pop back to the first, it is still the same widget instance and has maintained all the temporal state like any form data or changes the user may have made to the route before navigating away.

If you want to warm up a particular route even before it has been navigated to, you can specify `persist: true` on the route so that it will optimistically build when the `StackRouter` is first instantiated. This is useful for routes in a flow that are likely to be navigated to and are slower to build because of network data requirements or deep build trees.

## Building modal flows

Stack routers can be useful for building modal flows and wizards like those that are commonly seen on platforms like desktop web. To build modal flows with `StackRouter`, check out [modal_stack_router](https://pub.dev/packages/modal_stack_router).
