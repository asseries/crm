import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/contact_model.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts>{
  static const platform = MethodChannel('asser/channel');
  List<ContactModel> contactList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      contactList = await getContactList();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                contactList = await getContactList();
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactList[index].name,
                              style: TextStyle(fontFamily: "p_semi"),
                            ),
                            Text(
                              contactList[index].number,
                              style: TextStyle(fontFamily: "p_med"),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              setFavorite(contactList[index].id.toString(), !contactList[index].favorite);
                              contactList = await getContactList();
                              setState(() {});
                            },
                            icon: Icon(contactList[index].favorite ? Icons.favorite : Icons.favorite_border))
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setFavorite(String id, bool fav) async {
    await platform.invokeMethod("setFavContact", {"id": id, "fav": fav});
  }

  static Future<List<ContactModel>> getContactList({
    int? id,
    String? name,
    String? number,
    bool? favorite,
    String? photoUri,
  }) async {
    // removing the types makes it crash at runtime
    // ignore: omit_local_variable_types
    List untypedContacts =
        await platform.invokeMethod('getFavoriteContacts', [id, name, number, favorite, photoUri]);
    // ignore: omit_local_variable_types
    List<ContactModel> contacts =
        untypedContacts.map((x) => ContactModel.fromJson(Map<String, dynamic>.from(x))).toList();
    return contacts;
  }
}
