import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:plugin_helper/plugin_message_require.dart';

class MyWidgetAppGridView<T> extends StatefulWidget {
  final List<T> data;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(int index) renderItem;
  final Function()? onLoadMore;
  final Function()? onScrollListener;
  final RefreshController refreshController;
  final Function() onRefresh;
  final bool isLoadingMore;
  final Color colorRefresh;
  final Widget loadingMoreWidget;
  final bool shrinkWrap;
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
  }) : super(key: key);
  @override
  _AppGridViewState createState() => _AppGridViewState();
}

class _AppGridViewState extends State<MyWidgetAppGridView> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: widget.refreshController,
      header: Platform.isIOS
          ? const ClassHeaderIndicator()
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
        shrinkWrap: widget.shrinkWrap,
        controller: controller,
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
    if (widget.onLoadMore is Function &&
        controller.position.extentAfter < 200) {
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
