String getDayOrNight(String localtime) {
  int hour = int.parse(localtime.split(" ")[1].split(":")[0]);
  return (hour >= 2 && hour <= 18) ? "day" : "night";
}

