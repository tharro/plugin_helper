import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

class WidgetPickerImage extends StatelessWidget {
  final String title;
  final TextStyle titleStyle, itemStyles;
  final String? labelCamera, labelChoosePhoto, labelClose;
  final Function() onTakePhoto, onPickImage;
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
                const Divider(
                  height: 1,
                ),
                GestureDetector(
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
                const Divider(
                  height: 1,
                ),
                GestureDetector(
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
          GestureDetector(
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
