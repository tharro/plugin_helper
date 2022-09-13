import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:plugin_helper/index.dart';

class PhotoViewCustom extends StatefulWidget {
  PhotoViewCustom({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
    required this.images,
    this.customChild,
    this.customCloseIcon,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final List<String> images;
  final Widget? customChild, customCloseIcon;
  @override
  State<StatefulWidget> createState() {
    return _PhotoViewCustomState();
  }
}

class _PhotoViewCustomState extends State<PhotoViewCustom> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
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
            if (widget.customCloseIcon == null)
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            else
              widget.customCloseIcon!,
            if (widget.customChild != null) widget.customChild!
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: SizedBox(
        width: 300,
        height: 300,
        child: MyWidgetCacheImageNetwork(imageUrl: widget.images[index]),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: const PhotoViewHeroAttributes(tag: ''),
    );
  }
}
