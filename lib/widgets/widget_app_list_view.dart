import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_message_require.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWidgetAppListView<T> extends StatefulWidget {
  final List<T> data;
  final Function()? onLoadMore;
  final Axis scrollDirection;
  final Widget Function(int index) renderItem;
  final bool enablePullDown;
  final bool isNeverScroll;
  final Function()? onRefresh;
  final RefreshController? refreshController;
  final double separatorItem;
  final EdgeInsets? padding;
  final Widget? separatorBuilder;
  final bool? isLoadingMore, reverse;
  final ScrollController? scrollController;
  final Function(ScrollController)? onScrollListener;
  final Widget loadingWidget;
  final double? heightListViewHorizontal, paddingHorizontal;

  const MyWidgetAppListView({
    Key? key,
    required this.data,
    this.onLoadMore,
    this.scrollDirection = Axis.vertical,
    required this.renderItem,
    this.enablePullDown = true,
    this.isNeverScroll = false,
    this.onRefresh,
    this.refreshController,
    this.separatorItem = 24.0,
    this.padding,
    this.separatorBuilder,
    this.isLoadingMore = false,
    this.scrollController,
    this.heightListViewHorizontal = 200,
    this.paddingHorizontal = 16,
    this.reverse = false,
    this.onScrollListener,
    required this.loadingWidget,
  }) : super(key: key);
  @override
  AppListViewState createState() => AppListViewState();
}

class AppListViewState extends State<MyWidgetAppListView> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      controller = widget.scrollController!;
      controller.addListener(_scrollListener);
    } else {
      controller = ScrollController()..addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refreshController != null) {
      return SmartRefresher(
          controller: widget.refreshController!,
          enablePullDown: widget.enablePullDown,
          header: kIsWeb
              ? null
              : Platform.isIOS
                  ? const ClassHeaderGridIndicator()
                  : const MaterialClassicHeader(),
          onRefresh: () {
            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          },
          child: listView());
    }
    return switchDirection();
  }

  Widget switchDirection() {
    if (widget.scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: widget.heightListViewHorizontal,
        child: listView(),
      );
    }
    return listView();
  }

  Widget listView() => ListView.separated(
        padding: widget.padding,
        physics: widget.isNeverScroll
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        scrollDirection: widget.scrollDirection,
        controller: controller,
        reverse: widget.reverse!,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return Center(child: widget.loadingWidget);
          }
          if (widget.scrollDirection == Axis.horizontal) {
            return Row(children: [
              if (index == 0) SizedBox(width: widget.paddingHorizontal),
              widget.renderItem(index),
              if (index == widget.data.length - 1)
                SizedBox(width: widget.paddingHorizontal),
            ]);
          }
          return widget.renderItem(index);
        },
        itemCount:
            widget.isLoadingMore! ? widget.data.length + 1 : widget.data.length,
        separatorBuilder: (BuildContext context, int index) {
          if (widget.scrollDirection == Axis.horizontal) {
            return widget.separatorBuilder ??
                SizedBox(
                  width: widget.separatorItem,
                );
          }
          return widget.separatorBuilder ??
              SizedBox(
                height: widget.separatorItem,
              );
        },
      );

  void _scrollListener() {
    if (widget.onScrollListener != null) {
      widget.onScrollListener!(controller);
    }
    if (widget.onLoadMore != null && controller.position.extentAfter < 200) {
      widget.onLoadMore!();
    }
  }
}

class ClassHeaderGridIndicator extends StatelessWidget {
  const ClassHeaderGridIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
        refreshingText: MyPluginMessageRequire.refreshingText,
        completeText: MyPluginMessageRequire.completeText,
        releaseText: MyPluginMessageRequire.releaseText,
        idleText: MyPluginMessageRequire.idleText);
  }
}
