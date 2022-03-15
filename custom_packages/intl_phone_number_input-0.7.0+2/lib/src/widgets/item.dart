import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // SizedBox(width: leadingPadding),
            // _Flag(
            //   country: country,
            //   showFlag: showFlag,
            //   useEmoji: useEmoji,
            // ),
            // SizedBox(width: 12.0),
            Text(
              '$dialCode',
              textDirection: TextDirection.ltr,
              style: textStyle,
            ),
            SizedBox(width: 3),
            Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 35),
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
                    package: 'intl_phone_number_input',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
          )
        : SizedBox.shrink();
  }
}
