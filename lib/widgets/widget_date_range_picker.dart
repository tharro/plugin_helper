import 'package:flutter/material.dart';

class MyWidgetDateRangePickerCustom extends StatelessWidget {
  final Widget child;
  final String? initialFirstDate;
  final String? initialLastDate;
  final Function onSelectedDate;
  final Function? onTap;
  final TextStyle textStyleButton;
  final Color primaryColor, accentColor, iconColor;
  final int? firstDate, lastDate;
  const MyWidgetDateRangePickerCustom(
      {Key? key,
      required this.child,
      required this.onSelectedDate,
      this.initialFirstDate,
      this.initialLastDate,
      this.onTap,
      required this.textStyleButton,
      required this.primaryColor,
      required this.accentColor,
      required this.iconColor,
      this.firstDate,
      this.lastDate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          primaryTextTheme: TextTheme(button: textStyleButton),
          primaryColor: primaryColor,
          iconTheme: IconThemeData(color: iconColor),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: accentColor) //dot
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
