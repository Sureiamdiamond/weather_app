import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../style/text_styles.dart';


class DateConversionScreen extends StatefulWidget {
  const DateConversionScreen({super.key});

  @override
  _DateConversionScreenState createState() => _DateConversionScreenState();
}

class _DateConversionScreenState extends State<DateConversionScreen> {
  String selectedDate = "1397/05/05";
  String gregorianDate = "";
  String convertedHijriDate = "";
  bool showGregorianPicker = false;

  final List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  final List<String> persianMonthNames = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];

  @override
  void initState() {
    super.initState();
    _updateGregorianDate(selectedDate);
  }

  void _updateGregorianDate(String shamsiDate) {
    List<String> parts = shamsiDate.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    Jalali jalaliDate = Jalali(year, month, day);
    Gregorian gregorian = jalaliDate.toGregorian();

    String monthName = monthNames[gregorian.month - 1];
    gregorianDate = "${gregorian.day} $monthName ${gregorian.year}";
  }

  String _formatPersianDate(String date) {
    List<String> parts = date.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    String monthName = persianMonthNames[month - 1];

    return "$day $monthName $year";
  }

  void _convertGregorianToHijri(String gregorianDate) {
    List<String> parts = gregorianDate.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    Gregorian gregorian = Gregorian(year, month, day);
    Jalali jalali = gregorian.toJalali();

    convertedHijriDate = "${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}";
    setState(() {
      showGregorianPicker = true;
      selectedDate = convertedHijriDate;
    });
  }

  void _convertHijriToGregorian(String hijriDate) {
    List<String> parts = hijriDate.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    Jalali jalali = Jalali(year, month, day);
    Gregorian gregorian = jalali.toGregorian();

    String monthName = monthNames[gregorian.month - 1];
    gregorianDate = "${gregorian.day} $monthName ${gregorian.year}";
    setState(() {
      showGregorianPicker = false;
      selectedDate = "${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}";
      convertedHijriDate = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff045395),
        title: const Text('Date Conversion', style: AppTextStyles.info),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              if (convertedHijriDate.isNotEmpty && showGregorianPicker)
                Column(
                  children: [
                    const Text(
                      'معادل هجری شمسی:',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.dateCovertortitle,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      textDirection: TextDirection.rtl,
                      _formatPersianDate(convertedHijriDate),
                      style: AppTextStyles.dateConvertor,
                    ),
                  ],
                ) else
                Column(
                  children: [
                    const Text(
                      'معادل میلادی:',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.dateCovertortitle,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      gregorianDate,
                      style: AppTextStyles.dateConvertor,
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(8),
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xff0263b3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("سال | year", style: AppTextStyles.dateCovertorWhite),
                    Text("ماه | month", style: AppTextStyles.dateCovertorWhite),
                    Text("روز | day", style: AppTextStyles.dateCovertorWhite),
                  ],
                ),
              ),
              if (!showGregorianPicker)
                LinearDatePicker(
                  startDate: "1300/01/01",
                  endDate: "1425/01/01",
                  initialDate: "1404/01/01",
                  addLeadingZero: true,
                  dateChangeListener: (String newDate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        selectedDate = newDate;
                        _updateGregorianDate(newDate);
                      });
                    });
                  },
                  showDay: true,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  selectedRowStyle: const TextStyle(
                    fontFamily: "Sahel",
                    fontWeight: FontWeight.w600,
                    fontSize: 21.0,
                    color: Color(0xff0364c5),
                  ),
                  unselectedRowStyle: const TextStyle(
                    fontFamily: "Sahel",
                    fontWeight: FontWeight.w500,
                    fontSize: 19.0,
                    color: Colors.blueGrey,
                  ),
                  showLabels: false,
                  columnWidth: 125,
                  showMonthName: true,
                  isJalaali: true,
                ),
              const SizedBox(height: 10),
              if (showGregorianPicker)
                LinearDatePicker(
                  startDate: "1900/01/01",
                  endDate: "2040/01/01",
                  initialDate: "2025/01/01",
                  addLeadingZero: true,
                  dateChangeListener: (String newDate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        selectedDate = newDate;
                        _convertGregorianToHijri(newDate);
                      });
                    });
                  },
                  showDay: true,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  selectedRowStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.0,
                    color: Color(0xff0364c5),
                  ),
                  unselectedRowStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.0,
                    color: Colors.blueGrey,
                  ),
                  showLabels: false,
                  columnWidth: 125,
                  showMonthName: true,
                  isJalaali: false,
                ),
              const SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                Text(
                  showGregorianPicker
                      ? 'اگر میخوای از هجری به میلادی تبدیل کنی روی دکمه ی زیر کلیک کن'
                      : 'اگر میخوای از میلادی به هجری تبدیل کنی روی دکمه ی زیر کلیک کن',
                  style: AppTextStyles.geminiFarsiBlackSamller,

                )
              ],),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  if (showGregorianPicker) {
                    _convertHijriToGregorian(selectedDate);
                  } else {
                    _convertGregorianToHijri(selectedDate);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0263b3),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  showGregorianPicker
                      ? 'هجری به میلادی'
                      : 'میلادی به هجری',
                  style: AppTextStyles.geminiFarsi,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: DateConversionScreen()));
}