import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

class MyWidgetAppGridView<T> extends StatefulWidget {
  final List<T> data;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(int index) renderItem;
  final VoidCallback? onLoadMore;
  final VoidCallback? onScrollListener;
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final bool isLoadingMore;
  final Color colorRefresh;
  final Widget loadingMoreWidget;
  final bool shrinkWrap;
  final EdgeInsets? padding;
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
          : Platform.isIOS
              ? const ClassHeaderGridIndicator()
              : const MaterialClassicHeader(),
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

    if (widget.onLoadMore != null && _controller.position.extentAfter < 200) {
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
