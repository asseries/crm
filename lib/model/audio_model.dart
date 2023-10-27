class AudioModel {
  String fullPath;
  String fileName;
  int date;
  bool sent;
  String phone;

  AudioModel(
      this.fullPath,
      this.fileName,
      this.date,
      this.sent,
      this.phone
      );

  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
        json["fullPath"] ?? "",
        json["fileName"] ?? "",
        json["date"] ?? "",
        json["sent"] ?? false,
        json["phone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "fullPath": fullPath,
        "fileName": fileName,
        "date": date,
        "sent": sent,
        "phone": phone,
      };
}
