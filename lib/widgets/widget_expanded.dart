import 'package:flutter/material.dart';

/// This widget have an expand/collapse for users to show/hide additional content.
class MyWidgetExpanded extends StatefulWidget {
  final Widget child;

  /// This property indicates whether the widget is expanded or not.
  final bool expand;

  /// The length of time this animation should last.
  final Duration? duration;

  const MyWidgetExpanded(
      {Key? key, required this.expand, this.duration, required this.child})
      : super(key: key);

  @override
  _MyWidgetExpandedState createState() => _MyWidgetExpandedState();
}

class _MyWidgetExpandedState extends State<MyWidgetExpanded>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
  }

  ///Setting up the animation
  void _prepareAnimations() {
    _expandController = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 500));
    Animation<double> curve = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    if (widget.expand) {
      _expandController.forward();
    }
  }

  @override
  void didUpdateWidget(MyWidgetExpanded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: _animation, child: widget.child);
  }
}
