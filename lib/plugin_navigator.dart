import 'package:flutter/material.dart';

/// Manage navigator
class MyPluginNavigation<T> {
  /// A key to use when building the [Navigator].
  GlobalKey<NavigatorState>? navigationKey;

  static MyPluginNavigation instance = MyPluginNavigation();

  MyPluginNavigation() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  PageRoute<T> buildAdaptivePageRoute<T>({
    required WidgetBuilder builder,
    bool fullScreenDialog = false,
  }) =>
      MaterialPageRoute(
        builder: builder,
        fullscreenDialog: fullScreenDialog,
      );
}

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.color = Colors.white,
  });
  @override
  Color get barrierColor => color;

  @override
  String get barrierLabel => '';

  final Widget child;
  final Duration duration;
  final Color color;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;

  AnimatedRoute(this.widget)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
