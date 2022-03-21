import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as Date;

class WidgetDatePicker extends StatelessWidget {
  const WidgetDatePicker(
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
      this.locale})
      : super(key: key);
  final String? date;
  final Function onPress;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Function? onTap;
  final TextStyle itemStyle, cancelStyle, doneStyle;
  final Widget child;
  final Date.DatePickerTheme? theme;
  final Date.LocaleType? locale;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          onTap!();
        }
        Date.DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          currentTime: initialDate ?? DateTime.now(),
          locale: locale ?? Date.LocaleType.en,
          minTime: firstDate ?? DateTime(1900, 1),
          maxTime: lastDate ?? DateTime(2122, 7),
          theme: theme ??
              Date.DatePickerTheme(
                  headerColor: Colors.white,
                  backgroundColor: Colors.white,
                  itemStyle: itemStyle,
                  cancelStyle: cancelStyle,
                  doneStyle: doneStyle),
          onChanged: (date) {
            print(date);
          },
          onConfirm: (date) {
            onPress(date);
          },
        );
      },
      child: child,
    );
  }
}
