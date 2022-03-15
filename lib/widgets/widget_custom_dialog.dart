import 'dart:ui';

import 'package:flutter/material.dart';

class WidgetCustomDialog extends StatefulWidget {
  final String title, descriptions;
  final Function()? onClose;
  final bool? isShowSecondButton;
  final TextStyle textStyleTitle;
  final TextStyle? texStyleDescription;
  final Widget buttonPrimary;
  final Widget? buttonSecondary;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Widget? iconClose;
  final double? radius, space;
  final bool? isColumn;
  const WidgetCustomDialog({
    Key? key,
    required this.title,
    required this.descriptions,
    this.onClose,
    this.isShowSecondButton = false,
    required this.textStyleTitle,
    this.texStyleDescription,
    required this.buttonPrimary,
    this.buttonSecondary,
    this.backgroundColor,
    this.padding,
    this.iconClose,
    this.radius,
    this.isColumn = true,
    this.space = 6,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<WidgetCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.radius ?? 10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: Center(
                  child: Text(
                    widget.title,
                    style: widget.textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
                            size: 25,
                          ))),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.descriptions,
            style: widget.texStyleDescription,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.isColumn!)
            Column(
              children: [
                widget.buttonPrimary,
                SizedBox(height: widget.space),
                if (widget.isShowSecondButton!) widget.buttonSecondary!
              ],
            )
          else
            Row(
              children: [
                widget.buttonPrimary,
                SizedBox(width: widget.space),
                if (widget.isShowSecondButton!) widget.buttonSecondary!
              ],
            )
        ],
      ),
    );
  }
}
