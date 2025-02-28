import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/forecast_widget.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will navigate back to the previous screen
          },
        ),

      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Image.asset(Assets.images.azadWestLogo.path, height: 270,),
              const SizedBox(height: 30,),
              const Text("پروژه ی ترم ۸ - نیمسال دوم ۱۴۰۳ (۱۴۰۴-۱۴۰۳)",
                style: AppTextStyles.HeaderInfoStyle,),
              const SizedBox(height: 20,),
              const Text(":نام دانشجو" ,  style: AppTextStyles.TtileInfoStyle),
              const Text("سید پارسا بنی طبا",
                style: AppTextStyles.SubttileinfoStyle),
              const Divider(indent: 40,endIndent: 40),
              const Text(":شماره دانشجویی",  style: AppTextStyles.TtileInfoStyle),
              const Text("40022841054093" ,   style: AppTextStyles.SubttileinfoStyle),
              const Divider(indent: 40,endIndent: 40),
              const Text(":نام استاد پروژه",  style: AppTextStyles.TtileInfoStyle),
              const Text("استاد حمیدرضا مقسمی",   style: AppTextStyles.SubttileinfoStyle),
              const Divider(indent: 40,endIndent: 40),
              const SizedBox(height: 15,),
              const Text("توضیحات درباره پروژه" , style: AppTextStyles.ProjectDes),
              const Padding(
                padding: EdgeInsets.only(left: 12.0 , right: 12 , top: 4),
                child: Text("""این پروژه یک اپلیکیشن Flutter است که به کاربران امکان می‌دهد وضعیت آب‌وهوا را در هر شهری مشاهده کنند. برای پیاده‌سازی این قابلیت، از بسته‌های متعددی مانند http برای ارسال درخواست‌های HTTP، equatable برای مقایسه آسان اشیا، و envied برای مدیریت متغیرهای محیطی استفاده شده است. ساختار پروژه شامل پوشه‌های استاندارد Flutter مانند lib، assets و test است. در پوشه lib، کدهای اصلی برنامه قرار دارند که مسئولیت فراخوانی API و نمایش داده‌های آب‌وهوا را بر عهده دارند. همچنین، از dartz برای برنامه‌نویسی تابعی و مدیریت بهتر داده‌ها بهره گرفته شده است. این پروژه با هدف ارائه تجربه کاربری ساده و کارآمد برای دسترسی به اطلاعات آب‌وهوا طراحی شده است.
              """ , style:AppTextStyles.TtileInfoStyle,
                textDirection: TextDirection.rtl,),

              ),
              const Divider(indent: 40,endIndent: 40),
              const SizedBox(height: 10,),
              const Text(":شبکه های اجتماعی",   style: AppTextStyles.SubttileinfoStyle),
              const SizedBox(height: 13,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: ()=>launchUrlInBrowser('https://github.com/Sureiamdiamond'),
                    child: Image.asset(Assets.images.github.path , height: 45,),
                  ),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: ()=>launchUrlInBrowser('https://www.linkedin.com/in/parsa-banitaba-338983222/'),
                    child: Image.asset(Assets.images.linkedin.path , height: 58,),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}




Future<void> launchUrlInBrowser(String url) async {
  Uri urlparsed=Uri.parse(url);
  if (!await launchUrl(urlparsed,mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}


