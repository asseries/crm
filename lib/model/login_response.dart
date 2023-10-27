
import 'dart:core';

class LoginResponse{
  final int id;
  final String token;
  final String? fullname;
  final String? phone;
  final String? role;
  final int? branchId;
  final int? groupId;
  final String image;

  LoginResponse(this.id,this.token,this.fullname,this.phone,this.role,this.branchId,this.groupId,this.image);


  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      json["id"] ?? -1,
      json["token"] ?? "",
      json["fullname"] ?? "",
      json["phone_number"] ?? "",
      json["role"] ?? "",
      json["branch_id"] ?? 0,
      json["group_id"] ?? -1,
      json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "fullname": fullname,
    "phone_number": phone,
    "role": role,
    "branch_id": branchId,
    "group_id": groupId,
    "image": image,
  };
}
