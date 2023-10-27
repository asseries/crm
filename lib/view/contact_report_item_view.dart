import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/model/report/contact_report_model.dart';
import 'package:crm/utils/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';

class ContactReportItemView extends StatelessWidget {
  final ContactReportModel item;
  final ThemeProvider themeProvider;
  final Function onClick;

  const ContactReportItemView(
      {Key? key, required this.item, required this.themeProvider, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurStyle: BlurStyle.outer, blurRadius: 4),
        ]),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name.isEmpty ? "(Noma'lum)" : item.name,
                  style: const TextStyle(fontFamily: "p_med"),
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.timer_fill,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      leftTimeAsTime(item.duration),
                      style: TextStyle(
                          fontFamily: "p_light",
                          fontSize: 12,
                          color: themeProvider.getThemeMode() == ThemeMode.dark
                              ? AppColors.ACCENT
                              : AppColors.BLUE),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.number),
                Text(
                  "${item.callCount} ta qo'ng'iroq",
                ),
              ],
            ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: const EdgeInsets.only(top: 4),
            //   child: Text(
            //     "${item.date.getDayOfEproch()} ${item.date.getMonthOfEproch().getMonthName()} ${item.date.getHourOfEproch()}:${item.date.getMinuteOfEproch()}",
            //     style: const TextStyle(fontFamily: "p_med", fontSize: 12),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
