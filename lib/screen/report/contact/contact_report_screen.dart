import 'dart:async';

import 'package:as_toast_x/functions.dart';
import 'package:call_log/call_log.dart';
import 'package:collection/collection.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:crm/view/contact_report_item_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../model/contact_model.dart';
import '../../../model/event_model.dart';
import '../../../model/report/contact_report_model.dart';
import '../../../providers/contact_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/event_bus.dart';

class ContactReportScreen extends StatefulWidget {
  const ContactReportScreen({Key? key}) : super(key: key);

  @override
  State<ContactReportScreen> createState() => _ContactReportScreenState();
}

class _ContactReportScreenState extends State<ContactReportScreen> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  List<CallLogEntry> callLogList = [];
  bool isLoading = false;

  List<ContactModel> contactList = [];
  List<ContactReportModel> contactReportList = [];

  StreamSubscription? busEventListener;


  getCallLogs() async {
    isLoading = true;
    _callLogEntries = await CallLog.query();
    // setState(() {
    //   callLogList = _callLogEntries.toList()
    //       .where((element) {
    //         return ((element.timestamp ?? 0).getDayOfEproch() == DateTime.now().day);
    //       }
    //     // && (element.duration ?? 0) > 0
    //   )
    //       .toList();
    //   isLoading = false;
    // });
    setState(() {
      callLogList = _callLogEntries.toList();
    });
  }

  getContactReport() async {
    List<ContactReportModel> tempContactReport = [];
    for (var callLog in callLogList) {
      var callLogs = callLogList
          .where((element) => (element.name ?? "").isNotEmpty
              ? element.name == callLog.name
              : element.number == callLog.number)
          .toList();
      var duration = 0;
      for (var i in callLogs) {
        duration += (i.duration ?? 0);
      }
      if (
          //HAFTALIK
          (PrefUtils.getDateFilter() == 7 &&
                  DateTime.now().firstDateOfTheWeek().isBefore(DateTime.parse(
                      (callLog.timestamp ?? 0).formatEprochToDate().formattedToAnotherFormat()))) &&
              (DateTime.now().findLastDateOfTheWeek().isAfter(DateTime.parse(
                  (callLog.timestamp ?? 0).formatEprochToDate().formattedToAnotherFormat())))) {
        tempContactReport.add(ContactReportModel(callLog.name ?? "", callLog.number ?? "", duration,
            callLogs.length, callLog.callType, callLog.timestamp ?? 0));
      } else if (
          //OYLIK
          (PrefUtils.getDateFilter() == 30 &&
                  DateTime.now().add(-30.days).isBefore(DateTime.parse(
                      (callLog.timestamp ?? 0).formatEprochToDate().formattedToAnotherFormat()))) &&
              (DateTime.now().isAfter(DateTime.parse(
                  (callLog.timestamp ?? 0).formatEprochToDate().formattedToAnotherFormat())))) {
        tempContactReport.add(ContactReportModel(callLog.name ?? "", callLog.number ?? "", duration,
            callLogs.length, callLog.callType, callLog.timestamp ?? 0));
      } else if(PrefUtils.getDateFilter() == 90){
        showSuccess(context, "CONTACT LENGTH: ${contactReportList.length}");

        contactReportList.clear();
      }
    }

    tempContactReport.sort((a, b) {
      return (b.callCount).compareTo(a.callCount); //3,2,1
    });

    for (var temp in tempContactReport) {
      var item = tempContactReport.firstWhereOrNull((element) =>
          (element.name ?? "").isNotEmpty ? element.name == temp.name : element.number == temp.number);
      if (contactReportList.isEmpty && item != null) {
        contactReportList.add(item);
      } else {
        bool isHave = contactReportList
            .where((element) =>
                (element.name ?? "").isNotEmpty ? element.name == temp.name : element.number == temp.number)
            .toList()
            .isNotEmpty;
        if (!isHave && item != null) {
          contactReportList.add(item);
        }
      }
    }
  }

  @override
  void initState() {
    contactList = Provider.of<ContactProvider>(context, listen: false).contactList;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getCallLogs();
      await getContactReport();
    });

    busEventListener = eventBus.on<EventModel>().listen((event) async {
      if (event.event == EVENT_UPDATE_REPORT_FILTER) {
       await getContactReport();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    print("REPORT COUNT: ${contactReportList.length}");
    return Scaffold(
        body: ListView.builder(
      physics: const BouncingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: contactReportList.length,
      itemBuilder: (context, index) {
        return ContactReportItemView(
            item: contactReportList[index], themeProvider: themeProvider, onClick: () {});
      },
    ));
  }
}
