import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyWidgetPhotoViewCustom extends StatefulWidget {
  MyWidgetPhotoViewCustom({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
    required this.images,
    this.customHeader,
    this.customFooter,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final List<String> images;
  final Widget? customHeader, customFooter;
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetPhotoViewCustomState();
  }
}

class _MyWidgetPhotoViewCustomState extends State<MyWidgetPhotoViewCustom> {
  late int _currentIndex = widget.initialIndex;
  bool _isShowClose = false;

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
          onTap: () {
            setState(() {
              _isShowClose = !_isShowClose;
            });
          },
          child: Container(
            decoration: widget.backgroundDecoration,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.images.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: onPageChanged,
                  scrollDirection: widget.scrollDirection,
                ),
                AnimatedOpacity(
                    // If the widget is visible, animate to 0.0 (invisible).
                    // If the widget is hidden, animate to 1.0 (fully visible).
                    opacity: _isShowClose ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    // The green box must be a child of the AnimatedOpacity widget.
                    child: widget.customHeader ??
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.2)))),
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16, top: 25),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                ),
                              )),
                        )),
                if (widget.customFooter != null)
                  AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _isShowClose ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: widget.customFooter!)
              ],
            ),
          )),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    bool isFromUrl = widget.images[index].contains('http') ||
        widget.images[index].contains('https');
    ImageProvider<Object>? imageProvider = (isFromUrl
        ? NetworkImage(widget.images[index])
        : AssetImage(widget.images[index])) as ImageProvider<Object>?;
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: const PhotoViewHeroAttributes(tag: ''),
    );
  }
}
