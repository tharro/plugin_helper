extension DateTimeX on DateTime {
  bool isToday() {
    var now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime dateTime) {
    return day == dateTime.day &&
        dateTime.month == month &&
        dateTime.year == year;
  }
}
