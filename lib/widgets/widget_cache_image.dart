import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

enum ImageType { none, avatar }

class MyWidgetCacheImageNetwork extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit boxFit;
  final Color? customColor;
  final Widget? errorWidget;
  final ImageType imageType;
  final bool useLinkCloudFont;
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
    this.useLinkCloudFont = false,
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
              imageUrl: useLinkCloudFont
                  ? MyPluginAppEnvironment().linkCloudfront! + imageUrl!
                  : imageUrl!,
              color: customColor,
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
