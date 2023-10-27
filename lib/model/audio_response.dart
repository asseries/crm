class AudioResponse {
  final int id;
  final String date;
  final String recordName;
  final String number;

  AudioResponse(this.id, this.date, this.recordName,this.number);

  factory AudioResponse.fromJson(Map<String, dynamic> json) => AudioResponse(
        json["id"] ?? -1,
        json["mobil_time"] ?? "",
        json["record_name"] ?? "",
        json["number"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobil_time": date,
        "record_name": recordName,
        "number": number,
      };
}
