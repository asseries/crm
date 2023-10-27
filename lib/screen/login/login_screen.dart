import 'package:as_toast_x/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:wave_transition/wave_transition.dart';

import '../../api/main_view_model.dart';
import '../../main/main_screen.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/pref_utils.dart';
import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY,
      body: ViewModelBuilder.reactive(viewModelBuilder: () => MainViewModel(), builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: SizedBox(
            height: getScreenHeight(context),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getScreenHeight(context)/8,),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/3d/secured.png",
                            width: getScreenWidth(context) / 3,
                          )),
                      const SizedBox(height: 20,),
                      Text(
                        "Tizimga kirish uchun login va parolni kiriting!",
                        style: TextStyle(
                            fontSize: 24,
                            color: PrefUtils.getThemeMode() == ThemeMode.light
                                ? AppColors.COLOR_PRIMARY
                                : AppColors.COLOR_PRIMARY2,
                            fontFamily: "p_semi"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //LOGIN
                      Text(
                        "Login".toUpperCase(),
                        style: TextStyle(
                          fontFamily: "p_semi",
                          color: themeMode == ThemeMode.dark ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: themeMode == ThemeMode.dark ? AppColors.COLOR_PRIMARY2 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          maxLength: 32,
                          controller: loginController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          style: TextStyle(
                              color:
                              themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.COLOR_PRIMARY),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      //PASSWORD
                      Text(
                        "Parol".toUpperCase(),
                        style: TextStyle(
                          fontFamily: "p_semi",
                          color: themeMode == ThemeMode.dark ? AppColors.COLOR_PRIMARY2 : AppColors.COLOR_PRIMARY,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: themeMode == ThemeMode.dark ? AppColors.COLOR_PRIMARY2 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          maxLength: 32,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          style: TextStyle(
                              color:
                              themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.COLOR_PRIMARY),
                        ),
                      ),
                      const Expanded(child: Center()),
                      asButton(context,
                          backgroundColor: PrefUtils.getThemeMode() == ThemeMode.light
                              ? AppColors.COLOR_PRIMARY
                              : AppColors.ACCENT,
                          height: 50,
                          width: getScreenWidth(context),
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () async {
                            if(loginController.text.length<3||passwordController.text.length<3){
                              showWarning(context, "Iltimos login yoki parolni to'liqroq kiriting!");
                            }else{
                              viewModel.login(loginController.text, passwordController.text);
                            }
                          },
                          child: Text(
                            "Kirish".toUpperCase(),
                            style: const TextStyle(fontFamily: "p_bold"),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
                if(viewModel.progressData)
                  showAsProgress()
              ],
            ),
          ),
        );
      }, onModelReady: (viewModel) {
        viewModel.errorData.listen((event) {
          showError(context, event);
        });

        viewModel.loginConfirmData.listen((event) {
          if(event.token.isNotEmpty){
            Navigator.pushAndRemoveUntil(
              context,
              WaveTransition(
                  child: const MainScreen(),
                  center: const FractionalOffset(0.0, 0.0),
                  duration: const Duration(milliseconds: 1000),
                  settings: const RouteSettings(arguments: "BDM")),
                  (route) => false,
            );
          }
        });
      },
      ),
    );
  }
}
