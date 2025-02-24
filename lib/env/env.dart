import 'package:envied/envied.dart';

// part "env.g.dart";

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'KEY1')
  static const String forecastApiKey ="7ede0f3a77484c84984122018252302";
}