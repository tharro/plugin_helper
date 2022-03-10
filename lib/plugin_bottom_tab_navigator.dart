import 'package:flutter/material.dart';

class PluginBottomTabNavigation {
  GlobalKey<NavigatorState>? navigationKey;

  static PluginBottomTabNavigation instance = PluginBottomTabNavigation();

  PluginBottomTabNavigation() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  ///Push page without context
  Future<dynamic> replace(Widget _rn, {bool isFadeRoute = false}) {
    return navigationKey!.currentState!.pushReplacement(isFadeRoute
        ? FadePageRoute(child: _rn)
        : MaterialPageRoute(builder: (_) => _rn));
  }

  Future<dynamic> push(Widget _rn) {
    return navigationKey!.currentState!
        .push(MaterialPageRoute(builder: (_) => _rn));
  }

  Future<dynamic> navigatePopUtil(Widget _rn) {
    return navigationKey!.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => _rn), (route) => false);
  }

  Future<dynamic> pushAnimationRoute(Widget widget) {
    return navigationKey!.currentState!.push(AnimatedRoute(widget));
  }

  Future<dynamic> navigateToReplacementInTab(
      {required BuildContext context,
      bool isHoldTab = true,
      required Widget screen}) async {
    final complete =
        await Navigator.of(context, rootNavigator: !isHoldTab).pushReplacement(
      _buildAdaptivePageRoute(
        builder: (context) => screen,
      ),
    );
    return complete;
  }

  Future<dynamic> navigateToInTab(
      {required BuildContext context,
      bool isHoldTab = true,
      required Widget screen,
      customRoute}) async {
    final complete =
        await Navigator.of(context, rootNavigator: !isHoldTab).push(
      customRoute ??
          _buildAdaptivePageRoute(
            builder: (context) => screen,
          ),
    );
    return complete;
  }

  goBack() {
    return navigationKey!.currentState!.pop();
  }

  Future<dynamic> pushFadeRoute(BuildContext context, Widget _rn) {
    return Navigator.of(context).push(FadePageRoute(child: _rn));
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
