int showHour(String localtime) {
  int hour = int.parse(localtime.split(" ")[1].split(":")[0]);
  return hour;
}