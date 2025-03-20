import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';

class SunSetPicture extends StatelessWidget {
  const SunSetPicture({
    super.key,
    required this.forecast,
  });

  final GeneralForecastEntity forecast;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 20),
        child: Tilt(
          tiltConfig: const TiltConfig(
            leaveCurve: Curves.easeInOutCubicEmphasized,
            leaveDuration: Duration(milliseconds: 600),
          ),
          lightConfig: const LightConfig(disable: true),
          shadowConfig: const ShadowConfig(disable: true),
          childLayout: ChildLayout(
            outer: [
              Positioned(
                right: 17,
                bottom: 10,
                child: TiltParallax(
                    size: const Offset(5, 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Moonrise",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              forecast.forecast?.forecastday?[0]?.astro?.moonrise ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            const Text(
                              "Moonset",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              forecast.forecast?.forecastday?[0]?.astro?.moonset ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Positioned(
                left: 20,
                bottom: 10,
                child: TiltParallax(
                    size: const Offset(5, 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Sunrise",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              forecast.forecast?.forecastday?[0]?.astro?.sunrise ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            const Text(
                              "Sunset",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              forecast.forecast?.forecastday?[0]?.astro?.sunset ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
          child: Container(
            height: 190,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(56, 1, 17, 28),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              child: Image.asset(
                "assets/images/sunrise.png",
                fit: BoxFit.cover, // Adjust the fit as needed
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
