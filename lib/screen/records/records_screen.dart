import 'dart:io';

import 'package:animated_page_transition/animated_page_transition.dart';
import 'package:as_toast_x/functions.dart';
import 'package:crm/api/main_view_model.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/utils/constants.dart';
import 'package:crm/utils/hero_pusher_page_animation.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:crm/view/audio_item_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety.dart';

import '../../model/audio_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';
import '../../view/player_item_view.dart';
import '../player_screen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key,}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> with TickerProviderStateMixin {
  String directory = "";
  List<AudioModel> audioList = [];
  List<FileSystemEntity> fileEntities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listOfFiles();
  }

  // Make New Function
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
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    InkWell(
                      onTap: () {
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
                      "Audio yozuvlar",
                      style: TextStyle(fontSize: 18, fontFamily: "p_bold"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: audioList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HeroPusher(
                            vsync: this,
                            nextPage: PlayerScreen(audio: audioList[index]),
                            child: PlayerItemView(
                              audio: audioList[index],
                            ));
                      }),
                ),
              )
            ],
          ),
        );
      },
      onModelReady: (viewModel) {
        viewModel.audioStream.listen((event) {
          if (event == true) {
            showSuccess(context, event.toString());
          }
        });

        viewModel.errorData.listen(
          (event) {
            showError(
              context,
              event,
            );
          },
        );
      },
    );
  }

  Future<void> sendAudio(String fullPath) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("${BASE_URL}record/audio".substring(0, "${BASE_URL}sendAudio".length)));
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-Mobile-Type": "android",
      "token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsImlhdCI6MTY4MzAwOTc2OCwiZXhwIjoxNjgzMDk2MTY4fQ.Sz0yjcSUMtANYpV_cnPmooKsL_yTFXknYgMetrZketc",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsImlhdCI6MTY4MzAwOTc2OCwiZXhwIjoxNjgzMDk2MTY4fQ.Sz0yjcSUMtANYpV_cnPmooKsL_yTFXknYgMetrZketc",
    };
    request.headers.addAll(headers);
    request.fields['phone_number'] = '998995160061';
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        fullPath,
        contentType: MediaType('audio', fullPath.split('.').last),
      ),
    );
    request.send().then((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
      }
    });
  }

  void sendRequest(audioPath) {
    var request = MultipartRequest();

    request.setUrl("http://176.53.163.29:3030/api/v1/record/audio");
    request.addFile("audio", audioPath);

    Response response = request.send();

    response.onError = () {
      print("Error");
      showError(context, "Error");
    };

    response.onComplete = (response) {
      print(response);
      showSuccess(context, response.toString());
    };

    response.progress.listen((int progress) {
      print("progress from response object " + progress.toString());
    });
  }
}
