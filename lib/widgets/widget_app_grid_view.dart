import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

/// MyWidgetAppGridView is a customize widget that displays a list of items as a 2D array.
class MyWidgetAppGridView<T> extends StatefulWidget {
  /// Data of the list.
  final List<T> data;

  /// Creates a delegate that makes grid layouts with a fixed number
  /// of tiles in the cross axis.
  final double crossAxisSpacing, mainAxisSpacing, childAspectRatio;

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The renderItem callback will be called with indices greater than or equal to zero and less than itemCount.
  final Widget Function(int index) renderItem;

  /// This function [onLoadMore] calls the API to get more data
  /// when the user scrolls to the end of the list.
  final VoidCallback? onLoadMore;

  /// Return [ScrollController] when user scrolls the list.
  final VoidCallback? onScrollListener;

  /// A controller control header and footer state, it can trigger driving request Refresh, set the initalRefresh, status if needed.
  final RefreshController refreshController;

  /// Trigger when the user pull to refresh page if [refreshController] not null.
  final VoidCallback onRefresh;

  /// Waiting for a response from the server when the user scrolled to the end of the list
  /// and the application triggered a request function to get more data from the server.
  final bool isLoadingMore;

  /// Set color of the refresher.
  final Color colorRefresh;

  /// Display a widget when the user scrolled to the end of the list
  /// and the application triggered a request function to get more data from the server.
  final Widget loadingMoreWidget;

  /// Every ScrollView have a [shrinkWrap] property for determining the size of [scrollDirection].
  final bool shrinkWrap;

  /// To add empty space inside the list view.
  final EdgeInsets? padding;

  /// Customize a header indicator displace before content.
  final Widget? customHeaderRefresh;

  const MyWidgetAppGridView({
    Key? key,
    required this.data,
    required this.renderItem,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 16,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1 / 1.5,
    this.onLoadMore,
    required this.refreshController,
    required this.onRefresh,
    this.isLoadingMore = false,
    required this.colorRefresh,
    required this.loadingMoreWidget,
    this.onScrollListener,
    this.shrinkWrap = false,
    this.padding,
    this.customHeaderRefresh,
  }) : super(key: key);
  @override
  _AppGridViewState createState() => _AppGridViewState();
}

class _AppGridViewState extends State<MyWidgetAppGridView> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: widget.refreshController,
      header: kIsWeb
          ? null
          : widget.customHeaderRefresh ??
              (Platform.isIOS
                  ? const ClassHeaderGridIndicator()
                  : const MaterialClassicHeader()),
      onRefresh: () {
        widget.onRefresh();
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
        ),
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return Center(
              child: widget.loadingMoreWidget,
            );
          }
          return widget.renderItem(index);
        },
        itemCount:
            widget.isLoadingMore ? widget.data.length + 1 : widget.data.length,
      ),
    );
  }

  void _scrollListener() {
    if (widget.onScrollListener != null) {
      widget.onScrollListener!();
    }

    if (widget.onLoadMore != null &&
        _controller.position.pixels > _controller.position.maxScrollExtent) {
      widget.onLoadMore!();
    }
  }
}

class ClassHeaderIndicator extends StatelessWidget {
  const ClassHeaderIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
        refreshingText: MyPluginMessageRequire.refreshingText,
        completeText: MyPluginMessageRequire.completeText,
        releaseText: MyPluginMessageRequire.releaseText,
        idleText: MyPluginMessageRequire.idleText);
  }
}
