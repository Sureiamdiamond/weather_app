import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:test_app/feature/presentation/pages/Compass.dart';
import 'package:test_app/feature/presentation/pages/DateConversion.dart';
import 'package:test_app/gen/assets.gen.dart';
import '../pages/gemini.dart';
import '../pages/info.dart';
import '../style/text_styles.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopup(

      contentPadding: const EdgeInsets.all(10),
      showArrow: true,
      content: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///bot
            InkWell(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ChatScreen();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              ),
              child: Row(
                children: [
                  Image.asset(Assets.images.bot.path, height: 35),
                  const SizedBox(
                    width: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Gemini", style: AppTextStyles.search),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ///compass
            InkWell(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const CompassScreen();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0571dd),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    height: 37,
                    width: 37,
                    child: Image.asset(Assets.images.compassIcon.path , color: Colors.white,height: 22,),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 1.0, left: 5),
                    child: Text("Compass", style: AppTextStyles.search),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ///Date Conversion
            InkWell(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DateConversionScreen();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              ),
              child: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff0571dd),
                        borderRadius: BorderRadius.circular(22),),
                      child: Image.asset(Assets.images.dateConversion.path, height: 35 , color: Colors.white,)),
                  const SizedBox(
                    width: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 1.0, left: 5),
                    child: Text("Date Conversion", style: AppTextStyles.search),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ///info
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const InfoScreen();
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child:  Row(
                children: [
                  Container(

                    child: const Icon(
                      Icons.info_outline_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff0571dd),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Text("Info", style: AppTextStyles.search),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      child: const Icon(
        Icons.menu_rounded,
        size: 36,
        color: Colors.white,
      ),

    );
  }
}