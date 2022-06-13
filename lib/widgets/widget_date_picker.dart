import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum DateType { datePicker, dateTimePicker, timePicker, timePicker24h }

class MyWidgetDatePicker extends StatelessWidget {
  const MyWidgetDatePicker(
      {Key? key,
      this.date,
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
  final String? date;
  final Function(DateTime) onPress;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Function? onTap;
  final TextStyle itemStyle, cancelStyle, doneStyle;
  final Widget child;
  final DatePickerTheme? theme;
  final LocaleType? locale;
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

  DatePickerTheme get _theme =>
      theme ??
      DatePickerTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: itemStyle,
          cancelStyle: cancelStyle,
          doneStyle: doneStyle);
}
