import 'package:flutter/material.dart';

class MyWidgetCustomDialog extends StatefulWidget {
  final String? title, descriptions;
  final Function()? onClose;
  final bool? isShowSecondButton;
  final TextStyle? textStyleTitle;
  final TextStyle? texStyleDescription;
  final Widget buttonPrimary;
  final Widget? buttonSecondary;
  final Color? backgroundColor;
  final EdgeInsets? paddingContainer;
  final Widget? iconClose;
  final double? spaceBetweenButton,
      spaceBetweenTitleAndMessage,
      spaceBetweenMessageAndButton,
      shapeRadius;
  final bool? isColumn, isShowCloseIcon;
  const MyWidgetCustomDialog({
    Key? key,
    this.title,
    this.descriptions,
    this.onClose,
    this.isShowSecondButton = false,
    this.textStyleTitle,
    this.texStyleDescription,
    required this.buttonPrimary,
    this.buttonSecondary,
    this.backgroundColor,
    this.paddingContainer,
    this.iconClose,
    this.isColumn = true,
    this.isShowCloseIcon = true,
    this.spaceBetweenButton = 6,
    this.spaceBetweenTitleAndMessage = 8,
    this.spaceBetweenMessageAndButton = 40,
    this.shapeRadius = 10,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<MyWidgetCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.shapeRadius!),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
        padding: widget.paddingContainer ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.shapeRadius!),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.title != null)
                  Center(
                    child: Text(
                      widget.title!,
                      style: widget.textStyleTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (widget.title != null || widget.isShowCloseIcon!)
                  SizedBox(height: widget.spaceBetweenTitleAndMessage!),
                if (widget.descriptions != null)
                  Text(
                    widget.descriptions!,
                    style: widget.texStyleDescription,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: widget.spaceBetweenMessageAndButton!),
                if (widget.isColumn!)
                  Column(
                    children: [
                      widget.buttonPrimary,
                      SizedBox(height: widget.spaceBetweenButton),
                      if (widget.isShowSecondButton!) widget.buttonSecondary!
                    ],
                  )
                else
                  Row(
                    children: [
                      if (widget.isShowSecondButton!) widget.buttonSecondary!,
                      SizedBox(width: widget.spaceBetweenButton),
                      widget.buttonPrimary,
                    ],
                  )
              ],
            ),
            if (widget.isShowCloseIcon!)
              Positioned(
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (widget.onClose != null) {
                          widget.onClose!();
                        }
                      },
                      child: widget.iconClose ??
                          const Icon(
                            Icons.close,
                            size: 15,
                          )))
          ],
        ));
  }
}
