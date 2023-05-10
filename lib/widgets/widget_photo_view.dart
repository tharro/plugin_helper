import 'dart:io';
import 'dart:typed_data';

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
    this.images,
    this.imagesUint8List,
    this.customHeader,
    this.customFooter,
    this.onPageChanged,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final List<String>? images;
  final List<Uint8List>? imagesUint8List;
  final Widget? customHeader, customFooter;
  final void Function(int index)? onPageChanged;
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetPhotoViewCustomState();
  }
}

class _MyWidgetPhotoViewCustomState extends State<MyWidgetPhotoViewCustom> {
  bool _isShowClose = false;

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
                  itemCount:
                      widget.images?.length ?? widget.imagesUint8List!.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: widget.onPageChanged,
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

  PhotoViewGalleryPageOptions _customChild(Widget child, {required int index}) {
    return PhotoViewGalleryPageOptions.customChild(
      child: child,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: const PhotoViewHeroAttributes(tag: ''),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    if (widget.imagesUint8List != null) {
      return _customChild(Image.memory(widget.imagesUint8List![index]),
          index: index);
    }

    bool isFromUrl = widget.images![index].contains('http') ||
        widget.images![index].contains('https');
    if ((Platform.isMacOS || Platform.isWindows || Platform.isLinux) &&
        !isFromUrl) {
      return _customChild(Image.file(File(widget.images![index])),
          index: index);
    }

    ImageProvider<Object>? imageProvider = (isFromUrl
        ? NetworkImage(widget.images![index])
        : AssetImage(widget.images![index])) as ImageProvider<Object>?;
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: const PhotoViewHeroAttributes(tag: ''),
    );
  }
}
