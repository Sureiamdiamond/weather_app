String getWeekDay(String localtime) {
  int year = int.parse(localtime.substring(0, 4));
  int month = int.parse(localtime.substring(5, 7));
  int day = int.parse(localtime.substring(8, 10));

  DateTime date = DateTime(year, month, day);

  int weekday = date.weekday;

  String dayName;
  switch (weekday) {
    case 1:
      dayName = 'Monday';
      break;
    case 2:
      dayName = 'Tuesday';
      break;
    case 3:
      dayName = 'Wednesday';
      break;
    case 4:
      dayName = 'Thursday';
      break;
    case 5:
      dayName = 'Friday';
      break;
    case 6:
      dayName = 'Saturday';
      break;
    case 7:
      dayName = 'Sunday';
      break;
    default:
      dayName = 'Unknown day';
  }
  return dayName;
}
