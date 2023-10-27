import 'dart:async';
import 'dart:io';

import 'package:as_toast_x/functions.dart';
import 'package:crm/api/main_view_model.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/providers/theme_provider.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/utils.dart';
import 'package:crm/view/contact_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../model/audio_model.dart';
import '../../model/event_model.dart';
import '../../model/state_model.dart';
import '../../providers/contact_provider.dart';
import '../../service/b_service.dart';
import '../../utils/constants.dart';
import '../../utils/event_bus.dart';
import '../../utils/pref_utils.dart';
import '../../view/dial_button.dart';
import '../sms/sms.dart';

// @pragma('vm:entry-point')
// Future<void> callerCallbackHandler(
//   CallerEvent event,
//   String number,
//   int duration,
// ) async {
//   // print("New event received from native $event");
//   await PrefUtils.initInstance();
//   // await Hive.initFlutter();
//   // if(!Hive.isAdapterRegistered(0)){
//   //   Hive.registerAdapter(StateModelAdapter());
//   // }
//   // Database db = Database();
//   switch (event) {
//     case CallerEvent.incoming:
//       LocalNotification.showNotification("CRM", number, true);
//       Fluttertoast.showToast(msg: "CRM");
//       PrefUtils.addCallState(StateModelForPrefs(
//           event.toString(), (DateTime.now().millisecondsSinceEpoch ~/ 10000) * 10000, number));
//       PrefUtils.setCheck(event.toString());
//       PrefUtils.reload();
//
//       break;
//     case CallerEvent.outgoing:
//       LocalNotification.showNotification("CRM", number, true);
//       Fluttertoast.showToast(msg: "CRM");
//       PrefUtils.addCallState(StateModelForPrefs(
//           event.toString(), (DateTime.now().millisecondsSinceEpoch ~/ 10000) * 10000, number));
//       PrefUtils.setCheck(event.toString());
//       PrefUtils.reload();
//       break;
//   }
// }

class Dial extends StatefulWidget {
  const Dial({Key? key}) : super(key: key);

  @override
  State<Dial> createState() => _DialState();
}

class _DialState extends State<Dial> with TickerProviderStateMixin {
  bool searchOpened = false;
  StreamSubscription? busEventListener;

  //RECORDINGS
  String directory = "";
  List<AudioModel> audioList = [];
  List<FileSystemEntity> fileEntities = [];

  //TIMER
  Timer? _myTimer;

  void _listOfFiles() async {
    audioList = [];
    try {
      String directory = PrefUtils.getRecFolder();
      fileEntities = Directory(directory).listSync();
    } catch (e) {}

    if (fileEntities.isEmpty) {} //use your folder name insted of resume.
    for (var element in fileEntities) {
      try {
        audioList.add(AudioModel(element.path, element.path.split('/').last,
            ((File(element.path).lastModifiedSync().microsecondsSinceEpoch ~/ 10000000)) * 10000, false, ""));
      } catch (_) {}
    }

    audioList.sort((a, b) {
      return b.date.compareTo(a.date); // 10:00, 9:58,9:10...
    });

    for (var e in audioList) {
      if (e.date <= PrefUtils.getLastDate()) {
        e.sent = true;
      }
    }
  }

  @override
  void initState() {
    // Fluttertoast.showToast( msg: PrefUtils.getToken());
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    _listOfFiles();
    busEventListener = eventBus.on<EventModel>().listen((event){
      if(event.event==EVENT_SEND_AUDIO_ERROR){
        showError(context, event.data.toString());
      }
    });

    super.initState();
  }

  _calling(String phone) async {
    FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    return WillPopScope(
      onWillPop: () async {
        //dialog
        return false;
      },
      child: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          return ViewModelBuilder<MainViewModel>.reactive(
            viewModelBuilder: () => MainViewModel(),
            builder: (context, viewModel, child) {
              return Scaffold(
                body: !isLandscape(context)
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              getStatusBarWidget(context),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: getScreenWidth(context),
                                height: 56,
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.BLACK.withOpacity(.2),
                                      blurRadius: 4,
                                      blurStyle: BlurStyle.outer)
                                ]),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        icon: const Icon(Icons.menu)),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Raqam terish oynasi".toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: "p_semi",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: provider.displayText.isEmpty
                                        ? Container()
                                        : ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: provider.filteredContacts.length,
                                            itemBuilder: (context, index) {
                                              return ContactItemView(
                                                  position: index,
                                                  item: provider.filteredContacts[index],
                                                  favorite: () {
                                                    provider.setFavoriteContact(
                                                        provider.filteredContacts[index].id.toString(),
                                                        !(provider.filteredContacts[index].favorite));
                                                  });
                                            },
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color:
                                      (themeMode != ThemeMode.dark ? Colors.white : Colors.blueGrey.shade900),
                                ),
                                child: SizedBox(
                                  width: getScreenWidth(context),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        provider.displayText,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DialButton(
                                                number: "1",
                                                symbol: "_",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}1");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "2",
                                                symbol: "ABC",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}2");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "3",
                                                symbol: "DEF",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}3");
                                                }),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DialButton(
                                                number: "4",
                                                symbol: "GHI",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}4");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "5",
                                                symbol: "JKL",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}5");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "6",
                                                symbol: "MNO",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}6");
                                                }),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DialButton(
                                                number: "7",
                                                symbol: "PQRS",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}7");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "8",
                                                symbol: "TUV",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}8");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "9",
                                                symbol: "WXYZ",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}9");
                                                }),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DialButton(
                                                number: "*",
                                                symbol: "",
                                                onClick: () {
                                                  setState(() {});
                                                  provider.setDisplayText("${provider.displayText}*");
                                                }),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                              number: "0",
                                              symbol: "+",
                                              onClick: () {
                                                provider.setDisplayText("${provider.displayText}0");
                                              },
                                              longClick: () {
                                                provider.setDisplayText("${provider.displayText}+");
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: DialButton(
                                                number: "#",
                                                symbol: "",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}#");
                                                }),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkResponse(
                                              onTap: () {},
                                              radius: 28,
                                              highlightColor: Colors.green,
                                              splashColor: Colors.green.withOpacity(.4),
                                              child: Container(
                                                  padding: const EdgeInsets.all(12),
                                                  child: const SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                  )),
                                            ),
                                            InkResponse(
                                              onTap: () {
                                                _calling(provider.displayText.toString());
                                              },
                                              radius: 28,
                                              highlightColor: Colors.green,
                                              splashColor: Colors.green.withOpacity(.4),
                                              child: Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle, color: Colors.green),
                                                  child: Image.asset(
                                                    "assets/images/phone.png",
                                                    color: AppColors.WHITE,
                                                    width: 30,
                                                    height: 30,
                                                  )),
                                            ),
                                            provider.displayText.isNotEmpty
                                                ? InkResponse(
                                                    onTap: () {
                                                      // vibrateLight();
                                                      if (provider.displayText.isNotEmpty) {
                                                        var displayLength = provider.displayText.length;
                                                        if (displayLength == 2) {
                                                          provider.setDisplayText("");
                                                        } else {
                                                          provider.setDisplayText(provider.displayText
                                                              .substring(0, displayLength - 1));
                                                        }
                                                      } else {
                                                        provider.setDisplayText("");
                                                      }
                                                    },
                                                    onLongPress: () {
                                                      provider.setDisplayText("");
                                                    },
                                                    radius: 28,
                                                    splashColor: Colors.black.withOpacity(.2),
                                                    child: Container(
                                                        padding: const EdgeInsets.all(12),
                                                        child: Image.asset(
                                                          "assets/images/clear.png",
                                                          width: 35,
                                                          height: 35,
                                                          color: Provider.of<ThemeProvider>(context)
                                                                      .getThemeMode() ==
                                                                  ThemeMode.dark
                                                              ? AppColors.WHITE
                                                              : AppColors.BLACK,
                                                        )),
                                                  )
                                                : Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 29.5, vertical: 29.5),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 90,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          getStatusBarWidget(context),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: double.maxFinite,
                            height: 56,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColors.BLACK.withOpacity(.2),
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.outer)
                            ]),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    icon: const Icon(Icons.menu)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 12),
                                  child: Text(
                                    "Raqam terish oynasi".toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: "p_semi",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    provider.displayText,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 10,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      provider.filteredContacts == []
                                          ? Container()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              physics: const BouncingScrollPhysics(),
                                              itemCount: provider.filteredContacts.length,
//_contacts!.length,
                                              itemBuilder: (context, index) {
                                                if (provider.getActivePosition() != index) {
                                                  provider.filteredContacts[index].isOpen = false;
                                                }
                                                return InkWell(
                                                  onTap: () async {
                                                    provider.setActivePostion(index);
                                                    provider.filteredContacts[index].isOpen =
                                                        !provider.filteredContacts[index].isOpen;
                                                    setState(() {});
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: 100.milliseconds,
                                                    height: provider.filteredContacts[index].isOpen
                                                        ? (125 +
                                                            (provider.filteredContacts[index].number.length *
                                                                (provider.filteredContacts[index].number
                                                                            .length ==
                                                                        1
                                                                    ? 0
                                                                    : 14)))
                                                        : provider.displayText.isNotEmpty
                                                            ? 80
                                                            : 64,
                                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                                    child: provider.filteredContacts[index].isOpen == true
                                                        ? Expanded(
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
//opened circle name[0]
                                                                        Container(
                                                                          padding: const EdgeInsets.all(10),
                                                                          margin: const EdgeInsets.only(
                                                                              left: 8, right: 16),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all()),
                                                                          child: Text(
                                                                            (provider.filteredContacts[index]
                                                                                            .name ??
                                                                                        "")
                                                                                    .isNotEmpty
                                                                                ? (provider
                                                                                        .filteredContacts[
                                                                                            index]
                                                                                        .name?[0] ??
                                                                                    "")
                                                                                : "",
                                                                            style:
                                                                                const TextStyle(fontSize: 21),
                                                                          ),
                                                                        ),

                                                                        Text(
                                                                            provider.filteredContacts[index]
                                                                                    .name ??
                                                                                "",
                                                                            style: asTextStyle(
                                                                                fontFamily: "p_semi",
                                                                                size: 16)),
                                                                      ],
                                                                    ),

                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.only(left: 54),
                                                                      child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        primary: false,
                                                                        itemCount: provider
                                                                            .filteredContacts[index]
                                                                            .number
                                                                            .length,
//fullContact?.number.length,
                                                                        itemBuilder: (context, index2) {
                                                                          return Text(
                                                                            "${index2 + 1}. ${(provider.filteredContacts[index].number == "") ? "[Raqamlar mavjud emas]" : provider.filteredContacts[index].number[index2] ?? "Bo'sh"}",
                                                                            style: asTextStyle(),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceEvenly,
                                                                      children: [
//call
                                                                        InkResponse(
                                                                          onTap: () {
                                                                            if (provider
                                                                                    .filteredContacts[index]
                                                                                    .number
                                                                                    .length ==
                                                                                1) {
                                                                              _calling(provider
                                                                                  .filteredContacts[index]
                                                                                  .number);
                                                                            } else {
                                                                              showAsBottomSheet(
                                                                                  backgroundColor: PrefUtils
                                                                                              .getThemeMode() ==
                                                                                          ThemeMode.light
                                                                                      ? AppColors
                                                                                          .COLOR_PRIMARY2
                                                                                      : AppColors
                                                                                          .COLOR_PRIMARY,
                                                                                  context,
                                                                                  Column(
                                                                                    mainAxisSize:
                                                                                        MainAxisSize.min,
                                                                                    crossAxisAlignment:
                                                                                        CrossAxisAlignment
                                                                                            .start,
                                                                                    children: [
                                                                                      const SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding:
                                                                                            const EdgeInsets
                                                                                                .all(8.0),
                                                                                        child: Text(
                                                                                          "Qaysi telefon raqamidan qo'ng'iroq qilmoqchisiz?",
                                                                                          style: asTextStyle(
                                                                                              fontFamily:
                                                                                                  "p_semi"),
                                                                                        ),
                                                                                      ),
                                                                                      ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        primary: false,
                                                                                        itemCount: provider
                                                                                            .filteredContacts[
                                                                                                index]
                                                                                            .number
                                                                                            .length,
                                                                                        itemBuilder: (context,
                                                                                            index3) {
                                                                                          return Container(
                                                                                            margin:
                                                                                                const EdgeInsets
                                                                                                    .all(8),
                                                                                            child: Row(
                                                                                              mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .spaceBetween,
                                                                                              children: [
                                                                                                Text(
                                                                                                  provider
                                                                                                      .filteredContacts[
                                                                                                          index]
                                                                                                      .number[index3],
                                                                                                  style: asTextStyle(
                                                                                                      fontWeight:
                                                                                                          FontWeight.w900),
                                                                                                ),
                                                                                                InkResponse(
                                                                                                  onTap: () {
                                                                                                    _calling(provider
                                                                                                            .filteredContacts[index]
                                                                                                            .number[index3] ??
                                                                                                        "");
                                                                                                    finish(
                                                                                                        context);
                                                                                                  },
                                                                                                  child:
                                                                                                      Container(
                                                                                                    padding:
                                                                                                        const EdgeInsets.all(
                                                                                                            6),
                                                                                                    decoration: const BoxDecoration(
                                                                                                        color: Colors
                                                                                                            .green,
                                                                                                        shape:
                                                                                                            BoxShape.circle),
                                                                                                    child: Image.asset(
                                                                                                        "assets/images/phone.png",
                                                                                                        height:
                                                                                                            24,
                                                                                                        width:
                                                                                                            24,
                                                                                                        color:
                                                                                                            Colors.white),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 65,
                                                                                      ),
                                                                                    ],
                                                                                  ));
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.green,
                                                                                shape: BoxShape.circle),
                                                                            child: Image.asset(
                                                                                "assets/images/phone.png",
                                                                                height: 24,
                                                                                width: 24,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),

//message
                                                                        InkResponse(
                                                                          onTap: () {
                                                                            if (provider
                                                                                    .filteredContacts[index]
                                                                                    .number !=
                                                                                "") {
                                                                              startScreen(context,
                                                                                  screen: SmsScreen(
                                                                                      contact: provider
                                                                                              .filteredContacts[
                                                                                          index]));
                                                                            } else {
                                                                              showSnackeBar(context,
                                                                                  "Telefon raqam topilmadi!");
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(8),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 8),
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.blue,
                                                                                shape: BoxShape.circle),
                                                                            child: Image.asset(
                                                                                "assets/images/chat.png",
                                                                                height: 20,
                                                                                width: 20,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),

//info
                                                                        InkResponse(
                                                                          onTap: () {
                                                                            if (provider
                                                                                .filteredContacts[index]
                                                                                .number
                                                                                .isEmpty) {
                                                                            } else {
                                                                              showSnackeBar(context,
                                                                                  "Telefon raqam topilmadi!");
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(7),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 8),
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.grey,
                                                                                shape: BoxShape.circle),
                                                                            child: Image.asset(
                                                                                "assets/images/info.png",
                                                                                height: 23,
                                                                                width: 23,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),

//
//favorite

                                                                        InkResponse(
                                                                          onTap: () {
                                                                            provider.filteredContacts[index]
                                                                                    .favorite =
                                                                                !provider
                                                                                    .filteredContacts[index]
                                                                                    .favorite;
                                                                            provider.setFavoriteContact(
                                                                                provider
                                                                                    .filteredContacts[index]
                                                                                    .id
                                                                                    .toString(),
                                                                                !(provider
                                                                                    .filteredContacts[index]
                                                                                    .favorite));
                                                                          },
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(7),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 8),
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.indigoAccent,
                                                                                shape: BoxShape.circle),
                                                                            child: Image.asset(
                                                                                "assets/images/favorite.png",
                                                                                height: 23,
                                                                                width: 23,
                                                                                color: provider
                                                                                            .filteredContacts[
                                                                                                index]
                                                                                            .favorite ??
                                                                                        false
                                                                                    ? AppColors.ACCENT
                                                                                    : AppColors
                                                                                        .COLOR_PRIMARY2),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

//opened bottom divider
                                                                    Container(
                                                                      margin: const EdgeInsets.only(top: 10),
                                                                      color: themeMode == ThemeMode.light
                                                                          ? AppColors.COLOR_PRIMARY
                                                                              .withOpacity(.4)
                                                                          : AppColors.GREY.withOpacity(.9),
                                                                      height: .5,
                                                                      width: getScreenWidth(context),
                                                                    )
                                                                  ]),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    children: [
//closed circle name[0]
                                                                      Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        margin: const EdgeInsets.only(
                                                                            left: 8,
                                                                            top: 8,
                                                                            bottom: 8,
                                                                            right: 16),
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: Border.all()),
                                                                        child: Text(
                                                                          (provider.filteredContacts[index]
                                                                                          .name ??
                                                                                      "")
                                                                                  .isNotEmpty
                                                                              ? (provider
                                                                                      .filteredContacts[index]
                                                                                      .name?[0] ??
                                                                                  "")
                                                                              : "",
                                                                          style:
                                                                              const TextStyle(fontSize: 21),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              provider.filteredContacts[index]
                                                                                      .name ??
                                                                                  "",
                                                                              style: asTextStyle(
                                                                                  fontFamily: "p_semi",
                                                                                  size: 16)),
                                                                          if (provider.displayText.isNotEmpty)
                                                                            Text(
                                                                              provider.filteredContacts[index]
                                                                                  .number,
                                                                              style: asTextStyle(
                                                                                  fontFamily: "p_reg"),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

//closed bottom divider
                                                                  Container(
                                                                    margin: const EdgeInsets.only(left: 52),
                                                                    color: themeMode == ThemeMode.light
                                                                        ? AppColors.COLOR_PRIMARY
                                                                            .withOpacity(.4)
                                                                        : AppColors.GREY.withOpacity(.9),
                                                                    height: .5,
                                                                    width: getScreenWidth(context),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                );
                                              }),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            DialButton(
                                                number: "1",
                                                symbol: "_",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}1");
                                                }),
                                            DialButton(
                                                number: "2",
                                                symbol: "ABC",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}2");
                                                }),
                                            DialButton(
                                                number: "3",
                                                symbol: "DEF",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}3");
                                                }),
                                            DialButton(
                                                number: "4",
                                                symbol: "GHI",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}4");
                                                }),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            DialButton(
                                                number: "5",
                                                symbol: "JKL",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}5");
                                                }),
                                            DialButton(
                                                number: "6",
                                                symbol: "MNO",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}6");
                                                }),
                                            DialButton(
                                                number: "7",
                                                symbol: "PQRS",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}7");
                                                }),
                                            DialButton(
                                                number: "8",
                                                symbol: "TUV",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}8");
                                                }),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            DialButton(
                                                number: "9",
                                                symbol: "WXYZ",
                                                onClick: () {
                                                  provider.setDisplayText("${provider.displayText}9");
                                                }),
                                            DialButton(
                                                number: "*",
                                                symbol: "",
                                                onClick: () {
                                                  setState(() {});
                                                  provider.setDisplayText("$provider.displayText*");
                                                }),
                                            DialButton(
                                              number: "0",
                                              symbol: "+",
                                              onClick: () {
                                                provider.setDisplayText("${provider.displayText}0");
                                              },
                                              longClick: () {
                                                provider.setDisplayText("$provider.displayText+");
                                              },
                                            ),
                                            DialButton(
                                                number: "#",
                                                symbol: "",
                                                onClick: () {
                                                  provider.setDisplayText("$provider.displayText#");
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkResponse(
                                    onTap: () {},
                                    radius: 28,
                                    highlightColor: Colors.green,
                                    splashColor: Colors.green.withOpacity(.4),
                                    child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: const SizedBox(
                                          width: 30,
                                          height: 30,
                                        )),
                                  ),
                                  InkResponse(
                                    onTap: () {
                                      _calling(provider.displayText.toString());
                                    },
                                    radius: 28,
                                    highlightColor: Colors.green,
                                    splashColor: Colors.green.withOpacity(.4),
                                    child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration:
                                            const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                        child: Image.asset(
                                          "assets/images/phone.png",
                                          color: AppColors.WHITE,
                                          width: 30,
                                          height: 30,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 80),
                                    child: provider.displayText.isNotEmpty
                                        ? InkResponse(
                                            onTap: () {
                                              vibrateLight();
                                              provider.setDisplayText(provider.displayText
                                                  .substring(0, provider.displayText.length - 1));
                                            },
                                            onLongPress: () {
                                              provider.setDisplayText("");
                                            },
                                            radius: 28,
                                            splashColor: Colors.black.withOpacity(.2),
                                            child: Container(
                                                padding: const EdgeInsets.all(12),
                                                child: Image.asset(
                                                  "assets/images/clear.png",
                                                  width: 35,
                                                  height: 35,
                                                  color: Provider.of<ThemeProvider>(context).getThemeMode() ==
                                                          ThemeMode.dark
                                                      ? AppColors.WHITE
                                                      : AppColors.BLACK,
                                                )),
                                          )
                                        : Container(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 29.5, vertical: 29.5),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              )
                            ],
                          ))
                        ],
                      ),
              );
            },
            onModelReady: (viewModel) {
              PrefUtils.reload();
              // _myTimer?.cancel(); //in case we have a timer, we'll cancel it.
              // _myTimer = Timer.periodic(12.seconds, (timer) {
              //   StateModelForPrefs? prefItem;
              //   List<StateModelForPrefs> prefItems = PrefUtils.getCallStateList();
              //
              //   if (prefItems.isEmpty) {
              //     print("REEEEEEEEEEEEEEEEEEEEEETURN TICK");
              //     return;
              //   } //birinchi martada prefs yangilanmaydi shunga return
              //   print("TIMEEEEEEEEEEEEEEEEEEEEEEER TICK");
              //
              //   prefItems.sort((a, b) {
              //     return b.date.compareTo(a.date);
              //   });
              //
              //   prefItem = prefItems.lastOrNull; // 10:00, 9:58,9:10... => 9:10
              //
              //   // PrefUtils.getCallStateList().forEach((prefI) {
              //   //   if (prefI.date > PrefUtils.getLastDate()) {
              //   //     prefItem = prefI;
              //   //   }
              //   // });
              //
              //   String? path;
              //   for (var audio in audioList) {
              //     int audioTime = (audio.date);
              //     int prefTime = (prefItem?.date ?? 0);
              //     if ((prefTime - audioTime) <= 10000) {
              //       path = audio.fullPath;
              //     }
              //     print("PREF:  $prefTime          AUDIO:   $audioTime");
              //   }
              //   if (path == null) {
              //     PrefUtils.removeCallState(prefItem!);
              //     print(
              //         "PATH NULL DELETED PrefItem ===========> EPPROCH: ${prefItem.date}   PHONE: ${prefItem?.phone}");
              //     //
              //   } else if (prefItem != null) {
              //     // viewModel.sendAudio(path, prefItem.phone, prefItem.date);
              //   }
              // });

              viewModel.audioStream.listen((event) {
                StateModelForPrefs? item1;
                PrefUtils.getCallStateList().forEach((prefState) {
                  int prefTime = prefState.date;
                  int serverTime = (int.parse(event.date));
                  if (prefTime - serverTime <= 10000) {
                    item1 = prefState;
                    print("DELETION==========> Prefs: $prefTime  Server: $serverTime");
                  }
                });
                if (item1 != null) {
                  PrefUtils.removeCallState(item1!);
                  PrefUtils.setLastDate(int.parse(event.date));
                  _listOfFiles();
                  setState(() {});
                }

                // showSuccess(context, "${event.recordName} yozuvi saqlandi");
                // Fluttertoast.showToast(msg: "${event.recordName} yozuvi saqlandi");
                Fluttertoast.showToast(msg: "Qolgan fayllar ${PrefUtils.getCallStateList().length}");
              });

              viewModel.errorData.listen((event) {
                Fluttertoast.showToast(msg: event);
              });
            },
          );
        },
      ),
    );
  }
}
