import 'package:intl/intl.dart';

extension MillisecondExtensions on int? {
  String formatEprochToDate() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    var date = DateFormat('dd.MM.yyyy HH:mm:ss').format(d);
    return date;
  }

  int getYearOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.year;
  }

  int getMonthOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.month;
  }


  int getDayOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.day;
  }

  int getHourOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.hour;
  }

  int getMinuteOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.minute;
  }

  int getSecondOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.second;
  }

  int getMilliSecondOfEproch() {
    var d = DateTime
        .fromMillisecondsSinceEpoch(this??1);
    return d.millisecond;
  }

  String getMonthName(){
    var month = "";
    switch(this){
      case 1: month =  "yanvar"; break;
      case 2: month =  "fevral"; break;
      case 3: month =  "mart"; break;
      case 4: month =  "aprel"; break;
      case 5: month =  "may"; break;
      case 6: month =  "iyun"; break;
      case 7: month =  "iyul"; break;
      case 8: month =  "avgust"; break;
      case 9: month =  "sentyabr"; break;
      case 10: month =  "oktyabr"; break;
      case 11: month =  "noyabr"; break;
      case 12: month =  "dekabr"; break;
    }
    return month;
  }
}

extension MillisecondExtensions2 on String {
  //2019-11-25 00:00:00.000
  int formatDateToEproch() {
    var inputedStartTime = DateTime.parse(this);
    var mili = inputedStartTime.millisecondsSinceEpoch;
    var startTime = mili.toInt()
        ~/10000*10000 //Ushbu funksiya sekundni birlar xonasini nolga aylantiradi
        ;
    return startTime;
  }
}

extension CustomDateFormat on String {
  String formattedTDateForFilter() {
    //"2023-06-01T11:00:00Z",
    var formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");
    var date = formatter.parse(this);
    var day = date.day.toString().length != 1 ? date.day.toString() : "0${date.day}";
    var month = date.month.toString().length != 1 ? date.month.toString() : "0${date.month}";
    var year = date.year.toString().length != 1 ? date.year.toString() : "0${date.year}";
    var hour = date.hour.toString().length != 1 ? date.hour.toString() : "0${date.hour}";
    var min = date.minute.toString().length != 1 ? date.minute.toString() : "0${date.minute}";
    var sec = date.second.toString().length != 1 ? date.second.toString() : "0${date.second}";

    // var formattedDate = "$day.$month.$year $hour:$min";
    var formattedDate = "$year-$month-$day $hour:$min:$sec.000";
    //2019-11-25 00:00:00.000
    return formattedDate;
  }

  String formattedToAnotherFormat() {
    //"2023-06-01T11:00:00Z",
    var formatter = DateFormat("dd.MM.yyyy HH:mm:ss");
    var date = formatter.parse(this);
    var day = date.day.toString().length != 1 ? date.day.toString() : "0${date.day}";
    var month = date.month.toString().length != 1 ? date.month.toString() : "0${date.month}";
    var year = date.year.toString().length != 1 ? date.year.toString() : "0${date.year}";
    var hour = date.hour.toString().length != 1 ? date.hour.toString() : "0${date.hour}";
    var min = date.minute.toString().length != 1 ? date.minute.toString() : "0${date.minute}";
    var sec = date.second.toString().length != 1 ? date.second.toString() : "0${date.second}";
    //2019-11-25 00:00:00.000
    var formattedDate = "$year-$month-$day $hour:$min:$sec.000";
    return formattedDate;
  }

}

extension FormatterInt on DateTime {

  DateTime getDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  DateTime firstDateOfTheWeek() {
    return getDate(subtract(Duration(days: weekday - 1)));
  }

  DateTime findLastDateOfTheWeek() {
    return getDate(add(Duration(days: DateTime.daysPerWeek - weekday)));
  }

}