import 'package:crm/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/contact_model.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';

class SmsScreen extends StatefulWidget {
  final ContactModel? contact;

  SmsScreen({Key? key, required this.contact}) : super(key: key);

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final messageController = TextEditingController();

  Future _sendSMS(String message, List<String> recipents) async {
    String result = await sendSMS(message: message, recipients: recipents).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
      print(onError);
      return false;
    });
    print(result);
    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();

    return Scaffold(
      body: widget.contact != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  getStatusBarWidget(context),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: getScreenWidth(context),
                    height: 56,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              finish(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Expanded(
                          child: Text(
                            widget.contact?.name ?? "".toUpperCase(),
                            style: asTextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "p_semi",
                              size: 16,
                            ),
                          ),
                        ),
                        const Icon(Icons.more_vert_outlined)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: asTextField(context,
                        minLines: 8,
                        controller: messageController,
                        borderWidth: .5,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  asButton(context,
                      backgroundColor:
                          themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
                      width: getScreenWidth(context),
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        "Jo'natish".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "p_bold",
                        ),
                      ), onPressed: () async {
                    if ((widget.contact?.number ?? "").isEmpty) {
                      Fluttertoast.showToast(msg: "Telefon raqami mavjud emas!");
                    }
                    await _sendSMS(messageController.text, [widget.contact?.number ?? ""]);
                      finish(context);
                    })
                ],
              ),
            )
          : const Center(
              child: Text("Kontakt mavjud emas!"),
            ),
    );
  }
}
