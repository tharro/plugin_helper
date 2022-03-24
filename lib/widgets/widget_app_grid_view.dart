import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWidgetAppGridView extends StatefulWidget {
  final List data;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(dynamic item, int index) renderItem;
  final Function()? onLoadMore;
  final RefreshController refreshController;
  final Function() onRefresh;
  final bool isLoadMore;
  final Color colorRefresh;
  final Widget? loadingLoadmoreWidget;
  const MyWidgetAppGridView(
      {Key? key,
      required this.data,
      required this.renderItem,
      this.crossAxisSpacing = 12,
      this.mainAxisSpacing = 16,
      this.crossAxisCount = 2,
      this.childAspectRatio = 1 / 1.5,
      this.onLoadMore,
      required this.refreshController,
      required this.onRefresh,
      this.isLoadMore = false,
      required this.colorRefresh,
      this.loadingLoadmoreWidget})
      : super(key: key);
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
      header: WaterDropMaterialHeader(
        backgroundColor: widget.colorRefresh,
      ),
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
        controller: controller,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return Center(
              child: widget.loadingLoadmoreWidget ?? Container(),
            );
          }
          return widget.renderItem(widget.data[index], index);
        },
        itemCount:
            widget.isLoadMore ? widget.data.length + 1 : widget.data.length,
      ),
    );
  }

  void _scrollListener() {
    var triggerFetchMoreSize = controller.position.maxScrollExtent;
    if (widget.onLoadMore is Function &&
        controller.position.pixels > triggerFetchMoreSize) {
      widget.onLoadMore!();
    }
  }
}
