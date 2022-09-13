import 'package:flutter/material.dart';

class MyWidgetExpanded extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Duration? duration;

  const MyWidgetExpanded(
      {Key? key, required this.expand, this.duration, required this.child})
      : super(key: key);

  @override
  _MyWidgetExpandedState createState() => _MyWidgetExpandedState();
}

class _MyWidgetExpandedState extends State<MyWidgetExpanded>
    with SingleTickerProviderStateMixin {
  AnimationController? expandController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 500));
    Animation<double> curve = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    if (widget.expand) {
      expandController!.forward();
    }
  }

  @override
  void didUpdateWidget(MyWidgetExpanded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController!.forward();
    } else {
      expandController!.reverse();
    }
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation!, child: widget.child);
  }
}
