// ignore_for_file: avoid_print, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/model/base_model.dart';
import 'package:crm/model/event_model.dart';
import 'package:crm/model/state_model.dart';
import 'package:crm/utils/constants.dart';
import 'package:crm/utils/event_bus.dart';
import 'package:crm/utils/local_notification.dart';
import 'package:custom_ping/custom_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phone_plus/phone_plus.dart';
import 'package:phone_state/phone_state.dart';

import '../api/api_service.dart';
import '../model/audio_model.dart';
import '../utils/pref_utils.dart';

String? generalNumber;
StreamSubscription? subscription;
bool hasConnection = false;

void showNotificationMessage(String? description, String? title) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var android = const AndroidInitializationSettings('@mipmap/logo');
  var initSettings = InitializationSettings(
    android: android,
  );
  flutterLocalNotificationsPlugin.initialize(initSettings);

  String groupKey = 'com.example.general-notification-channel';
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'general-notification-channel',
    'general-notification-channel',
    importance: Importance.max,
    priority: Priority.high,
    groupKey: groupKey,
    //   setAsGroupSummary: true
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE',
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'CRM',
      initialNotificationContent: 'Ishlamoqda...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      // onBackground: onIosBackground,
    ),
  );

  service.startService();
}

void setStream() {
  int duration = 0;
  Timer? timer;
  PhoneState.stream.listen((event) async {
    if (event.status == PhoneStateStatus.CALL_ENDED) {
      timer?.cancel();
      PrefUtils.setLastDate(DateTime.now().toString().formatDateToEproch());
      String phone = "";
      if(generalNumber != ""||generalNumber!=null){
        phone = generalNumber!;
      }else if(event.number!=null){
        phone = event.number??"";
      }
      PrefUtils.addCallState(StateModelForPrefs(
          event.status.toString(),
          DateTime.now().toString().formatDateToEproch(),
          duration,
          phone,
          DateTime.now().toString()));
      print(
        "SAVE TO PREF DURATION: $duration DATE: ${DateTime.now()}",
      );
    } else if (event.status == PhoneStateStatus.CALL_STARTED) {
      duration = 0;
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          duration++;
        },
      );
    }
  });
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      /// OPTIONAL for use custom notification
      /// the notification id must be equals with AndroidConfiguration when you call configure() method.

      // if you don't using custom notification, uncomment this
      // service.setForegroundNotificationInfo(
      //   title: "BDM CALL RECORDER Ishlamoqda...",
      //   content: "Yangilanish: ${DateTime.now()}",
      // );
      PrefUtils.initInstance();
      initPhonecallstate();
      setStream();
      setConnectionStream();
      errorData.listen((event) {
        print("ERRORRRRRRRRRRRRR: $event");
        LocalNotification.showNotification("Xatolik yuz berdi!",
            "ERROR: ${(event)}",false,);
        eventBus.fire(EventModel(event: EVENT_SEND_AUDIO_ERROR, data: event));
      });
    }
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 12), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        runTicker();
        // eventBus.fire(EventModel(event: EVENT_NOTIFICATION, data: 0));
      }
    }
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  });
}

//------------------------------------------------------------------------------------------------------------

//RECORDINGS
String directory = "";
List<AudioModel> audioList = [];
List<FileSystemEntity> fileEntities = [];

listOfFiles() async {
  audioList = [];
  try {
    String directory = PrefUtils.getRecFolder();
    fileEntities = Directory(directory).listSync();
  } catch (e) {
    //
  }

  if (fileEntities.isEmpty) {} //use your folder name insted of resume.
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
}

//STREAMS
final StreamController<String> _errorStream = StreamController();

Stream<String> get errorData {
  return _errorStream.stream;
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> runTicker() async {
  // PrefUtils.clearCallState();
  print("START TICK   PREF COUNT: ${PrefUtils.getCallStateList().length}");
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtils.initInstance();
  PrefUtils.reload();
  await listOfFiles();

  List<StateModelForPrefs> prefLogList = PrefUtils.getCallStateList();
  StateModelForPrefs? prefLog;

  if (prefLogList.isEmpty) {
    print("CONNECTION STATUS:     $hasConnection");
    print("REEEEEEEEEEEEEEEEEEEEEETURN TICK");
    return;
  } //birinchi martada prefs yangilanmaydi shunga return
  prefLogList.sort((a, b) {
    return (b.date).compareTo(a.date);
  });

  prefLog = prefLogList.lastOrNull; // 10:00, 9:58,9:10... => 9:10

  String? path;
  int prefLogTime = prefLog?.date ?? 0;
  int prefLogDuration = (prefLog?.duration ?? 0);

  for (var audio in audioList) {
    int audioTime = (audio.date);
    print("LOG MIN: ${(prefLogTime.getMinuteOfEproch())} AUDIO ${audioTime.getMinuteOfEproch()}");
    print("LOG SEC: ${prefLogTime.getSecondOfEproch()} AUDIO ${audioTime.getSecondOfEproch()}");

    print("YEAR: ${prefLogTime.getYearOfEproch()}            ${audioTime.getYearOfEproch()}");
    print("MONT: ${prefLogTime.getMonthOfEproch()}            ${audioTime.getMonthOfEproch()}");
    print("DAYY: ${prefLogTime.getDayOfEproch()}            ${audioTime.getDayOfEproch()}");
    print("HOUR: ${prefLogTime.getHourOfEproch()}            ${audioTime.getHourOfEproch()}");
    print("MINU: ${prefLogTime.getMinuteOfEproch()}            ${audioTime.getMinuteOfEproch()}");
    print("SECO: ${prefLogTime.getSecondOfEproch()}            ${audioTime.getSecondOfEproch()}");
    if (
        // ((callLogTime - audioTime).abs() <= 20000)
        (prefLogTime.getYearOfEproch() == audioTime.getYearOfEproch()) &&
            (prefLogTime.getMonthOfEproch() == audioTime.getMonthOfEproch()) &&
            (prefLogTime.getDayOfEproch() == audioTime.getDayOfEproch()) &&
            (prefLogTime.getHourOfEproch() == audioTime.getHourOfEproch()) &&
            ((prefLogTime.getMinuteOfEproch() == audioTime.getMinuteOfEproch() &&
                    (prefLogTime.getSecondOfEproch() - audioTime.getSecondOfEproch()).abs() < 2) ||
                (((prefLogTime.getMinuteOfEproch() - audioTime.getMinuteOfEproch()).abs() == 1) &&
                    (prefLogTime.getSecondOfEproch() - audioTime.getSecondOfEproch()).abs() < 60))
        // && ((audioDuration - callLogDuration).abs() < 2)
        ) {
      print("TIMEEEEEEEEEEEEEEEEEEEEEEER TICK");
      final api = ApiService();
      final data = await api.sendAudio(audio.fullPath, prefLog?.phone ?? "", audioTime, _errorStream);

      if (data != null) {
        print("GENERAL NUMBER:  ${prefLog?.phone}");
        print("DATA:  ${data.toString()}");
        print("BEFORE LENGTH: ${PrefUtils.getCallStateList().length}");
        PrefUtils.removeCallState(prefLog!);
        await PrefUtils.setLastDate(int.parse(data.date));
        print("AFTER LENGTH: ${PrefUtils.getCallStateList().length}");
        LocalNotification.showNotification("REC: ${data.number} ${data.recordName}",
            PrefUtils.getLastDate().formatEprochToDate(), false);
        print(
            "REC:${"${data.number} ${data.recordName}"}, DATE: ${PrefUtils.getLastDate().formatEprochToDate()}");
        PrefUtils.reload();
        listOfFiles();
      }
      break;
    } else {}
  }
  if (path == null && hasConnection) {
    PrefUtils.removeCallState(prefLog!);
  } else if (prefLog != null) {}
  // showWarning(context, "Ishlab chiqilmoqda...".toUpperCase());
}

//------------------------------------------------------------------------------------------------------------
enum PhonePlusState {
  incomingReceived,
  incomingAnswered,
  incomingEnded,
  outgoingStarted,
  outgoingEnded,
  missedCall,
  none,
  error
}

late PhonePlus phonePlus;
late PhonePlusState phonePlusState;

void initPhonecallstate() async {
  debugPrint("PhonePlus init");

  phonePlus = PhonePlus();
  phonePlusState = PhonePlusState.none;

  phonePlus.setIncomingCallReceivedHandler((date, number) {
    phonePlusState = PhonePlusState.incomingReceived;
    generalNumber = number;
  });

  phonePlus.setIncomingCallAnsweredHandler((date, number) {
    phonePlusState = PhonePlusState.incomingAnswered;
    generalNumber = number;
  });

  phonePlus.setIncomingCallEndedHandler((date, number) {
    phonePlusState = PhonePlusState.incomingEnded;
    generalNumber = number;
  });

  phonePlus.setOutgoingCallStartedHandler((date, number) {
    phonePlusState = PhonePlusState.outgoingStarted;
    generalNumber = number;
  });

  phonePlus.setOutgoingCallEndedHandler((date, number) {
    phonePlusState = PhonePlusState.outgoingEnded;
    generalNumber = number;
  });

  phonePlus.setMissedCallHandler((date, number) {
    phonePlusState = PhonePlusState.missedCall;
    generalNumber = number;
  });

  phonePlus.setErrorHandler((msg) {
    phonePlusState = PhonePlusState.error;
  });
}

//CHECK CONNECTION
//-----------------------------------------------------------------------------------------------------------
void setConnectionStream() {
  subscription = PingService().getSubscription(callBack: (e) {
    // service =
    // 'Ping has connection ${e.hasConnection}, with ${e.getNetworkTye} count: $pingCount';
    hasConnection = e.hasConnection;
    // print("CHANGE CONNECTION ${e.hasConnection}  ${e.getNetworkTye}");
  });
}
