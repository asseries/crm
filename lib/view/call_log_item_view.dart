import 'package:call_log/call_log.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';

class CallLogItemView extends StatelessWidget {
  final CallLogEntry item;
  final ThemeProvider themeProvider;
  final Function onClick;

  const CallLogItemView({Key? key, required this.item, required this.themeProvider, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: () => onClick(),
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.only(bottom: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Center(child: getPhoneTypeImage(item.callType))),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item.name ?? item.number}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "p_med"),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ((item.timestamp?? 0)).formatEprochToDate(),
                                style: const TextStyle(fontFamily: "p_light",fontSize: 10),
                              ),
                              Text(
                                intToTimeLeft(item.duration ?? 0),
                                style: const TextStyle(fontFamily: "p_light",fontSize: 10),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 1,
                        color: Colors.grey.withOpacity(.1),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getPhoneTypeImage(CallType? callType) {
    if (callType == CallType.incoming) {
      return Image.asset(
        "assets/images/incoming1.png",
        width: 24,
        height: 16,
        color: Colors.grey,
      );
    } else if (callType == CallType.outgoing) {
      return Image.asset(
        "assets/images/outgoing1.png",
        width: 24,
        height: 24,
        color: Colors.green,
      );
    } else if (callType == CallType.missed) {
      return Image.asset(
        "assets/images/missing1.png",
        width: 24,
        height: 20,
        color: Colors.red,
      );
    } else if (callType == CallType.rejected) {
      return Image.asset(
        "assets/images/reject1.png",
        width: 24,
        height: 18,
        color: AppColors.CYAN,
      );
    } else if (callType == CallType.unknown) {
      return Image.asset(
        "assets/images/phone.png",
        width: 24,
        height: 24,
        color: themeProvider == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.COLOR_PRIMARY2,
      );
    }
    return Container();
  }
}
