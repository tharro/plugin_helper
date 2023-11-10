import 'package:flutter/material.dart';

/// Allows users to easily select a range of dates.
class MyWidgetDateRangePickerCustom extends StatelessWidget {
  final Widget child;

  /// The start of the range of dates.
  final String? initialFirstDate;

  /// The end of the range of dates.
  final String? initialLastDate;

  /// The returned [Future] resolves to the [DateTimeRange] selected by the user
  /// when the user saves their selection.
  final Function(DateTimeRange) onSelectedDate;

  /// Trigger when the user wants to show modal dialog containing a Material Design date range
  /// picker.
  final Function? onTap;

  /// The style of the text in the button.
  final TextStyle textStyleButton;

  /// Customize header background color.
  final Color headerBackground;

  /// Customize header text color.
  final Color headerTextColor;

  /// Customize body text color.
  final Color bodyTextColor;

  /// Customize text color in the button.
  final Color buttonHoverColor;

  /// The earliest allowable date on the date range.
  final int? firstDate;

  /// The latest allowable date on the date range.
  final int? lastDate;

  const MyWidgetDateRangePickerCustom(
      {Key? key,
      required this.child,
      required this.onSelectedDate,
      this.initialFirstDate,
      this.initialLastDate,
      this.onTap,
      required this.textStyleButton,
      required this.headerBackground,
      required this.headerTextColor,
      required this.bodyTextColor,
      required this.buttonHoverColor,
      this.firstDate,
      this.lastDate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: headerBackground, // header background color
          onPrimary: headerTextColor, // header text color
          onSurface: bodyTextColor, // body text color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: buttonHoverColor, // button text color
          ),
        ),
      ),
      child: Builder(
        builder: (context) => GestureDetector(
          child: child,
          onTap: () async {
            if (onTap != null) {
              onTap!();
            }
            DateTimeRange? picked = await showDateRangePicker(
                context: context,
                initialDateRange: DateTimeRange(
                    start: initialFirstDate != null
                        ? DateTime.parse(initialFirstDate!)
                        : DateTime.now(),
                    end: initialLastDate != null
                        ? DateTime.parse(initialLastDate!)
                        : (DateTime.now()).add(const Duration(days: 7))),
                firstDate: DateTime(firstDate ?? 2015),
                lastDate: DateTime(lastDate ?? DateTime.now().year + 100));
            if (picked != null) {
              onSelectedDate(picked);
            }
          },
        ),
      ),
    );
  }
}
