import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/phone_number/src/models/country_model.dart';
import 'package:plugin_helper/widgets/phone_number/src/utils/util.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final BoxDecoration? boxDecoration;
  final Widget? iconRight;
  final Widget? iconLeft;
  final EdgeInsets? flagPadding;
  final double? heightItem;
  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.boxDecoration,
    this.iconRight,
    this.iconLeft,
    this.flagPadding,
    this.heightItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    return Container(
      decoration: boxDecoration ??
          BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
      height: heightItem ?? 50,
      child: Center(
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (iconLeft != null) iconLeft!,
            if (showFlag!)
              Padding(
                padding: flagPadding ?? EdgeInsets.zero,
                child: _Flag(
                  country: country,
                  showFlag: showFlag,
                  useEmoji: useEmoji,
                ),
              ),
            Text(
              dialCode,
              textDirection: TextDirection.ltr,
              style: textStyle,
            ),
            if (iconRight != null) iconRight!,
          ],
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : Image.asset(
                    country!.flagUri,
                    width: 32.0,
                    package: 'plugin_helper',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
          )
        : SizedBox.shrink();
  }
}
