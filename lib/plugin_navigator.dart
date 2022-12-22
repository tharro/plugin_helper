import 'package:flutter/material.dart';

class MyPluginNavigation<T> {
  GlobalKey<NavigatorState>? navigationKey;

  static MyPluginNavigation instance = MyPluginNavigation();

  MyPluginNavigation() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  ///Push page without context
  Future<void> replace(Widget _rn, {bool isFadeRoute = false}) {
    return navigationKey!.currentState!.pushReplacement(isFadeRoute
        ? FadePageRoute(child: _rn)
        : MaterialPageRoute(builder: (_) => _rn));
  }

  Future<void> push(Widget _rn) {
    return navigationKey!.currentState!
        .push(MaterialPageRoute(builder: (_) => _rn));
  }

  Future<void> navigatePopUtil(Widget _rn) {
    navigationKey!.currentState!.popUntil((route) => route.isFirst);
    return replace(_rn);
  }

  Future<void> navigateToReplacementInTab(
      {required BuildContext context,
      bool isHoldTab = true,
      required Widget screen,
      PageRoute<T>? pageRoute}) async {
    await Navigator.of(context, rootNavigator: !isHoldTab).pushReplacement(
      pageRoute ??
          _buildAdaptivePageRoute(
            builder: (context) => screen,
          ),
    );
  }

  Future<void> navigateToInTab(
      {required BuildContext context,
      bool isHoldTab = true,
      required Widget screen,
      PageRoute<T>? pageRoute}) async {
    await Navigator.of(context, rootNavigator: !isHoldTab).push(
      pageRoute ??
          _buildAdaptivePageRoute(
            builder: (context) => screen,
          ),
    );
  }

  void goBack({T? callback}) {
    return navigationKey!.currentState!.pop(callback);
  }

  PageRoute<T> _buildAdaptivePageRoute<T>({
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
