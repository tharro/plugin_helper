import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_message_require.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// MyWidgetAppListView is the most commonly used scrolling customize widget.
/// It displays its children one after another in the scroll direction.
class MyWidgetAppListView<T> extends StatefulWidget {
  /// Data of the list.
  final List<T> data;

  /// This function [onLoadMore] calls the API to get more data
  /// when the user scrolls to the end of the list.
  final VoidCallback? onLoadMore;

  /// Direction of the list.
  final Axis scrollDirection;

  /// The renderItem callback will be called with indices greater than or equal to zero and less than itemCount.
  final Widget Function(int index) renderItem;

  /// This bool will affect whether or not to have the function of drop-down refresh.
  final bool enablePullDown;

  /// This bool will affect whether or not to have the function of scrolling.
  final bool isNeverScroll;

  /// Trigger when the user pull to refresh page if [refreshController] not null.
  final VoidCallback? onRefresh;

  /// A controller control header and footer state, it can trigger driving request Refresh, set the initalRefresh, status if needed.
  final RefreshController? refreshController;

  /// A separation evenly between each item. Default is 24.0
  final double separatorItem;

  /// To add empty space inside the list view.
  final EdgeInsets? padding;

  /// Customize separation evenly between each item.
  final Widget? separatorBuilder;

  /// Waiting for a response from the server when the user scrolled to the end of the list
  /// and the application triggered a request function to get more data from the server.
  final bool isLoadingMore;

  /// Reverse the order of your list before returning the ListView element. Default is false.
  final bool reverse;

  /// Controls a scrollable widget.
  final ScrollController? scrollController;

  /// Return [ScrollController] when user scrolls the list.
  final Function(ScrollController)? onScrollListener;

  /// Display a widget when waiting for a response from the server.
  final Widget loadingWidget;

  /// Set height of the list. Only for horizontal list.
  final double heightListViewHorizontal;

  /// Set a separation evenly between each item. Only for horizontal list.
  final double paddingHorizontal;

  /// Customize a header indicator displace before content.
  final Widget? customHeaderRefresh;

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
    this.customHeaderRefresh,
  }) : super(key: key);
  @override
  AppListViewState createState() => AppListViewState();
}

class AppListViewState extends State<MyWidgetAppListView> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _controller = widget.scrollController!;
      _controller.addListener(_scrollListener);
    } else {
      _controller = ScrollController()..addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
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
              : widget.customHeaderRefresh ??
                  (Platform.isIOS
                      ? const ClassHeaderGridIndicator()
                      : const MaterialClassicHeader()),
          onRefresh: () {
            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          },
          child: _listView());
    }
    return _switchDirection();
  }

  Widget _switchDirection() {
    if (widget.scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: widget.heightListViewHorizontal,
        child: _listView(),
      );
    }
    return _listView();
  }

  Widget _listView() => ListView.separated(
        padding: widget.padding,
        physics: widget.isNeverScroll
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        scrollDirection: widget.scrollDirection,
        controller: _controller,
        reverse: widget.reverse,
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
            widget.isLoadingMore ? widget.data.length + 1 : widget.data.length,
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
      widget.onScrollListener!(_controller);
    }
    if (widget.onLoadMore != null &&
        _controller.position.pixels > _controller.position.maxScrollExtent) {
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
