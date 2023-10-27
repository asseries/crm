class CallRecordModel {
  String fullPath;
  String fileName;
  String date;

  CallRecordModel(
      this.fullPath,
      this.fileName,
      this.date,);

  factory CallRecordModel.fromJson(Map<String, dynamic> json) => CallRecordModel(
        json["fullPath"] ?? "",
        json["fileName"] ?? "",
        json["date"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "fullPath": fullPath,
        "fileName": fileName,
        "date": date,
      };
}
