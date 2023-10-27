// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'dart:io';
import 'dart:ui';

import 'package:as_toast_x/functions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/model/contact_model.dart';
import 'package:crm/utils/utils.dart';
import 'package:crm/view/call_log_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

import '../../model/audio_model.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/pref_utils.dart';
import '../player_screen.dart';
import '../sms/sms.dart';

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({Key? key}) : super(key: key);

  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  List<CallLogEntry> callLogList = [];
  List<CallLogEntry> filteredCallLogList = [];
  final searchController = TextEditingController();
  bool searchOpened = false;
  bool isLoading = false;

  getCallLogs() async {
    isLoading = true;
    _callLogEntries = await CallLog.query();
    setState(() {
      callLogList = _callLogEntries.toList();
      filteredCallLogList = callLogList;
      isLoading = false;
    });
  }

  //PLAYER
  List<AudioModel> audioList = [];
  List<FileSystemEntity> fileEntities = [];

  void _listOfFiles() async {
    String directory = PrefUtils.getRecFolder();
    fileEntities = Directory(directory).listSync(); //use your folder name insted of resume.
    for (var element in fileEntities) {
      try {
        audioList.add(
          AudioModel(element.path, element.path.split('/').last,
              File(element.path).lastModifiedSync().microsecondsSinceEpoch ~/ 1000, false, ""),
        );
      } catch (_) {}
    }
    audioList.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    // audioList = audioList.reversed.toList();
    setState(() {});
  }

  @override
  void initState() {
    getCallLogs();
    _listOfFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    final List<Widget> children = <Widget>[];
    for (CallLogEntry entry in _callLogEntries) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              'F. NUMBER  : ${entry.formattedNumber}',
            ),
            Text(
              'C.M. NUMBER: ${entry.cachedMatchedNumber}',
            ),
            Text(
              'NUMBER     : ${entry.number}',
            ),
            Text(
              'NAME       : ${entry.name}',
            ),
            Text(
              'TYPE       : ${entry.callType}',
            ),
            Text(
              'DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)}',
            ),
            Text(
              'DURATION   : ${entry.duration}',
            ),
            Text(
              'ACCOUNT ID : ${entry.phoneAccountId}',
            ),
            Text(
              'SIM NAME   : ${entry.simDisplayName}',
            ),
          ],
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (searchController.text.isNotEmpty) {
          searchController.text = "";
        } else {
          searchOpened = false;
          filteredCallLogList = callLogList;
        }
        setState(() {});
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            getStatusBarWidget(context),
            Container(
              padding: const EdgeInsets.all(8),
              width: getScreenWidth(context),
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
                            borderVisibility: false,
                            controller: searchController,
                            hintText: "Qidiruv...",
                            onChanged: (value) async {
                              setState(() {
                                if (value.isEmpty) {
                                  filteredCallLogList = callLogList;
                                  return;
                                }
                                filteredCallLogList = callLogList.where((element) {
                                  return ((element.name ?? "").toUpperCase().contains(value.toUpperCase()) ||
                                      ((element.number ?? "").toUpperCase().contains(value.toUpperCase())));
                                }).toList();
                              });
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "So'nggi qo'ng'iroqlar".toUpperCase(),
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

                        if (searchController.text.isEmpty) {
                          filteredCallLogList = callLogList;
                          return;
                        }
                        filteredCallLogList = callLogList
                            .where((element) => (element.name ?? "")
                                .toUpperCase()
                                .contains(searchController.text.toUpperCase()))
                            .toList();
                        setState(() {});
                      },
                      onLongPress: () {
                        searchController.text = "";
                        filteredCallLogList = callLogList;
                        setState(() {});
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
                        filteredCallLogList = callLogList;
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
                            color: (themeProvider.getThemeMode() == ThemeMode.dark
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
              child: isLoading
                  ? showAsProgress()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredCallLogList.length,
                      primary: false,
                      itemBuilder: (context, index) {
                        return CallLogItemView(
                          item: filteredCallLogList[index],
                          themeProvider: themeProvider,
                          onClick: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: asBluredForeground(
                                      sigma: 4,
                                      borderRadius: BorderRadius.circular(8),
                                      margin: const EdgeInsets.all(24),
                                      padding: const EdgeInsets.all(16),
                                      color: themeProvider.getThemeMode() == ThemeMode.light
                                          ? Colors.grey.withOpacity(.3)
                                          : Colors.blueGrey.withOpacity(.5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.BLACK.withOpacity(1),
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 4)
                                      ],
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Nomi:",
                                                style: TextStyle(fontFamily: "p_semi"),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  textAlign: TextAlign.end,
                                                  "${callLogList[index].name ?? callLogList[index].number}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontFamily: "p_med"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Raqam:",
                                                style: TextStyle(fontFamily: "p_semi"),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${callLogList[index].number}",
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      overflow: TextOverflow.ellipsis, fontFamily: "p_med"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Vaqt:",
                                                style: TextStyle(fontFamily: "p_semi"),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  ((callLogList[index].timestamp ?? 0)).formatEprochToDate(),
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(fontFamily: "p_med"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Davomiyligi:",
                                                style: TextStyle(fontFamily: "p_semi"),
                                              ),
                                              Expanded(
                                                child: Text(intToTimeLeft(callLogList[index].duration ?? 0),
                                                    style: const TextStyle(fontFamily: "p_med"),
                                                    textAlign: TextAlign.end),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  FlutterPhoneDirectCaller.callNumber(
                                                      callLogList[index].number ?? "");
                                                  finish(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(left: 8),
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green, shape: BoxShape.circle),
                                                  child: Image.asset("assets/images/phone.png",
                                                      height: 24, width: 24, color: Colors.white),
                                                ),
                                              ),
                                              InkResponse(
                                                onTap: () {
                                                  if (callLogList[index].number != "") {
                                                    startScreen(context,
                                                        screen: SmsScreen(
                                                            contact: ContactModel(
                                                                -1,
                                                                callLogList[index].name ?? "",
                                                                callLogList[index].number ?? "",
                                                                false,
                                                                // null,
                                                                false)));
                                                  } else {
                                                    showSnackeBar(context, "Telefon raqam topilmadi!");
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(left: 8),
                                                  decoration: const BoxDecoration(
                                                      color: Colors.blue, shape: BoxShape.circle),
                                                  child: Image.asset("assets/images/chat.png",
                                                      height: 24, width: 24, color: Colors.white),
                                                ),
                                              ),
                                              InkResponse(
                                                onTap: () async {
                                                  if ((callLogList[index].duration ?? 0) > 0) {
                                                    //
                                                    var callLogItem = callLogList[index];
                                                    for (var audio in audioList) {
                                                      if (audio.date~/100000 -(callLogItem.timestamp??0)~/100000<=1) {
                                                        startScreen(context,
                                                            screen: PlayerScreen(audio: audio));
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    showWarning(context, "So'zlashuv vaqti 0");
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(left: 8),
                                                  decoration: const BoxDecoration(
                                                      color: Colors.grey, shape: BoxShape.circle),
                                                  child: Image.asset("assets/images/mic.png",
                                                      height: 24, width: 24, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
