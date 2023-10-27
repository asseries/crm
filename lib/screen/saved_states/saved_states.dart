import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/app_colors.dart';
import '../../utils/utils.dart';

class SavedStatesScreen extends StatefulWidget {
  const SavedStatesScreen({Key? key}) : super(key: key);

  @override
  State<SavedStatesScreen> createState() => _SavedStatesScreenState();
}

class _SavedStatesScreenState extends State<SavedStatesScreen> {
  @override
  void initState() {
    PrefUtils.reload();
    Fluttertoast.showToast(msg: PrefUtils.getCallStateList().length.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text(
                  "Yozuvlar arxivi",
                  style: TextStyle(fontSize: 18, fontFamily: "p_bold"),
                )
              ],
            ),
          ),
          Expanded(
            child: PrefUtils.getCallStateList().isEmpty
                ? const Center(
                    child: Text(
                      "(Barcha yozuvlar jo'natilgan!)",
                      style: TextStyle(fontFamily: "p_semi"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: PrefUtils.getCallStateList().length,
                    itemBuilder: (context, index) {
                      var item = PrefUtils.getCallStateList()[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.BLACK.withOpacity(.2),
                              blurRadius: 4,
                              blurStyle: BlurStyle.outer
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.duration.toString()),
                            Text(item.date.formatEprochToDate()),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
