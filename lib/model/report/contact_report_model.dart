import 'package:call_log/call_log.dart';

class ContactReportModel {
  String name;
  String number;
  int duration;
  int callCount;
  CallType? callType;
  int date;
  ContactReportModel(this.name, this.number, this.duration,this.callCount,this.callType,this.date);

  factory ContactReportModel.fromJson(Map<String, dynamic> json) => ContactReportModel(
        json["name"] ?? "",
        json["number"] ?? "",
        json["duration"] ?? 0,
        json["callCount"] ?? 0,
        json["callType"],
        json["date"]??0,

      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "duration": duration,
        "callCount": callCount,
        "callType": callType,
        "date": date,
      };
}


