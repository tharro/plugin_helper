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
  final EdgeInsets? paddingHeader, paddingFooter, paddingCloseIcon;
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
    this.paddingHeader,
    this.paddingFooter,
    this.iconClose,
    this.isColumn = true,
    this.isShowCloseIcon = true,
    this.spaceBetweenButton = 6,
    this.spaceBetweenTitleAndMessage = 8,
    this.spaceBetweenMessageAndButton = 40,
    this.shapeRadius = 10,
    this.paddingCloseIcon,
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
                Padding(
                  padding: widget.paddingHeader ??
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
                if (widget.isColumn!)
                  Padding(
                    padding: widget.paddingFooter ??
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Column(
                      children: [
                        widget.buttonPrimary,
                        if (widget.isShowSecondButton!)
                          SizedBox(height: widget.spaceBetweenButton),
                        if (widget.isShowSecondButton!) widget.buttonSecondary!
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: widget.paddingFooter ??
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Row(
                      children: [
                        if (widget.isShowSecondButton!)
                          Expanded(
                            child: widget.buttonSecondary!,
                          ),
                        if (widget.isShowSecondButton!)
                          SizedBox(width: widget.spaceBetweenButton),
                        Expanded(child: widget.buttonPrimary),
                      ],
                    ),
                  )
              ],
            ),
            if (widget.isShowCloseIcon!)
              Positioned(
                  right: 0,
                  child: Padding(
                    padding: widget.paddingCloseIcon ??
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
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
                            )),
                  ))
          ],
        ));
  }
}
