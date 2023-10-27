// import 'package:crm/model/call_record_model.dart';
// import 'package:crm/model/contact_model.dart';
// import 'package:crm/model/state_model.dart';
// import 'package:hive/hive.dart';
//
// class Database {
// //------------------------------------------------------------------------------------------------------------
//   final String _contactBox = "contacts_box";
//
//   //opening box to store data
//   Future<Box> createContactBox() async {
//     Box box = await Hive.openBox<ContactModel>(_contactBox);
//     return box;
//   }
//
//   //get all data from the box
//   Future<List<ContactModel>> getContacts() async {
//     var box = await Hive.openBox<ContactModel>(_contactBox);
//     List<ContactModel> contacts = box.values.toList();
//     return contacts;
//   }
//
//   //add data to the box
//   Future<void> addContact(ContactModel contactModel) async {
//     var box = await createContactBox();
//     await box.add(contactModel);
//   }
//
//   //add data to the box
//   Future<void> addAllContacts(List<ContactModel> contacts) async {
//     var box = await createContactBox();
//     await box.addAll(contacts);
//   }
//
//   //delete data from the box
//   Future<int> deleteContact(int index) async {
//     var box = await createContactBox();
//     await box.deleteAt(index);
//     return index;
//   }
//
//   //update data from the box
//   Future<void> updateContact(int index, ContactModel contactModel) async {
//     var box = await createContactBox();
//     await box.putAt(index, contactModel);
//   }
//
//   //clear base
//   Future<void> clearContactDatebase() async {
//     var box = await createContactBox();
//     await box.clear();
//   }
//
// //------------------------------------------------------------------------------------------------------------
//

import 'package:hive/hive.dart';

import '../model/state_model.dart';

class Database {
  final String _stateBox = "state_box";

//opening box to store data
  Future<Box> createStateBox() async {
    Box box = await Hive.openBox<StateModel>(_stateBox);
    return box;
  }

//get all data from the box
  Future<List<StateModel>> getStateList() async {
    var box = await Hive.openBox<StateModel>(_stateBox);
    List<StateModel> callRecords = box.values.toList();
    return callRecords;
  }

//add data to the box
  Future<void> addState(StateModel stateModel) async {
    var box = await createStateBox();
    await box.add(stateModel);
  }

//add data to the box
  Future<void> addStateList(List<StateModel> callRecords) async {
    var box = await createStateBox();
    await box.addAll(callRecords);
  }

//delete data from the box
  Future<int> deleteState(int index) async {
    var box = await createStateBox();
    await box.deleteAt(index);
    return index;
  }

//update data from the box
  Future<void> updateState(int index, StateModel callRecordModel) async {
    var box = await createStateBox();
    await box.putAt(index, callRecordModel);
  }

//clear base
  Future<void> clearStateBox() async {
    var box = await createStateBox();
    await box.clear();
  }
}
