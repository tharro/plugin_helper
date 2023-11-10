import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

enum ImageType { none, avatar }

/// Load and cache network images.
class MyWidgetCacheImageNetwork extends StatelessWidget {
  /// A URL to load and cache network image.
  final String? imageUrl;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? height;

  /// If a [imageUrl] is the full path to the server, it will use [imageUrl] to load the image.
  ///
  /// If a [imageUrl] is a key and the project uses Cloudfront, it will use [withResize], [heightResize] and [boxFitResize] to get a full link to load the images.
  /// Default is 512.
  final double? withResize, heightResize;

  /// If a [imageUrl] is the full path to the server, it will use [imageUrl] to load the image.
  ///
  /// If a [imageUrl] is a key and the project uses Cloudfront, it will use [withResize], [heightResize] and [boxFitResize] to get a full link to load the images.
  /// Default is cover.
  final BoxFit boxFitResize;

  /// The border radius of the rounded corners. Default is 0.
  final double borderRadius;

  /// How to inscribe the image into the space allocated during layout. Default is cover.
  final BoxFit boxFit;

  /// If non-null, this color is blended with each image pixel using [colorBlendMode].
  final Color? customColor;

  /// A widget will display if a loaded image from the network fails.
  final Widget? errorWidget;

  /// Type of the image. It works if a loaded image from the network fails.
  /// Default is none.
  final ImageType imageType;

  const MyWidgetCacheImageNetwork({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.boxFit = BoxFit.cover,
    this.errorWidget,
    this.customColor,
    this.imageType = ImageType.none,
    this.withResize = 512,
    this.heightResize = 512,
    this.boxFitResize = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl == null || imageUrl!.isEmpty
          ? errorWidget ??
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: imageType == ImageType.avatar
                    ? Icon(
                        Icons.account_circle_rounded,
                        color: Colors.grey,
                        size: (width! / 2),
                      )
                    : null,
              )
          : CachedNetworkImage(
              imageUrl: Uri.parse(imageUrl!).host.isNotEmpty
                  ? imageUrl!
                  : MyPluginHelper.getLinkImage(
                      key: imageUrl!,
                      width: withResize,
                      height: heightResize,
                      fit: boxFitResize),
              color: customColor,
              repeat: ImageRepeat.repeat,
              placeholderFadeInDuration: Duration.zero,
              errorWidget: (_, __, ___) {
                if (imageType == ImageType.avatar) {
                  return Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(borderRadius)),
                      child: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.grey,
                        size: (width! / 2),
                      ));
                }
                return errorWidget ??
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(borderRadius)),
                    );
              },
              placeholder: (context, string) => Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
              width: width,
              height: height,
              fit: boxFit,
            ),
    );
  }
}
