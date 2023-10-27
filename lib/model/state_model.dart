import 'package:hive/hive.dart';

part 'state_model.g.dart'; //<--------- bu model nomiga moslab qo'shiladi

@HiveType(typeId: 0) //<---------
class StateModel {
  @HiveField(0) //<---------
  final String state;
  @HiveField(1) //<---------
  final int date;
  @HiveField(2) //<---------
  final String phone;

  StateModel({required this.state, required this.date, required this.phone});
}

class StateModelForPrefs {
  String state;
  int date;
  int duration;
  String phone;
  String dateForCheck;

  StateModelForPrefs(
      this.state,
      this.date,
      this.duration,
      this.phone,
      this.dateForCheck
      );

  factory StateModelForPrefs.fromJson(Map<String, dynamic> json) => StateModelForPrefs(
    json["state"] ?? "",
    json["date"] ?? 0,
    json["duration"] ?? 0,
    json["phone"] ?? "",
    json["dateForCheck"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "date": date,
    "duration": duration,
    "phone": phone,
    "dateForCheck": dateForCheck,
  };
}
