import 'package:as_toast_x/utils.dart';
import 'package:call_log/call_log.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/providers/filter_provider.dart';
import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/time_utils.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/contact_model.dart';
import '../../../providers/contact_provider.dart';
import '../../../providers/theme_provider.dart';

class ChartReportScreen extends StatefulWidget {
  const ChartReportScreen({Key? key}) : super(key: key);

  @override
  State<ChartReportScreen> createState() => _ChartReportScreenState();
}

class _ChartReportScreenState extends State<ChartReportScreen> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  List<CallLogEntry> callLogList = [];
  bool isLoading = false;

  List<ContactModel> contactList = [];
  int outgoingCallDuration = 0;
  int incomingCallDuration = 0;

  getCallLogs() async {
    int filter = Provider.of<FilterProvider>(context,listen: false).getDateFilter();
    isLoading = true;
    _callLogEntries = await CallLog.query();
    setState(() {
      callLogList = _callLogEntries
          .toList()
          .where((element) => filter == 7
                  ? ((element.timestamp ?? 0).getDayOfEproch() == DateTime.now().day)
                  : filter == 30
                      ? ((element.timestamp ?? 0).getDayOfEproch() == DateTime.now().month)
                      : ((element.timestamp ?? 0).getDayOfEproch() == DateTime.now().month)
              // && (element.duration ?? 0) > 0
              )
          .toList();
      isLoading = false;
    });
  }

  getChartReport() async {
    for (var callLog in callLogList) {
      if (callLog.callType == CallType.outgoing) {
        outgoingCallDuration += callLog.duration ?? 0;
      } else if (callLog.callType == CallType.incoming) {
        incomingCallDuration += callLog.duration ?? 0;
      }
    }
  }

  @override
  void initState() {
    contactList = Provider.of<ContactProvider>(context, listen: false).contactList;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getCallLogs();
      await getChartReport();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: AppColors.ACCENT.withOpacity(.4),
            width: getScreenWidth(context),
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Kirish va chiqish daqiqalari bo'yicha hisobot",
              style: TextStyle(fontFamily: "p_semi"),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartPie(
                    data: [
                      {'domain': leftTimeAsLabel(outgoingCallDuration), 'measure': outgoingCallDuration},
                      {'domain': leftTimeAsLabel(incomingCallDuration), 'measure': incomingCallDuration},
                    ],
                    fillColor: (pieData, index) {
                      return index == 0 ? Colors.blue : Colors.green;
                    },
                    pieLabel: (pieData, index) {
                      return "${pieData['domain']}";
                    },
                    labelLineColor:
                        themeProvider == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
                    labelColor: themeProvider == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
                    labelPosition: PieLabelPosition.auto,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.call_made_rounded,
                          color: Colors.blue,
                          size: 12,
                        ),
                        Text(leftTimeAsLabel(outgoingCallDuration)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.call_received_outlined,
                          color: Colors.green,
                          size: 12,
                        ),
                        Text(leftTimeAsLabel(incomingCallDuration)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
