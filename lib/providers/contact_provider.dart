import 'dart:typed_data';

import 'package:crm/main.dart';
import 'package:crm/model/contact_model.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  int activePosition = -1;

  int getActivePosition() {
    return activePosition;
  }

  setActivePostion(int i) {
    activePosition = i;
    notifyListeners();
  }

//----------------------------------------------------------------------------------------------
  List<ContactModel> contactList = [];

  void initContactsFromStorage({
    int? id,
    String? name,
    String? number,
    bool? favorite,
    // List<int>? photoUri,
  }) async {
    // removing the types makes it crash at runtime
    // ignore: omit_local_variable_types
    List untypedContacts =
        await MyApp.platform.invokeMethod('getContacts', [id, name, number, favorite,
          // photoUri
        ]);
    // ignore: omit_local_variable_types
    List<ContactModel> contacts =
        untypedContacts.map((x) => ContactModel.fromJson(Map<String, dynamic>.from(x))).toList();
    contactList = contacts;
    filteredContacts = contacts;
    favoriteContacts = contactList.where((element) => element.favorite==true).toList();
    notifyListeners();
  }

  setFavoriteContact(String id, bool fav) async {
    MyApp.platform.invokeMethod("setFavContact", {"id": id, "fav": fav});
    initContactsFromStorage();
  }

  Future<bool> getFavoriteById(String id) async {
    MyApp.platform.invokeMethod('getContactById', {
      'id': id,
    }).then((value) {
      print("AAAAAAAAA $value");
      return value;
    });
    return false;
  }

//-------------------------------------------------------
  String searchText = "";
  List<ContactModel> filteredContacts = [];

  void setSearchedText(String text) {
    if (searchText.isEmpty) {
      favoriteContacts = contactList.where((element) => element.favorite==true).toList();
    }else{
      filteredContacts = contactList
          .where((element) =>
      element.name.toUpperCase().contains(searchText.toUpperCase()) ||
          element.number.toUpperCase().contains(searchText.toUpperCase()))
          .toList();
      favoriteContacts = contactList
          .where((element) => (element.favorite&&(element.name.toUpperCase().contains(text.toUpperCase()) ||
          element.number.toUpperCase().contains(text.toUpperCase()))))
          .toList();
    }

    searchText = text;
    notifyListeners();
  }

//------------------------------------------------------------------------------------------------------------
  String displayText = "";
  setDisplayText(String text) {
    if (displayText.isEmpty) {
      filteredContacts = [];
    } else {
      filteredContacts = contactList
          .where((element) => (element.name.toUpperCase().contains(text.toUpperCase()) ||
              element.number.toUpperCase().contains(text.toUpperCase())))
          .toList();
    }
    displayText = text;
    notifyListeners();
  }

//------------------------------------------------------------------------------------------------------------

  void loadContacts(){
    filteredContacts = contactList;
  }

//------------------------------------------------------------------------------------------------------------
  String searchedText = "";
  List<ContactModel> favoriteContacts = [];

  void initFavoriteContacts() {
    favoriteContacts = contactList.where((element) => element.favorite == true).toList();
  }
}
