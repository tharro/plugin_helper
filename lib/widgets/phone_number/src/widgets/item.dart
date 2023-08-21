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
  final BoxDecoration? boxDecoration;
  final Widget? iconRight;
  final Widget? iconLeft;
  final EdgeInsets? flagPadding;
  final double? heightItem;
  final double? radius;
  final double? width, height;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.boxDecoration,
    this.iconRight,
    this.iconLeft,
    this.flagPadding,
    this.heightItem,
    this.radius,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    return Container(
        decoration: boxDecoration,
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (iconLeft != null) iconLeft!,
            if (showFlag!)
              Padding(
                padding: flagPadding ?? EdgeInsets.zero,
                child: Flag(
                  country: country,
                  showFlag: showFlag,
                  useEmoji: useEmoji,
                  height: height,
                  width: width,
                  radius: radius,
                ),
              ),
            Text(
              dialCode,
              textDirection: TextDirection.ltr,
              style: textStyle,
            ),
            if (iconRight != null) iconRight!,
          ],
        ));
  }
}

class Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final double? radius;
  final double? width, height;

  const Flag(
      {Key? key,
      this.country,
      this.showFlag,
      this.useEmoji,
      this.radius,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? useEmoji!
            ? Text(
                Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                style: Theme.of(context).textTheme.headlineSmall,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 0),
                child: Image.asset(
                  country!.flagUri,
                  width: width ?? 32.0,
                  height: height,
                  fit: BoxFit.cover,
                  package: 'plugin_helper',
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              )
        : const SizedBox.shrink();
  }
}
