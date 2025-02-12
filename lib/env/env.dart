import 'package:envied/envied.dart';

part "env.g.dart";

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'KEY1')
  static const String forecastApiKey = _Env.forecastApiKey;
}
