import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/image_element_model.dart';

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
    this.onPageChanged,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final Widget? customHeader, customFooter;
  final List<ImageElementModel> images;
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
                  itemCount: widget.images.length,
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
    if (widget.images[index].bytes != null) {
      return _customChild(Image.memory(widget.images[index].bytes!),
          index: index);
    }

    bool isFromUrl = widget.images[index].url!.contains('http') ||
        widget.images[index].url!.contains('https');
    if ((Platform.isMacOS || Platform.isWindows || Platform.isLinux) &&
        !isFromUrl) {
      return _customChild(Image.file(File(widget.images[index].url!)),
          index: index);
    }

    ImageProvider<Object>? imageProvider = (isFromUrl
        ? NetworkImage(widget.images[index].url!)
        : AssetImage(widget.images[index].url!)) as ImageProvider<Object>?;
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: const PhotoViewHeroAttributes(tag: ''),
    );
  }
}
