// import 'package:crm/db/database.dart';
// import 'package:crm/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:provider/provider.dart';
// import 'contact_bloc/contact_bloc_cubit.dart';
//
// class ContactScreen extends StatefulWidget {
//   const ContactScreen({super.key});
//
//   @override
//   _ContactScreenState createState() => _ContactScreenState();
// }
//
// class _ContactScreenState extends State<ContactScreen> {
//   List<ContactModel>? _contacts;
//   List<ContactModel>? filteredContacts = [];
//   final bool _permissionDenied = false;
//   Database dataBase = Database();
//   final searchController = TextEditingController();
//   bool searchOpened = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     dataBase.getContacts().then((value) {
//       _contacts = value;
//       filteredContacts = _contacts;
//       setState(() {});
//     });
//   }
//
//   _calling(String phone) async {
//     // String url = "tel:$phone";
//     // if (await canLaunch(url)) {
//     //   await launch(url);
//     // } else {
//     //   throw 'Could not launch $url';
//     // }
//     FlutterPhoneDirectCaller.callNumber(phone);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var themeProvider = Provider.of<ThemeProvider>(context);
//     if (_permissionDenied) {
//       return const Center(child: Text('Permission denied'));
//     }
//
//     return Scaffold(
//         body: WillPopScope(
//       onWillPop: () async {
//         //dialog
//         return false;
//       },
//       child: Stack(
//         alignment: Alignment.topRight,
//         children: [
//           Column(
//             children: [
//               getStatusBarWidget(context),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 width: getScreenWidth(context),
//                 height: 56,
//                 decoration: BoxDecoration(boxShadow: [
//                   BoxShadow(color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
//                 ]),
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                         icon: const Icon(Icons.menu)),
//                     Expanded(
//                       child: searchOpened
//                           ? asTextField(
//                               context,
//                               borderVisibility: false,
//                               controller: searchController,
//                               hintText: "Qidiruv...",
//                               onChanged: (value) async {
//                                 setState(() {
//                                   if (value.isEmpty) {
//                                     filteredContacts = _contacts;
//                                     return;
//                                   }
//                                   filteredContacts = _contacts?.where((element) {
//                                     return ((element.displayName ?? "")
//                                             .toUpperCase()
//                                             .contains(value.toUpperCase()) ||
//                                         ((element.phones.firstOrNull ?? "")
//                                             .toUpperCase()
//                                             .contains(value.toUpperCase())));
//                                   }).toList();
//                                 });
//                               },
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 "Kontaktlar".toUpperCase(),
//                                 style: const TextStyle(
//                                   fontFamily: "p_semi",
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                     ),
//                     if (searchController.text.isNotEmpty)
//                       InkWell(
//                         onTap: () {
//                           vibrateLight();
//                           searchController.text =
//                               searchController.text.substring(0, searchController.text.length - 1);
//                           searchController.selection =
//                               TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
//
//                           if (searchController.text.isEmpty) {
//                             filteredContacts = _contacts;
//                             return;
//                           }
//                           filteredContacts = _contacts
//                               ?.where((element) => (element.displayName ?? "")
//                                   .toUpperCase()
//                                   .contains(searchController.text.toUpperCase()))
//                               .toList();
//                           setState(() {});
//                         },
//                         onLongPress: () {
//                           searchController.text = "";
//                           filteredContacts = _contacts;
//                           setState(() {});
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.clear,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     InkResponse(
//                       onTap: () {
//                         searchOpened = !searchOpened;
//                         if (searchOpened == false) {
//                           searchController.clear();
//                           filteredContacts = _contacts;
//                         }
//                         setState(() {});
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Stack(
//                           children: [
//                             Image.asset(
//                               'assets/images/find.png',
//                               height: 18,
//                               color: (themeProvider.getThemeMode() == ThemeMode.dark
//                                   ? Colors.grey.shade300
//                                   : Colors.blueGrey.shade900),
//                             ),
//                             if (searchOpened)
//                               const Icon(
//                                 Icons.close,
//                                 size: 13.8,
//                               )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                         shrinkWrap: true,
//                         primary: false,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: filteredContacts?.length,
//                         //_contacts!.length,
//                         itemBuilder: (context, index) {
//                           if (BlocProvider.of<ContactBlocCubit>(context).getActivePosition() != index) {
//                             filteredContacts![index].isOpen = false;
//                           }
//                           return InkWell(
//                             onTap: () async {
//                               BlocProvider.of<ContactBlocCubit>(context).setActivePostion(index);
//
//                               filteredContacts![index].isOpen = !filteredContacts![index].isOpen;
//                               setState(() {});
//                             },
//                             child: AnimatedContainer(
//                               duration: 100.milliseconds,
//                               height: filteredContacts![index].isOpen
//                                   ? (125 +
//                                       (filteredContacts![index].phones.length *
//                                           (filteredContacts![index].phones.length == 1 ? 0 : 14)))
//                                   : searchController.text.isNotEmpty
//                                       ? 80
//                                       : 64,
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: filteredContacts?[index].isOpen == true
//                                   ? SingleChildScrollView(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                         SingleChildScrollView(
//                                           physics: const NeverScrollableScrollPhysics(),
//                                           scrollDirection: Axis.horizontal,
//                                           child: Row(
//                                             children: [
//                                               //opened circle name[0]
//                                               Container(
//                                                 padding: const EdgeInsets.all(10),
//                                                 margin: const EdgeInsets.only(left: 8, right: 16),
//                                                 decoration:
//                                                     BoxDecoration(shape: BoxShape.circle, border: Border.all()),
//                                                 child: Text(
//                                                   (filteredContacts?[index].displayName ?? "").isNotEmpty
//                                                       ? (filteredContacts?[index].displayName?[0] ?? "")
//                                                       : "",
//                                                   style: const TextStyle(fontSize: 21),
//                                                 ),
//                                               ),
//
//                                               Text(filteredContacts![index].displayName ?? "",
//                                                   style: asTextStyle(fontFamily: "p_semi", size: 16)),
//                                             ],
//                                           ),
//                                         ),
//
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 54),
//                                           child: ListView.builder(
//                                             shrinkWrap: true,
//                                             primary: false,
//                                             itemCount: filteredContacts?[index].phones.length,
//                                             //fullContact?.phones.length,
//                                             itemBuilder: (context, index2) {
//                                               return Text(
//                                                 "${index2 + 1}. ${(filteredContacts?[index].phones ?? []).isEmpty ? "[Raqamlar mavjud emas]" : filteredContacts?[index].phones[index2] ?? "Bo'sh"}",
//                                                 style: asTextStyle(),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 8,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             //call
//                                             InkResponse(
//                                               onTap: () {
//                                                 if (filteredContacts?[index].phones.length == 1) {
//                                                   _calling(filteredContacts?[index].phones.firstOrNull ?? "");
//                                                 } else {
//                                                   showAsBottomSheet(
//                                                       backgroundColor:
//                                                           PrefUtils.getThemeMode() == ThemeMode.light
//                                                               ? AppColors.COLOR_PRIMARY2
//                                                               : AppColors.COLOR_PRIMARY,
//                                                       context,
//                                                       Column(
//                                                         mainAxisSize: MainAxisSize.min,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           const SizedBox(
//                                                             height: 16,
//                                                           ),
//                                                           Padding(
//                                                             padding: const EdgeInsets.all(8.0),
//                                                             child: Text(
//                                                               "Qaysi telefon raqamidan qo'ng'iroq qilmoqchisiz?",
//                                                               style: asTextStyle(fontFamily: "p_semi"),
//                                                             ),
//                                                           ),
//                                                           ListView.builder(
//                                                             shrinkWrap: true,
//                                                             primary: false,
//                                                             itemCount: filteredContacts?[index].phones.length,
//                                                             itemBuilder: (context, index3) {
//                                                               return Container(
//                                                                 margin: const EdgeInsets.all(8),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment.spaceBetween,
//                                                                   children: [
//                                                                     Text(
//                                                                       "${filteredContacts?[index].phones[index3]}",
//                                                                       style: asTextStyle(
//                                                                           fontWeight: FontWeight.w900),
//                                                                     ),
//                                                                     InkResponse(
//                                                                       onTap: () {
//                                                                         _calling(filteredContacts?[index]
//                                                                                 .phones[index3] ??
//                                                                             "");
//                                                                         finish(context);
//                                                                       },
//                                                                       child: Container(
//                                                                         padding: const EdgeInsets.all(6),
//                                                                         decoration: const BoxDecoration(
//                                                                             color: Colors.green,
//                                                                             shape: BoxShape.circle),
//                                                                         child: Image.asset(
//                                                                             "assets/images/phone.png",
//                                                                             height: 24,
//                                                                             width: 24,
//                                                                             color: Colors.white),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               );
//                                                             },
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 65,
//                                                           ),
//                                                         ],
//                                                       ));
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(6),
//                                                 decoration: const BoxDecoration(
//                                                     color: Colors.green, shape: BoxShape.circle),
//                                                 child: Image.asset("assets/images/phone.png",
//                                                     height: 24, width: 24, color: Colors.white),
//                                               ),
//                                             ),
//
//                                             //message
//                                             InkResponse(
//                                               onTap: () {
//                                                 if ((filteredContacts?[index].phones ?? []).isNotEmpty) {
//                                                   startScreen(context,
//                                                       screen: SmsScreen(
//                                                         contact: filteredContacts![index],
//                                                       ));
//                                                 } else {
//                                                   showSnackeBar(context, "Telefon raqam topilmadi!");
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(8),
//                                                 margin: const EdgeInsets.only(left: 8),
//                                                 decoration: const BoxDecoration(
//                                                     color: Colors.blue, shape: BoxShape.circle),
//                                                 child: Image.asset("assets/images/chat.png",
//                                                     height: 20, width: 20, color: Colors.white),
//                                               ),
//                                             ),
//
//                                             //info
//                                             InkResponse(
//                                               onTap: () {
//                                                 if ((filteredContacts?[index].phones ?? []).isNotEmpty) {
//                                                   // startScreen(context,
//                                                   //     screen: ContactInfo(
//                                                   //         // contact: filteredContacts![index],
//                                                   //         ));
//                                                 } else {
//                                                   showSnackeBar(context, "Telefon raqam topilmadi!");
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(7),
//                                                 margin: const EdgeInsets.only(left: 8),
//                                                 decoration: const BoxDecoration(
//                                                     color: Colors.grey, shape: BoxShape.circle),
//                                                 child: Image.asset("assets/images/info.png",
//                                                     height: 23, width: 23, color: Colors.white),
//                                               ),
//                                             ),
//
//                                             //
//                                             //favorite
//
//                                             InkResponse(
//                                               onTap: () {
//                                                 if (filteredContacts != null) {
//                                                   filteredContacts![index].isFavorite =
//                                                       !filteredContacts![index].isFavorite;
//                                                   PrefUtils.addFavoriteProduct(filteredContacts![index]);
//                                                   dataBase.updateContact(index, filteredContacts![index]);
//                                                   setState(() {});
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(7),
//                                                 margin: const EdgeInsets.only(left: 8),
//                                                 decoration: const BoxDecoration(
//                                                     color: Colors.indigoAccent, shape: BoxShape.circle),
//                                                 child: Image.asset("assets/images/favorite.png",
//                                                     height: 23,
//                                                     width: 23,
//                                                     color: filteredContacts?[index].isFavorite ?? false
//                                                         ? AppColors.ACCENT
//                                                         : AppColors.COLOR_PRIMARY2),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//
//                                         //opened bottom divider
//                                         Container(
//                                           margin: const EdgeInsets.only(top: 10),
//                                           color: themeProvider == ThemeMode.light
//                                               ? AppColors.COLOR_PRIMARY.withOpacity(.4)
//                                               : AppColors.GREY.withOpacity(.9),
//                                           height: .5,
//                                           width: getScreenWidth(context),
//                                         )
//                                       ]),
//                                     )
//                                   : SingleChildScrollView(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       scrollDirection: Axis.vertical,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SingleChildScrollView(
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             scrollDirection: Axis.horizontal,
//                                             child: Row(
//                                               children: [
//                                                 //closed circle name[0]
//                                                 Container(
//                                                   padding: const EdgeInsets.all(10),
//                                                   margin: const EdgeInsets.only(
//                                                       left: 8, top: 8, bottom: 8, right: 16),
//                                                   decoration: BoxDecoration(
//                                                       shape: BoxShape.circle, border: Border.all()),
//                                                   child: Text(
//                                                     (filteredContacts?[index].displayName ?? "").isNotEmpty
//                                                         ? (filteredContacts?[index].displayName?[0] ?? "")
//                                                         : "",
//                                                     style: const TextStyle(fontSize: 21),
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(filteredContacts![index].displayName ?? "",
//                                                         style: asTextStyle(fontFamily: "p_semi", size: 16)),
//                                                     if (searchController.text.isNotEmpty)
//                                                       Text(
//                                                         filteredContacts?[index].phones.firstOrNull ??
//                                                             "[Bo'sh]",
//                                                         style: asTextStyle(fontFamily: "p_reg"),
//                                                       ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//
//                                           //closed bottom divider
//                                           Container(
//                                             margin: const EdgeInsets.only(left: 52),
//                                             color: themeProvider == ThemeMode.light
//                                                 ? AppColors.COLOR_PRIMARY.withOpacity(.4)
//                                                 : AppColors.GREY.withOpacity(.9),
//                                             height: .5,
//                                             width: getScreenWidth(context),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                             ),
//                           );
//
//                           // ContactItemView(contact: filteredContacts![index2], position: index2);
//                         }),
//               ),
//             ],
//           ),
//           Container(
//             height: 32,
//             width: (filteredContacts?.length.toString().length ?? 0) * 16,
//             padding: const EdgeInsets.all(8),
//             margin: const EdgeInsets.only(top: 85, right: 0),
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(.0),
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(color: AppColors.BLACK.withOpacity(.1), blurRadius: 4, blurStyle: BlurStyle.outer)
//                 ],
//                 border: Border.all(color: AppColors.BLACK.withOpacity(.2), width: .4)),
//             alignment: Alignment.center,
//             child: Text(
//               (filteredContacts?.length ?? 0).toString(),
//               style: asTextStyle(
//                 fontFamily: "p_bold",
//               ),
//             ),
//           ),
//           if((filteredContacts??[]).isEmpty)
//             Center(child: showAsProgress())
//         ],
//       ),
//     ));
//   }
// }
