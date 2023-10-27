import 'package:crm/providers/contact_provider.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/utils.dart';
import 'package:crm/view/contact_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final bool _permissionDenied = false;
  final searchController = TextEditingController();
  bool searchOpened = false;

  //focus
  var focusNode = FocusNode();

  @override
  void initState() {
    Provider.of<ContactProvider>(context, listen: false).initFavoriteContacts();
    super.initState();
  }

  _calling(String phone) async {
    // String url = "tel:$phone";
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }

    return Scaffold(
        body: WillPopScope(onWillPop: () async {
      //dialog
      return false;
    }, child: Consumer<ContactProvider>(
      builder: (context, provider, child) {
        return Stack(
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
                    BoxShadow(
                        color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
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
                                  "Saralangan kontaktlar".toUpperCase(),
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
                            searchController.selection = TextSelection.fromPosition(
                                TextPosition(offset: searchController.text.length));

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
                          } else {
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
                      shrinkWrap: true,
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.favoriteContacts.length,
                      //_contacts!.length,
                      itemBuilder: (context, index) {
                        if (provider.getActivePosition() != index) {
                          provider.favoriteContacts[index].isOpen = false;
                        }
                        return ContactItemView(
                          position: index,
                          item: provider.favoriteContacts[index],
                          favorite: (){
                            provider.setFavoriteContact(
                                provider.favoriteContacts[index].id.toString(),
                                !(provider.favoriteContacts[index].favorite));
                          }
                        );
                      }),
                ),
              ],
            ),
            Container(
              height: 32,
              width: (provider.favoriteContacts.length) < 10
                  ? 40
                  : (provider.favoriteContacts.length.toString().length) * 16,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 85, right: 0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.0),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.BLACK.withOpacity(.1), blurRadius: 4, blurStyle: BlurStyle.outer)
                  ],
                  border: Border.all(color: AppColors.BLACK.withOpacity(.2), width: .4)),
              alignment: Alignment.center,
              child: Text(
                (provider.favoriteContacts.length).toString(),
                style: asTextStyle(
                  fontFamily: "p_bold",
                ),
              ),
            ),
            if ((provider.favoriteContacts).isEmpty)
              const Center(
                  child: Opacity(
                opacity: .4,
                child: Text(
                  "Saralangan kontaktlar yo'q...",
                  style: TextStyle(fontSize: 16, fontFamily: "p_med"),
                ),
              )),
          ],
        );
      },
    )));
  }
}
