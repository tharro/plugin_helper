import 'package:flutter/material.dart';

import 'date_time_picker/flutter_datetime_picker.dart';

enum DateType { datePicker, dateTimePicker, timePicker, timePicker24h }

/// Allows users to easily select a day.
class MyWidgetDatePicker extends StatelessWidget {
  const MyWidgetDatePicker(
      {Key? key,
      required this.onPress,
      this.initialDate,
      this.lastDate,
      this.firstDate,
      this.onTap,
      required this.itemStyle,
      required this.cancelStyle,
      required this.doneStyle,
      required this.child,
      this.theme,
      this.locale,
      this.dateType = DateType.datePicker})
      : super(key: key);
  final Function(DateTime) onPress;

  /// Display current date on the bottom sheet.
  final DateTime? initialDate;

  /// The earliest allowable date on the date range. If [DateType.datePicker] or [DateType.dateTimePicker] is active.
  final DateTime? firstDate;

  /// The latest allowable date on the date range. If [DateType.datePicker] or [DateType.dateTimePicker] is active.
  final DateTime? lastDate;

  ///
  final Function? onTap;

  /// The style of the text for each item.
  final TextStyle itemStyle;

  /// The style of the text in the cancel button.
  final TextStyle cancelStyle;

  /// The style of the text in the done button.
  final TextStyle doneStyle;

  final Widget child;

  /// Customize date picker theme.
  final DatePickerCustomTheme? theme;

  /// User's language and formatting preferences.
  final LocaleType? locale;

  /// The type of the date picker.
  final DateType dateType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          onTap!();
        }
        switch (dateType) {
          case DateType.datePicker:
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              currentTime: initialDate ?? DateTime.now(),
              locale: locale ?? LocaleType.en,
              minTime: firstDate ?? DateTime(1900, 1),
              maxTime: lastDate ?? DateTime(2122, 7),
              theme: _theme,
              onConfirm: _onConfirm,
            );
            break;
          case DateType.dateTimePicker:
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              currentTime: initialDate ?? DateTime.now(),
              locale: locale ?? LocaleType.en,
              minTime: firstDate ?? DateTime(1900, 1),
              maxTime: lastDate ?? DateTime(2122, 7),
              theme: _theme,
              onConfirm: _onConfirm,
            );
            break;
          case DateType.timePicker:
            DatePicker.showTimePicker(
              context,
              showTitleActions: true,
              currentTime: initialDate ?? DateTime.now(),
              locale: locale ?? LocaleType.en,
              theme: _theme,
              onConfirm: _onConfirm,
            );
            break;
          case DateType.timePicker24h:
            DatePicker.showTime12hPicker(
              context,
              showTitleActions: true,
              currentTime: initialDate ?? DateTime.now(),
              locale: locale ?? LocaleType.en,
              theme: _theme,
              onConfirm: _onConfirm,
            );
            break;
          default:
        }
      },
      child: child,
    );
  }

  _onConfirm(DateTime date) {
    onPress(date);
  }

  DatePickerCustomTheme get _theme =>
      theme ??
      DatePickerCustomTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: itemStyle,
          cancelStyle: cancelStyle,
          doneStyle: doneStyle);
}
