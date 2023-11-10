import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

/// Allows users to easily select a image.
class WidgetPickerImage extends StatelessWidget {
  /// The title of the widget.
  final String title;

  /// The text styles of the title.
  final TextStyle titleStyle;

  /// The text styles of the item.
  final TextStyle itemStyles;

  /// Provide [labelCamera], [labelChoosePhoto] and [labelClose] if you want to
  /// customize labels.
  final String? labelCamera, labelChoosePhoto, labelClose;

  /// Trigger when the user selects take a photo.
  final VoidCallback onTakePhoto;

  /// Trigger when the user selects pick an image from the gallery.
  final VoidCallback onPickImage;

  /// Add other widgets after [labelCamera] and [labelChoosePhoto]
  final Widget? children;

  const WidgetPickerImage(
      {Key? key,
      required this.title,
      required this.titleStyle,
      required this.itemStyles,
      required this.onTakePhoto,
      required this.onPickImage,
      this.labelCamera,
      this.labelChoosePhoto,
      this.labelClose,
      this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title,
                    style: titleStyle,
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                InkWell(
                  onTap: () async {
                    onTakePhoto();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          labelCamera ?? "Take photo",
                          style: itemStyles,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                InkWell(
                  onTap: () async {
                    onPickImage();
                  },
                  child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            labelChoosePhoto ?? "Choose from Library",
                            style: itemStyles,
                          ),
                        ),
                      )),
                ),
                if (children != null) children!
              ],
            ),
          ),
          8.h,
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                labelClose ?? "Close",
                style: itemStyles,
              ),
            ),
          )
        ],
      ),
    );
  }
}
