import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_message_require.dart';
import 'package:plugin_helper/widgets/widget_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWidgetAppListView extends StatefulWidget {
  final List data;
  final Function()? onLoadMore;
  final Axis scrollDirection;
  final Function renderItem;
  final bool enablePullDown;
  final bool isNeverScroll;
  final Function()? onRefresh;
  final RefreshController refreshController;
  final double height;
  final EdgeInsets? padding;
  final Widget? separator;
  final bool? isLoadMore;
  final ScrollController? scrollController;
  final Widget? loadingWidget;
  final String? refreshingText, completeText, releaseText, idleText;
  const MyWidgetAppListView({
    Key? key,
    required this.data,
    this.onLoadMore,
    this.scrollDirection = Axis.vertical,
    required this.renderItem,
    this.enablePullDown = true,
    this.isNeverScroll = false,
    this.onRefresh,
    required this.refreshController,
    this.height = 24.0,
    this.padding,
    this.separator,
    this.isLoadMore = false,
    this.scrollController,
    this.loadingWidget,
    this.refreshingText,
    this.completeText,
    this.releaseText,
    this.idleText,
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
    if (widget.onRefresh != null) {
      return SmartRefresher(
          controller: widget.refreshController,
          enablePullDown: widget.enablePullDown,
          header: Platform.isIOS
              ? const ClassHeaderIndicator()
              : const MaterialClassicHeader(),
          onRefresh: () {
            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          },
          child: listView());
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
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return Center(
              child: widget.loadingWidget ?? const MyWidgetLoading(),
            );
          }
          return widget.renderItem(widget.data[index], index);
        },
        itemCount:
            widget.isLoadMore! ? widget.data.length + 1 : widget.data.length,
        separatorBuilder: (BuildContext context, int index) {
          return widget.separator ??
              SizedBox(
                height: widget.height,
              );
        },
      );

  void _scrollListener() {
    var triggerFetchMoreSize = controller.position.maxScrollExtent;
    if (widget.onLoadMore != null &&
        controller.position.pixels == triggerFetchMoreSize) {
      widget.onLoadMore!();
    }
  }
}

class ClassHeaderIndicator extends StatelessWidget {
  const ClassHeaderIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
        refreshingText: MyPluginMessageRequire.messRefreshingText,
        completeText: MyPluginMessageRequire.messCompleteText,
        releaseText: MyPluginMessageRequire.messReleaseText,
        idleText: MyPluginMessageRequire.messIdleText);
  }
}
