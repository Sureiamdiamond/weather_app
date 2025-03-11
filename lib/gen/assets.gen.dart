/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/2.png
  AssetGenImage get a2 => const AssetGenImage('assets/images/2.png');

  /// File path: assets/images/3.png
  AssetGenImage get a3 => const AssetGenImage('assets/images/3.png');

  /// File path: assets/images/Azad_West_logo.png
  AssetGenImage get azadWestLogo =>
      const AssetGenImage('assets/images/Azad_West_logo.png');

  /// File path: assets/images/Moon.png
  AssetGenImage get moon => const AssetGenImage('assets/images/Moon.png');

  /// File path: assets/images/Sun.png
  AssetGenImage get sun => const AssetGenImage('assets/images/Sun.png');

  /// File path: assets/images/Union.svg
  String get union => 'assets/images/Union.svg';

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/cloud_bar.svg
  String get cloudBar => 'assets/images/cloud_bar.svg';

  /// File path: assets/images/day_clouds.png
  AssetGenImage get dayClouds =>
      const AssetGenImage('assets/images/day_clouds.png');

  /// File path: assets/images/day_rain.png
  AssetGenImage get dayRain =>
      const AssetGenImage('assets/images/day_rain.png');

  /// File path: assets/images/day_snow.png
  AssetGenImage get daySnow =>
      const AssetGenImage('assets/images/day_snow.png');

  /// File path: assets/images/day_storm_thunder.png
  AssetGenImage get dayStormThunder =>
      const AssetGenImage('assets/images/day_storm_thunder.png');

  /// File path: assets/images/day_wind.png
  AssetGenImage get dayWind =>
      const AssetGenImage('assets/images/day_wind.png');

  /// File path: assets/images/github.png
  AssetGenImage get github => const AssetGenImage('assets/images/github.png');

  /// File path: assets/images/humidity_bar.png
  AssetGenImage get humidityBarPng =>
      const AssetGenImage('assets/images/humidity_bar.png');

  /// File path: assets/images/humidity_bar.svg
  String get humidityBarSvg => 'assets/images/humidity_bar.svg';

  /// File path: assets/images/image1.png
  AssetGenImage get image1 => const AssetGenImage('assets/images/image1.png');

  /// File path: assets/images/linkedin.png
  AssetGenImage get linkedin =>
      const AssetGenImage('assets/images/linkedin.png');

  /// File path: assets/images/night_clouds.png
  AssetGenImage get nightClouds =>
      const AssetGenImage('assets/images/night_clouds.png');

  /// File path: assets/images/night_snow.png
  AssetGenImage get nightSnow =>
      const AssetGenImage('assets/images/night_snow.png');

  /// File path: assets/images/night_storm_thunder.png.png
  AssetGenImage get nightStormThunderPng =>
      const AssetGenImage('assets/images/night_storm_thunder.png.png');

  /// File path: assets/images/night_wind.png
  AssetGenImage get nightWind =>
      const AssetGenImage('assets/images/night_wind.png');

  /// File path: assets/images/pressure.png
  AssetGenImage get pressure =>
      const AssetGenImage('assets/images/pressure.png');

  /// File path: assets/images/small_wind.png
  AssetGenImage get smallWind =>
      const AssetGenImage('assets/images/small_wind.png');

  /// File path: assets/images/sunrise.png
  AssetGenImage get sunrise => const AssetGenImage('assets/images/sunrise.png');

  /// File path: assets/images/tempture.png
  AssetGenImage get tempture =>
      const AssetGenImage('assets/images/tempture.png');

  /// File path: assets/images/uv_small.png
  AssetGenImage get uvSmall =>
      const AssetGenImage('assets/images/uv_small.png');

  /// File path: assets/images/wind_bar.svg
  String get windBar => 'assets/images/wind_bar.svg';

  /// List of all assets
  List<dynamic> get values => [
    a2,
    a3,
    azadWestLogo,
    moon,
    sun,
    union,
    appLogo,
    cloudBar,
    dayClouds,
    dayRain,
    daySnow,
    dayStormThunder,
    dayWind,
    github,
    humidityBarPng,
    humidityBarSvg,
    image1,
    linkedin,
    nightClouds,
    nightSnow,
    nightStormThunderPng,
    nightWind,
    pressure,
    smallWind,
    sunrise,
    tempture,
    uvSmall,
    windBar,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
