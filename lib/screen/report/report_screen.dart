import 'package:crm/extensions/extensions.dart';
import 'package:crm/model/event_model.dart';
import 'package:crm/model/state_model.dart';
import 'package:crm/providers/filter_provider.dart';
import 'package:crm/screen/report/chart/chart_report_screen.dart';
import 'package:crm/screen/report/contact/contact_report_screen.dart';
import 'package:crm/utils/constants.dart';
import 'package:crm/utils/event_bus.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor =
        themeProvider.getThemeMode() == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.COLOR_PRIMARY2;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            body: Column(
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
                  InkResponse(
                    onTap: () {
                      vibrateLight();
                      finish(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Text(
                      "Hisobotlar",
                      style: TextStyle(fontSize: 18, fontFamily: "p_bold"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      PrefUtils.addCallState(StateModelForPrefs(
                          "state",
                          (DateTime.now().add(-10.days).millisecondsSinceEpoch / 1000).round(),
                          12,
                          "",
                          DateTime.now().toString()));
                    },
                    child: Text(
                      Provider.of<FilterProvider>(context).getDateFilter() == 7
                          ? "Haftalik"
                          : PrefUtils.getDateFilter() == 30
                              ? "Oylik"
                              : "Barchasi",
                      style: const TextStyle(fontFamily: "p_light", fontSize: 13),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showAsBottomSheet(
                            context,
                            backgroundColor: themeProvider.getThemeMode() == ThemeMode.light
                                ? AppColors.COLOR_PRIMARY2
                                : AppColors.COLOR_PRIMARY,
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Provider.of<FilterProvider>(context, listen: false).setDateFilter(90);
                                      Fluttertoast.showToast(msg: "Barchasi qo'ng'iroqlar tarixi...");
                                      eventBus.fire(EventModel(event: EVENT_UPDATE_REPORT_FILTER, data: 0));
                                      finish(context);
                                    },
                                    child: SizedBox(
                                      width: getScreenWidth(context),
                                      child: const Text(
                                        "Barchasi",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "p_semi"),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<FilterProvider>(context, listen: false).setDateFilter(7);
                                      Fluttertoast.showToast(msg: "Bir haftalik qo'ng'iroqlar tarixi...");
                                      finish(context);
                                    },
                                    child: SizedBox(
                                      width: getScreenWidth(context),
                                      child: const Text(
                                        "Haftalik",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "p_semi"),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  //
                                  InkWell(
                                    onTap: () {
                                      Provider.of<FilterProvider>(context, listen: false).setDateFilter(30);
                                      Fluttertoast.showToast(msg: "Bir oylik qo'ng'iroqlar tarixi...");
                                      finish(context);
                                    },
                                    child: SizedBox(
                                      width: getScreenWidth(context),
                                      child: const Text(
                                        "Oylik",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "p_semi"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                      icon: const Icon(Icons.filter_alt_rounded))
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/contact2.png",
                        height: 16,
                        width: 16,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Kontakt".toUpperCase(),
                          style: TextStyle(
                            color: textColor,
                          )),
                    ],
                  ),
                )),
                Tab(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/chart.png",
                        height: 16,
                        width: 16,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Grafik".toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                )),
                Tab(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/month.png",
                        height: 15,
                        width: 15,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Oylik".toUpperCase(),
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            const Expanded(
              flex: 1,
              child: TabBarView(
                children: [
                  ContactReportScreen(),
                  ChartReportScreen(),
                  ChartReportScreen(),
                ],
              ),
            )
          ],
        )));
  }
}
