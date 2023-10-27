import 'package:crm/providers/contact_provider.dart';
import 'package:crm/view/contact_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with WidgetsBindingObserver{
  final searchController = TextEditingController();
  bool searchOpened = false;


  //focus
  var focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state!=AppLifecycleState.paused){
      Provider.of<ContactProvider>(context, listen: false).initContactsFromStorage();
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    return Consumer<ContactProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                getStatusBarWidget(context),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.maxFinite,
                  height: 56,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
                  ]),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu)),
                      Expanded(
                        child: searchOpened
                            ? asTextField(
                          context,
                          focusNode: focusNode,
                          borderVisibility: false,
                          controller: searchController,
                          hintText: "Qidiruv...",
                          onChanged: (value) async {
                            provider.setSearchedText(value);

                          },
                        )
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Kontaktlar".toUpperCase(),
                            style: const TextStyle(
                              fontFamily: "p_semi",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (searchController.text.isNotEmpty)
                        InkWell(
                          onTap: () {
                            vibrateLight();
                            searchController.text =
                                searchController.text.substring(0, searchController.text.length - 1);
                            searchController.selection =
                                TextSelection.fromPosition(TextPosition(offset: searchController.text.length));

                            provider.setSearchedText(searchController.text.toString());
                          },
                          onLongPress: () {
                            searchController.text = "";
                            provider.setSearchedText("");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.clear,
                              size: 20,
                            ),
                          ),
                        ),
                      InkResponse(
                        onTap: () {
                          searchOpened = !searchOpened;
                          if (searchOpened == false) {
                            searchController.clear();
                            provider.setSearchedText("");
                          }else{
                            focusNode.requestFocus();
                          }
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/find.png',
                                height: 18,
                                color: (themeMode == ThemeMode.dark
                                    ? Colors.grey.shade300
                                    : Colors.blueGrey.shade900),
                              ),
                              if (searchOpened)
                                const Icon(
                                  Icons.close,
                                  size: 13.8,
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: provider.filteredContacts.length,
                    itemBuilder: (context, index) {

                      return ContactItemView(position: index,
                          item: provider.filteredContacts[index],
                        favorite: () async {
                        print("FAVORITE: ${await provider.getFavoriteById(provider.filteredContacts[index].id.toString())}");
                          provider.setFavoriteContact(
                              provider.filteredContacts[index].id.toString(),!(provider.filteredContacts[index].favorite));
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 32,
              width: (provider.contactList.length) < 10
                  ? 40
                  : (provider.contactList.length.toString().length) * 16,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 85, right: 0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.0),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: AppColors.BLACK.withOpacity(.1), blurRadius: 4, blurStyle: BlurStyle.outer)
                  ],
                  border: Border.all(color: AppColors.BLACK.withOpacity(.2), width: .4)),
              alignment: Alignment.center,
              child: Text(
                (provider.contactList.length).toString(),
                style: asTextStyle(
                  fontFamily: "p_bold",
                ),
              ),
            ),

          ],
        ),
      );
    },);
  }



}

