class BaseModel {
  final bool error;
  final String? message;
  final int? error_code;
  final dynamic data;

  BaseModel(this.error, this.message, this.error_code, this.data);

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        json["error"] ?? false,
        json["message"] ?? "",
        json["error_code"] ?? -1,
        json["data"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "error_code": error_code,
        "data": data,
      };
}
