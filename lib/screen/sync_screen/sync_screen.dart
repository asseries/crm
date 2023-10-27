// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:collection/collection.dart';
import 'package:crm/api/main_view_model.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/screen/player_screen.dart';
import 'package:crm/utils/constants.dart';
import 'package:crm/utils/hero_pusher_page_animation.dart';
import 'package:crm/utils/project_utils.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../api/api_service.dart';
import '../../model/audio_model.dart';
import '../../model/event_model.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/blinking_button_x.dart';
import '../../utils/event_bus.dart';
import '../../utils/pref_utils.dart';
import '../../view/audio_item_view.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> with WidgetsBindingObserver {
  bool loading = true;
  StreamSubscription? busEventListener;

  //CALL LOG
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  List<CallLogEntry> callLogList = [];

  //RECORDINGS
  String directory = "";
  List<AudioModel> audioList = [];
  List<FileSystemEntity> fileEntities = [];

//TIMER
  Timer? _myTimer;

  listOfFiles() async {
    audioList = [];
    try {
      String directory = PrefUtils.getRecFolder();
      fileEntities = Directory(directory).listSync();
    } catch (e) {}

    if (fileEntities.isEmpty) {
      loading = false;
    } //use your folder name insted of resume.
    for (var element in fileEntities) {
      try {
        var fileDate = ((File(element.path).lastModifiedSync().microsecondsSinceEpoch ~/ 10000000)) * 10000;
        // if (fileDate <= PrefUtils.getLastDate()) {
        //   continue; //demak jo'natilgan
        // }
        audioList.add(AudioModel(element.path, element.path.split('/').last, fileDate, false, ""));
      } catch (_) {}
    }

    audioList.sort((a, b) {
      return b.date.compareTo(a.date); // 10:00, 9:58,9:10...
    });

    for (var e in audioList) {
      if (e.date <= PrefUtils.getLastDate()) {
        e.sent = true;
      }
    }

    loading = false;
    setState(() {});
  }

  //CALL LOG
  getCallLogs() async {
    _callLogEntries = await CallLog.query();
    setState(() {
      callLogList = _callLogEntries
          .where((element) =>
              (((element.duration ?? 0) > 0) && (element.timestamp ?? 0) > PrefUtils.getLastDate()))
          .toList();
      print("CALL LOG LIST COUNT: ${callLogList.length}");
    });
  }

  //STREAMS
  final StreamController<String> _errorStream = StreamController();
  Stream<String> get errorData {
    return _errorStream.stream;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      Fluttertoast.showToast(msg: "PAUSED");
      finish(context);
    }
    setState(() {});
  }

  @override
  void initState() {
    // PrefUtils.setLastDate(1);
    PrefUtils.reload();
    listOfFiles();
    getCallLogs();
    WidgetsBinding.instance.addObserver(this);
    busEventListener = eventBus.on<EventModel>().listen((event) {
      if (event.event == EVENT_NOTIFICATION) {
        Fluttertoast.showToast(msg: event.data.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    return HeroPusherReceiver(
      scaffold: Scaffold(
        body: ViewModelBuilder<MainViewModel>.reactive(
          viewModelBuilder: () => MainViewModel(),
          builder: (context, viewModel, child) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        getStatusBarWidget(context),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: getScreenWidth(context) - 17,
                          height: 56,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: AppColors.BLACK.withOpacity(.2),
                                blurRadius: 4,
                                blurStyle: BlurStyle.outer)
                          ]),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    finish(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_rounded)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sinxronizatsiya".toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: "p_semi",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: getScreenWidth(context),
                          color: themeMode == ThemeMode.light ? AppColors.ACCENT : AppColors.ACCENT,
                          child: Text(
                            "Sinxronizatsiya qilinadigan yozuvlar: ${audioList.where((element) => !element.sent).length}",
                            style: TextStyle(fontFamily: "p_med", color: AppColors.BLACK),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: audioList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AudioItemView(
                                audio: audioList[index],
                                onClick: () {
                                  startScreen(context, screen: PlayerScreen(audio: audioList[index]));
                                });
                          }),
                    ),
                    const SizedBox(
                      height: 65,
                    )
                  ],
                ),
                BlinkButtonX(
                    onTap: () async {
                      await getCallLogs();
                      await listOfFiles();
                      PrefUtils.reload();
                      // _myTimer?.cancel(); //in case we have a timer, we'll cancel it.
                      // _myTimer = Timer.periodic(15.seconds, (timer) async {
                      CallLogEntry? callLog;

                      if (callLogList.isEmpty) {
                        print("REEEEEEEEEEEEEEEEEEEEEETURN TICK");
                        return;
                      } //birinchi martada prefs yangilanmaydi shunga return
                      print("TIMEEEEEEEEEEEEEEEEEEEEEEER TICK");

                      callLogList.sort((a, b) {
                        return (b.timestamp ?? 0).compareTo(a.timestamp ?? 0);
                      });

                      callLog = callLogList.lastOrNull; // 10:00, 9:58,9:10... => 9:10

                      String? path;
                      int callLogTime = (callLog?.timestamp ?? 0);
                      int callLogDuration = (callLog?.duration ?? 0);

                      for (var audio in audioList) {
                        int audioTime = (audio.date);
                        int audioDuration = (await getAudioDuration(audio.fullPath)/1000).floor();
                        print("LOG DURATION: $callLogDuration");
                        print("FILE DURATION: $audioDuration");
                        if (((callLogTime - audioTime).abs() <= 20000) &&((audioDuration-callLogDuration).abs()<2)) {
                          final api = ApiService();
                          final data = await api.sendAudio(
                              audio.fullPath, callLog?.number ?? "", audioTime, _errorStream);
                          if (data != null) {
                            PrefUtils.setLastDate(int.parse(data.date));
                            listOfFiles();
                            getCallLogs();
                          }
                          setState(() {});
                          print("DIFFERENCE:  ${(callLogTime - audioTime).abs()}");
                          break;
                        }
                        print("DIFFERENCE:  ${(callLogTime - audioTime).abs()}");
                      }
                      if (path == null) {

                      } else if (callLog != null) {}
                      // showWarning(context, "Ishlab chiqilmoqda...".toUpperCase());
                    },
                    child: asBluredForeground(
                        color: themeMode == ThemeMode.light ? AppColors.COLOR_PRIMARY : AppColors.ACCENT,
                        borderRadius: BorderRadius.circular(4),
                        margin: const EdgeInsets.all(16),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.BLACK.withOpacity(.2),
                              blurRadius: 4,
                              blurStyle: BlurStyle.outer)
                        ],
                        height: 40,
                        alignmet: Alignment.center,
                        width: getScreenWidth(context),
                        child: Text(
                          "Sinxronizatsiya".toUpperCase(),
                          style: TextStyle(
                            fontFamily: "p_semi",
                            color: themeMode == ThemeMode.dark
                                ? AppColors.COLOR_PRIMARY
                                : AppColors.COLOR_PRIMARY2,
                          ),
                        ))),
                if (loading) showAsProgress()
              ],
            );
          },
          onModelReady: (viewModel) {
            _myTimer?.cancel(); //in case we have a timer, we'll cancel it.
            _myTimer = Timer.periodic(12.seconds, (timer) {

            });

            viewModel.errorData.listen((event) {
              Fluttertoast.showToast(msg: event);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    busEventListener?.cancel();
    _myTimer?.cancel();
    super.dispose();
  }
}
