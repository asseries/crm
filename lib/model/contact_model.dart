import 'dart:typed_data';

class ContactModel {
  int id;
  String name;
  String number;
  bool favorite;
  // List<int>? photoUri;
  bool isOpen;

  ContactModel(this.id, this.name, this.number, this.favorite,
      // this.photoUri,
      this.isOpen);

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        json["id"] ?? "",
        json["name"] ?? "",
        json["number"] ?? "",
        (json["favorite"]??0) == 0?false : true,
        // json["photoUri"]??[],
        json["isOpen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "favorite": favorite,
        // "photoUri": photoUri,
        "isOpen": isOpen,
      };
}

Uint8List? _getImageBinary(dynamicList) {
  List<int>? intList = dynamicList.cast<int>().toList(); //This is the magical line.
  Uint8List data = Uint8List.fromList(intList??[]);
  return data;
}


