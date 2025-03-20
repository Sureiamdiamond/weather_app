String feelsLikeTexts(double tempC, double feelsLikeC) {
  if (feelsLikeC < tempC) {
    return "little colder than current temp";
  } else if (feelsLikeC > tempC) {
    return "little warmer than current temp";
  } else {
    return "Similar to the actual temperature.";
  }
}